#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]
HOOKS_DIR = PROJECT_ROOT / ".codex" / "hooks"
CHECKS_CONFIG_PATH = HOOKS_DIR / "project_checks.json"
CHECKS_LOG_PATH = HOOKS_DIR / "logs" / "project_checks.log"
MAX_MESSAGE_LENGTH = 180


def normalize_message(value: object) -> str:
    if isinstance(value, list):
        text = " | ".join(str(item) for item in value if item)
    elif value is None:
        text = ""
    else:
        text = str(value)

    text = " ".join(text.split())
    if len(text) > MAX_MESSAGE_LENGTH:
        return f"{text[: MAX_MESSAGE_LENGTH - 1]}…"
    return text or "Codex requires attention."


def is_project_event(payload: dict[str, object]) -> bool:
    cwd = payload.get("cwd")
    if not isinstance(cwd, str) or not cwd:
        return False

    try:
        cwd_path = Path(cwd).resolve()
        cwd_path.relative_to(PROJECT_ROOT)
    except (OSError, ValueError):
        return False

    return True


def build_notification(payload: dict[str, object]) -> tuple[str, str, str] | None:
    event_type = payload.get("type")
    if event_type == "agent-turn-complete":
        message = normalize_message(payload.get("last-assistant-message"))
        return ("Codex finished", PROJECT_ROOT.name, message)

    if event_type == "approval-requested":
        message = normalize_message(payload.get("reason") or payload.get("input-messages"))
        return ("Codex approval requested", PROJECT_ROOT.name, message)

    return None


def send_macos_notification(title: str, subtitle: str, message: str) -> None:
    script = (
        f"display notification {json.dumps(message)} "
        f"with title {json.dumps(title)} "
        f"subtitle {json.dumps(subtitle)}"
    )
    subprocess.run(["osascript", "-e", script], check=False)


def emit_notification(title: str, subtitle: str, message: str) -> None:
    if os.environ.get("CODEX_NOTIFY_DRY_RUN") == "1":
        print(json.dumps({"title": title, "subtitle": subtitle, "message": message}))
        return

    if sys.platform == "darwin":
        send_macos_notification(title, subtitle, message)


def load_checks_config() -> dict[str, object] | None:
    if not CHECKS_CONFIG_PATH.is_file():
        return None

    try:
        data = json.loads(CHECKS_CONFIG_PATH.read_text())
    except (OSError, json.JSONDecodeError):
        return None

    return data if isinstance(data, dict) else None


def command_is_enabled(command: dict[str, object]) -> bool:
    requires = command.get("requires", [])
    if not isinstance(requires, list):
        return False

    for relative_path in requires:
        if not isinstance(relative_path, str):
            return False
        if not (PROJECT_ROOT / relative_path).exists():
            return False

    return True


def append_log(lines: list[str]) -> None:
    CHECKS_LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    with CHECKS_LOG_PATH.open("a", encoding="utf-8") as handle:
        handle.write("\n".join(lines))
        handle.write("\n")


def summarize_output(text: str) -> str:
    cleaned = " ".join(text.split())
    return normalize_message(cleaned)


def spawn_background_checks(payload: dict[str, object]) -> None:
    if os.environ.get("CODEX_NOTIFY_SKIP_BACKGROUND_CHECKS") == "1":
        return

    command = [
        sys.executable,
        str(Path(__file__).resolve()),
        "--run-checks",
        json.dumps(payload),
    ]
    env = os.environ.copy()
    env["CODEX_NOTIFY_SKIP_BACKGROUND_CHECKS"] = "1"
    subprocess.Popen(
        command,
        cwd=str(PROJECT_ROOT),
        env=env,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )


def run_background_checks(payload: dict[str, object]) -> int:
    config = load_checks_config()
    if config is None:
        return 0

    commands = config.get("commands", [])
    if not isinstance(commands, list):
        return 0

    timeout_sec = config.get("timeoutSec", 900)
    timeout_sec = timeout_sec if isinstance(timeout_sec, int) and timeout_sec > 0 else 900

    runnable_commands = [
        command for command in commands if isinstance(command, dict) and command_is_enabled(command)
    ]
    if not runnable_commands:
        return 0

    started_at = datetime.now(timezone.utc).isoformat()
    results: list[dict[str, object]] = []

    for command in runnable_commands:
        name = command.get("name", "unnamed check")
        argv = command.get("argv", [])
        workdir = command.get("workdir", ".")
        if not isinstance(name, str) or not isinstance(argv, list) or not all(isinstance(arg, str) for arg in argv):
            continue
        if not isinstance(workdir, str):
            workdir = "."

        try:
            completed = subprocess.run(
                argv,
                cwd=str(PROJECT_ROOT / workdir),
                capture_output=True,
                text=True,
                timeout=timeout_sec,
                check=False,
            )
            results.append(
                {
                    "name": name,
                    "argv": argv,
                    "exitCode": completed.returncode,
                    "stdout": summarize_output(completed.stdout[-1200:]),
                    "stderr": summarize_output(completed.stderr[-1200:]),
                }
            )
        except subprocess.TimeoutExpired:
            results.append(
                {
                    "name": name,
                    "argv": argv,
                    "exitCode": "timeout",
                    "stdout": "",
                    "stderr": f"Timed out after {timeout_sec}s",
                }
            )

    if not results:
        return 0

    failed = [result for result in results if result["exitCode"] != 0]
    passed_count = len(results) - len(failed)

    log_lines = [
        f"[{started_at}] payload={json.dumps(payload, ensure_ascii=True)}",
    ]
    for result in results:
        log_lines.append(
            json.dumps(
                {
                    "name": result["name"],
                    "argv": result["argv"],
                    "exitCode": result["exitCode"],
                    "stdout": result["stdout"],
                    "stderr": result["stderr"],
                },
                ensure_ascii=True,
            )
        )
    append_log(log_lines)

    if failed:
        first_failure = failed[0]
        message = f"{passed_count}/{len(results)} passed. {first_failure['name']} failed: {first_failure['stderr'] or first_failure['stdout']}"
        emit_notification("Codex checks failed", PROJECT_ROOT.name, normalize_message(message))
        return 0

    successful_names = ", ".join(str(result["name"]) for result in results)
    emit_notification("Codex checks passed", PROJECT_ROOT.name, normalize_message(successful_names))
    return 0


def main() -> int:
    if len(sys.argv) >= 3 and sys.argv[1] == "--run-checks":
        try:
            payload = json.loads(sys.argv[2])
        except json.JSONDecodeError:
            return 0
        return run_background_checks(payload if isinstance(payload, dict) else {})

    if len(sys.argv) < 2:
        return 0

    try:
        payload = json.loads(sys.argv[1])
    except json.JSONDecodeError:
        return 0

    if not isinstance(payload, dict) or not is_project_event(payload):
        return 0

    notification = build_notification(payload)
    if notification is None:
        return 0

    title, subtitle, message = notification
    emit_notification(title, subtitle, message)
    if payload.get("type") == "agent-turn-complete":
        spawn_background_checks(payload)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
