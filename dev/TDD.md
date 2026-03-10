# Flutter Anatomy Lab TDD

- 문서 버전: v1.1
- 상태: Draft (Reviewed)
- 작성일: 2026-03-09
- 프로젝트명(가칭): **Flutter Anatomy Lab**
- 대상 플랫폼: **Flutter Web 우선**

---

## 1. 문서 목적

이 문서는 Flutter Anatomy Lab의 기술 설계를 정의한다. 목표는 `ElevatedButton`을 시작점으로 삼아, Flutter 위젯의 구조를 학습하는 교육 플랫폼을 **확장 가능하고 테스트 가능하며 웹 배포 친화적인 구조**로 구현하는 것이다.

Flutter 공식 아키텍처 가이드는 UI layer와 Data layer 분리, layered architecture, single source of truth, unidirectional data flow, testability를 핵심 원칙으로 설명한다. 이 문서는 그 원칙을 따르되, 상태관리는 Riverpod로 표준화하고 웹 라우팅/콘텐츠 시스템/선택적 백엔드 전략을 더한 형태로 구체화한다.[T1][T2][T3]

---

## 2. 설계 원칙

### 2.1 핵심 원칙

1. **Separation of concerns**
   - UI 렌더링, 상태 조정, 콘텐츠 로딩, 사용자 저장소를 분리한다.
2. **Single source of truth**
   - lesson 데이터는 Content Repository, 진도 데이터는 Progress Repository가 각각 단일 진실 원천이 된다.
3. **Unidirectional data flow**
   - 사용자 입력 → controller/notifier → repository → state → UI 재렌더 흐름을 유지한다.
4. **Testability first**
   - provider override, repository mock, content snapshot 검증이 쉬운 구조를 택한다.
5. **Static-first**
   - MVP는 정적 콘텐츠와 로컬 저장 기반으로 동작 가능해야 한다.

Flutter 공식 문서는 이런 분리 구조를 강하게 권장하며, feature 또는 type 기준 패키지 구조를 혼합해 사용할 수 있다고 설명한다.[T1][T2][T3]

---

## 3. 기술 스택 결정

## 3.1 최종 권장 스택

| 영역 | 선택 | 비고 |
|---|---|---|
| 프론트엔드 런타임 | Flutter Web | MVP 주 플랫폼 |
| 라우팅 | `go_router` + `Router` API | deep link / URL sync |
| 상태관리 | `flutter_riverpod` (Riverpod 3 계열) | `Notifier` / `AsyncNotifier` 중심 |
| 콘텐츠 포맷 | Markdown + YAML frontmatter + 정적 JSON manifest | 정적 배포 친화적 |
| 디자인 시스템 | Material 3 우선, M2 비교 모드 지원 | 학습용 비교 기능 포함 |
| 로컬 저장 | ProgressRepository(Local) 추상화 | 브라우저 저장소(LocalStorage 우선, 필요 시 IndexedDB 확장) |
| 선택적 백엔드 | Firebase Auth / Firestore / Hosting / Analytics | 로그인·동기화·배포용 |
| 테스트 | `flutter_test`, `integration_test`, repository/provider tests | CI 및 회귀 방지 기준 포함 |
| 개발 도구 | Flutter Inspector, Widget Previewer(저작용), Firebase Emulator Suite | 운영앱 직접 의존 금지 |

---

## 4. 상태관리 도구 선정: Riverpod vs Provider vs GetX

## 4.1 결론

**이 프로젝트의 표준 상태관리 도구는 Riverpod이다.**

## 4.2 선정 이유

Riverpod 공식 문서는 Provider와 달리 provider를 widget tree 밖의 plain Dart object로 정의할 수 있다고 설명한다. 또한 `ProviderScope` / `ProviderContainer` 구조, override 기능, 테스트 유틸리티, 코드 생성, `AsyncValue` 기반 비동기 처리, `Notifier` 계열 API는 학습 플랫폼처럼 상태 종류가 많은 앱에 유리하다.[T4][T5][T6][T7][T8]

특히 Riverpod 3 문서는 다음을 보여준다.

- provider state는 `ProviderContainer`가 보관한다.[T5]
- Flutter 앱은 루트에 `ProviderScope`를 둔다.[T5]
- provider override는 테스트/디버깅/환경 분리에 유용하다.[T6]
- class-based provider는 public method를 통해 side-effect를 관리할 수 있다.[T7]
- `StateNotifierProvider`와 `StateProvider`는 새 API 기준으로 피하는 방향이며 `Notifier` 사용이 권장된다.[T8]

## 4.3 비교 요약

| 항목 | Provider | Riverpod | GetX |
|---|---|---|---|
| 프로젝트 표준 채택 여부 | 보류 | **채택** | 미채택 |
| widget tree 의존성 | 높음 | 낮음 | 프로젝트 표준 아님 |
| 테스트 용이성 | 보통 | 높음 | 프로젝트 표준 아님 |
| 확장성/명시성 | 보통 | 높음 | 프로젝트 표준 아님 |
| 이 프로젝트 적합성 | 샘플 수준 대안 | **가장 적합** | 팀 규약상 비표준 |

참고로 Flutter 공식 case study는 `provider` 기반 예시를 제시하지만, 공식 문서도 “guideline이지 고정 규칙은 아니다”라고 밝힌다. 따라서 본 프로젝트는 Riverpod를 채택하되, Flutter가 권장하는 layer/view model/repository 철학은 그대로 가져간다.[T1][T3]

---

## 5. 프론트엔드 아키텍처

## 5.1 전체 구조

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router.dart
  core/
    theme/
    l10n/
    analytics/
    errors/
    logging/
  content/
    models/
    parsers/
    repositories/
    manifests/
  features/
    catalog/
      presentation/
      application/
    lesson/
      presentation/
      application/
    playground/
      presentation/
      application/
    progress/
      application/
      data/
    search/
      presentation/
      application/
    auth/
      application/
      data/
  shared/
    widgets/
    diagrams/
    code_viewer/
    layout/
```

## 5.2 레이어 역할

### UI Layer

- Screen / Page
- reusable widget
- route shell
- animation / interaction 표현

### Application Layer

- Notifier / AsyncNotifier
- use-case 수준의 orchestration
- view state 변환

### Data Layer

- repository interface
- local/remote data source
- content parser
- analytics adapter
- parse/storage 오류를 UI 친화적 실패 상태로 번역하는 error mapping

Flutter 아키텍처 가이드는 View, ViewModel, Repository, Service 형태의 분리를 추천하며, feature별 UI 계층과 공유 data layer를 조합하는 방식을 설명한다.[T1][T3]

---

## 6. 라우팅 전략

## 6.1 선택

- `Router` API 기반
- 구현 패키지: `go_router`
- URL 전략: **Path URL strategy**

Flutter 공식 문서는 웹에서 주소창과 동기화되고 deep link를 제대로 처리하려면 `Router` 계열 구성이 필요하다고 설명하며, named route는 대부분의 앱에 권장되지 않는다고 안내한다. `go_router`는 Flutter 공식 퍼블리셔가 제공하는 URL 기반 라우팅 패키지다.[T9][T10]

## 6.2 URL 설계

```text
/
/widgets
/widgets/:widgetId
/widgets/:widgetId/anatomy/:sectionId
/tracks/:trackId
/search?q=
/settings
```

예시:

- `/widgets/elevated_button`
- `/widgets/elevated_button/anatomy/style-resolution`

## 6.3 웹 URL 전략

Flutter 웹은 hash/path 전략을 모두 지원하지만, 이 제품은 공유 가능한 학습 URL과 SEO/가독성을 위해 path 전략을 기본으로 채택한다. 단, path 전략은 웹서버가 모든 요청을 `index.html`로 rewrite하도록 설정되어야 한다.[T11]

Firebase Hosting 사용 시 SPA rewrite 설정을 적용한다.[T11][T12]

---

## 7. 콘텐츠 시스템 설계

## 7.1 왜 정적 콘텐츠 중심인가

MVP는 lesson 콘텐츠가 앱의 핵심이므로, 콘텐츠를 코드와 함께 버전 관리하는 편이 빠르고 저렴하다. 또한 별도 백엔드 없이도 배포가 가능하다.

## 7.2 콘텐츠 포맷

각 lesson은 아래 3개 파일로 관리한다.

```text
content/
  widgets/
    elevated_button/
      lesson.md
      anatomy.json
      quiz.json
```

### `lesson.md`

- frontmatter: id, title, difficulty, tags, sourceRefs, contentVersion, lastReviewedAt
- 본문: overview, key concepts, explanation blocks

### `anatomy.json`

- 구조 노드 정의
- source link 매핑
- tab/section metadata
- playground control schema
- stable node id 및 edge 정의

### `quiz.json`

- 문제/선지/해설
- section 연결 정보와 난이도 메타데이터

## 7.3 빌드 파이프라인

1. author가 Markdown/JSON 작성
2. validation script가 schema 검증
3. build 단계에서 manifest와 검색 인덱스 생성
4. 앱은 typed repository를 통해 lesson 로드

## 7.4 lesson 스키마 예시

```yaml
id: elevated_button
kind: widget
library: material
related:
  - button_style_button
  - button_style
  - elevated_button_theme
contentVersion: 1
lastReviewedAt: 2026-03-09
sections:
  - overview
  - public_api
  - style_resolution
  - runtime_structure
  - semantics
playground:
  controls:
    - onPressed
    - icon
    - useMaterial3
    - foregroundColor
    - backgroundColor
    - elevation
```

---

## 8. 저작 도구(Authoring) 전략

운영 앱이 Flutter DevTools나 Widget Previewer에 직접 의존하면 제품 안정성이 떨어진다. 따라서 아래 원칙을 사용한다.

1. **운영 앱**: curated data + 자체 시각화 사용
2. **저작 환경**: Flutter Inspector / Widget Previewer를 참고 도구로 사용

Flutter Inspector는 widget tree, 구현 위젯, size/constraints 확인에 유용하고, Widget Previewer는 widget을 앱 전체와 분리해서 빠르게 확인하는 데 유용하다. 다만 Widget Previewer는 공식 문서 기준 실험적 기능이므로, 운영 서비스 의존성이 아니라 **콘텐츠 제작 참고 도구**로만 사용한다.[T13][T14]

---

## 9. ElevatedButton 파일럿 모듈의 기술 설계

## 9.1 공식 구조에서 끌어올 핵심 포인트

`ElevatedButton` lesson은 아래 사실을 학습 흐름으로 번역한다.

1. `ElevatedButton`은 `ButtonStyleButton`을 상속하는 `StatefulWidget`이다.[T15][T16]
2. `ButtonStyle`은 버튼 공통 시각 속성 모델이며, 기본값은 null이고 실제 기본값은 각 버튼 구현체와 theme에서 채워진다.[T17]
3. `style`의 non-null 값은 `themeStyleOf`와 `defaultStyleOf`를 override하며, 최종 값 선택은 `widgetValue ?? themeValue ?? defaultValue` 순서다.[T18]
4. `ElevatedButton`은 subtree의 `ElevatedButtonTheme`와 app-level `ThemeData.elevatedButtonTheme`를 통해 스타일을 오버라이드할 수 있다.[T15]
5. `statesController`는 pressed/focused 같은 `WidgetState` 집합을 다룬다.[T15][T16]
6. `onPressed`와 `onLongPress`가 모두 null이면 disabled다.[T15][T18]
7. Material 3 기본값은 소스에서 따로 정의되며, 예시로 `surfaceContainerLow`, `primary`, `StadiumBorder`, `Size(64, 40)` 같은 차이를 확인할 수 있다.[T19]
8. Flutter는 Widget/Element/RenderObject를 분리하고 constraints down / sizes up 방식으로 layout을 수행한다.[T20][T21]

## 9.2 Lesson 탭 매핑

| 탭 | 기술 근거 | 사용자 경험 |
|---|---|---|
| Overview | ElevatedButton API | 언제 쓰는지 빠른 이해 |
| Public API | ElevatedButton / ButtonStyleButton API | 생성자, 속성, 상속 구조 확인 |
| Style Resolution | ButtonStyle / source | style-theme-default 우선순위 이해 |
| State Simulator | statesController / WidgetState | hover/focus/press/disabled 실험 |
| Runtime Structure | architecture docs / inspector | 위젯-트리-레이아웃 이해 |
| Accessibility | Semantics / web accessibility | role, label, tooltip 이해 |
| Quiz | 자체 콘텐츠 | 학습 고정 |

## 9.3 내부 상태 모델

```dart
@riverpod
Future<LessonModel> lesson(LessonRef ref, String widgetId) async {
  return ref.watch(contentRepositoryProvider).getLesson(widgetId);
}

@riverpod
class PlaygroundController extends _$PlaygroundController {
  @override
  PlaygroundState build(String widgetId) => PlaygroundState.initial(widgetId);

  void setMaterial3(bool value) { ... }
  void setDisabled(bool value) { ... }
  void setForegroundColor(String value) { ... }
  void setBackgroundColor(String value) { ... }
}
```

## 9.4 Preview 구현 원칙

- 임의 사용자 코드 실행은 하지 않는다.
- lesson마다 미리 준비된 sample widget builder를 사용한다.
- `widgetId -> preview builder` 매핑은 명시적 registry로 관리한다.
- control 변경은 typed state로만 전달한다.

이 방식은 보안/복잡도/성능 측면에서 MVP에 가장 적합하다.

---

## 10. 상태 모델 상세

## 10.1 주요 Provider 분류

### Content

- `lessonProvider(widgetId)`
- `catalogProvider()`
- `searchIndexProvider()`

### Playground

- `playgroundControllerProvider(widgetId)`
- `previewSpecProvider(widgetId)`

### Progress

- `progressControllerProvider()`
- `bookmarksProvider()`
- `localProgressRepositoryProvider()`

### Auth (선택 기능)

- `authStateProvider()`
- `currentUserProvider()`

### App shell

- `themeModeProvider()`
- `localeProvider()`

## 10.2 Riverpod 사용 규칙

- state mutation은 `Notifier` / `AsyncNotifier`에 한정
- UI는 `ref.watch`, side effect는 `ref.listen`
- 테스트는 `ProviderContainer.test()` 또는 widget test 내부 container 접근 사용
- experimental offline persistence는 MVP에서 사용하지 않음

Riverpod 3는 새 테스트 유틸리티와 override 메커니즘을 제공하지만, offline persistence는 아직 experimental이다. 따라서 본 프로젝트는 core API만 사용한다.[T6][T8]

---

## 11. 선택적 백엔드 설계

## 11.1 MVP 결론

**MVP에는 필수 백엔드가 없다.**

- lesson 콘텐츠: 정적 자산
- progress/bookmark: 로컬 저장
- search: 정적 인덱스
- 네트워크 실패 시에도 핵심 lesson 탐색과 로컬 진도 기록은 유지되어야 한다.

## 11.2 백엔드가 필요한 시점

아래 기능이 필요해지면 Firebase 기반 백엔드를 붙인다.

- 로그인/회원별 진도 동기화
- 여러 기기 간 이어보기
- 팀/스터디 기능
- 피드백 수집
- 운영 지표 분석

## 11.3 권장 백엔드 스택 (Phase 2)

### Firebase Authentication

- 이메일/소셜 로그인
- auth state stream 기반 세션 동기화

Firebase Auth의 Flutter 문서는 인증 상태 변화를 stream으로 구독할 수 있다고 설명한다.[T22]

### Cloud Firestore

- user progress
- bookmarks
- feedback
- lesson rating

Cloud Firestore는 클라이언트 SDK로 직접 접근 가능하며, realtime listener와 Security Rules를 제공한다.[T23]

### Firebase Hosting

- Flutter Web 정적 배포
- CDN 기반 서빙
- SPA rewrite 구성 가능

Firebase Hosting은 production-grade web hosting을 제공한다.[T12]

### Google Analytics for Firebase

- lesson open
- anatomy section click
- playground interaction
- quiz submit
- completion

Analytics는 event/user property 기반 측정을 제공한다.[T24]

### Firebase Local Emulator Suite

- Auth / Firestore / Functions / Hosting 로컬 테스트
- CI 환경 테스트

Emulator Suite는 로컬 개발, 프로토타이핑, integration testing, QA에 적합하다.[T25]

### Cloud Functions (선택)

- 고급 검색 인덱스 빌드
- AI 요약/추천
- 피드백 moderation

Cloud Functions는 서버리스 백엔드 코드를 운영할 때만 도입한다.[T26]

## 11.4 권장 데이터 모델

```text
users/{uid}
users/{uid}/progress/{lessonId}
users/{uid}/bookmarks/{lessonId}
feedback/{feedbackId}
```

예시 progress 문서:

```json
{
  "lessonId": "elevated_button",
  "completed": true,
  "completedSections": ["overview", "style_resolution"],
  "quizScore": 3,
  "updatedAt": "serverTimestamp"
}
```

로컬 저장소도 가능한 한 같은 필드 구조를 유지해, Phase 2 동기화 시 마이그레이션 비용을 낮춘다.

---

## 12. 테스트 전략

Flutter 공식 문서는 unit / widget / integration test의 trade-off를 명확히 설명하며, 일반적으로 unit과 widget test를 충분히 두고 핵심 시나리오에 integration test를 배치할 것을 권장한다.[T27]

## 12.1 Unit Test

대상:

- content parser
- repository mapping
- lesson manifest validation
- quiz scoring logic
- progress merge logic
- search ranking logic

## 12.2 Widget Test

대상:

- catalog page 렌더링
- lesson section navigation
- playground control → preview 반영
- quiz interaction
- empty/error/loading state
- anatomy map 및 preview의 핵심 상태 snapshot/golden 검증

## 12.3 Provider Test

대상:

- `PlaygroundController`
- `ProgressController`
- `SearchController`

Riverpod의 `ProviderContainer.test()`와 override 기능을 활용해 외부 의존성을 교체한다.[T5][T6][T8]

## 12.4 Integration Test

대상:

- deep link 진입 (`/widgets/elevated_button`)
- lesson 완료 저장
- 로그인 후 진도 동기화(Phase 2)
- Firebase emulator 연동 시나리오

## 12.5 접근성 테스트

- 키보드만으로 핵심 흐름 조작 가능 여부
- semantics label/role 노출 여부
- contrast / focus visible 확인
- screen reader smoke test

Flutter 접근성 문서는 semantic role 부여와 접근성 테스트의 중요성을 강조한다.[T28][T29]

---

## 13. 배포 및 운영

## 13.1 웹 빌드 전략

Flutter 웹은 build mode와 renderer 선택을 가진다. 공식 문서 기준 Flutter Web에는 default/WebAssembly build mode와 `canvaskit`, `skwasm` renderer가 있으며, 제품은 release QA 과정에서 두 renderer를 확인해야 한다.[T30]

권장 방침:

- 운영 기본: stable release build
- QA 체크: 주요 화면의 renderer 호환성 점검
- lesson preview에서 렌더러 의존성이 큰 시각 효과는 최소화

## 13.2 URL / Hosting

- Path URL strategy 사용
- 웹서버는 모든 앱 경로를 `index.html`로 rewrite
- Firebase Hosting 또는 동급 static hosting 사용

## 13.3 관측성

기본 이벤트:

- `lesson_open`
- `lesson_complete`
- `anatomy_node_open`
- `playground_control_change`
- `quiz_submit`
- `bookmark_toggle`

각 이벤트는 최소 `lessonId`, `sectionId`(있다면), `widgetId`, `contentVersion` 속성을 함께 보내도록 표준화한다.

---

## 14. 구현 단계 제안

### Step A. Foundation

- app shell
- Riverpod bootstrap
- go_router 설정
- content schema / parser
- local progress repository
- 에러/로딩 상태 UI 규칙 정의

### Step B. ElevatedButton MVP

- catalog
- lesson page
- anatomy map
- style resolution tab
- playground
- quiz

### Step C. Quality

- widget/provider tests
- integration test 1~2개
- accessibility smoke checks
- analytics event 설계

### Step D. Phase 2 Backend

- Firebase Auth
- Firestore progress sync
- Hosting pipeline
- Emulator 기반 로컬 테스트

---

## 15. 기술적 트레이드오프

### 15.1 임의 코드 실행 미도입

장점:

- 보안 단순화
- MVP 범위 축소
- 학습 흐름 고정

단점:

- 자유 실험 폭 감소

판단:

- MVP에서는 **파라미터 기반 playground**가 더 적절하다.

### 15.2 운영 앱에서 DevTools/Previewer 직접 미사용

장점:

- 안정성 확보
- 운영 의존성 축소
- UI/UX 통제 가능

단점:

- 구조도 일부는 curated data 필요

판단:

- 운영 앱은 자체 렌더링, 저작자는 Inspector/Previewer 참고.

### 15.3 MVP 무백엔드 전략

장점:

- 개발 속도 빠름
- 비용 낮음
- lesson 경험 검증에 집중 가능

단점:

- 기기 간 동기화 불가

판단:

- 학습 제품의 본질은 콘텐츠 경험이므로 초기에는 백엔드가 필수 아님.

---

## 참고 자료

[T1]: https://docs.flutter.dev/app-architecture/guide "Guide to app architecture"
[T2]: https://docs.flutter.dev/app-architecture/recommendations "Architecture recommendations"
[T3]: https://docs.flutter.dev/app-architecture/case-study "Architecture case study"
[T4]: https://riverpod.dev/docs/from_provider/provider_vs_riverpod "Provider vs Riverpod"
[T5]: https://riverpod.dev/docs/concepts2/containers "ProviderContainers/ProviderScopes"
[T6]: https://riverpod.dev/docs/concepts2/overrides "Provider overrides"
[T7]: https://riverpod.dev/docs/concepts/about_code_generation "About code generation"
[T8]: https://riverpod.dev/docs/migration/from_state_notifier "From StateNotifier"
[T9]: https://docs.flutter.dev/ui/navigation "Navigation and routing"
[T10]: https://pub.dev/packages/go_router "go_router package"
[T11]: https://docs.flutter.dev/ui/navigation/url-strategies "Configuring the URL strategy on the web"
[T12]: https://firebase.google.com/docs/hosting "Firebase Hosting"
[T13]: https://docs.flutter.dev/tools/devtools/inspector "Flutter Inspector"
[T14]: https://docs.flutter.dev/tools/widget-previewer "Flutter Widget Previewer"
[T15]: https://api.flutter.dev/flutter/material/ElevatedButton-class.html "ElevatedButton API"
[T16]: https://api.flutter.dev/flutter/material/ButtonStyleButton-class.html "ButtonStyleButton API"
[T17]: https://api.flutter.dev/flutter/material/ButtonStyle-class.html "ButtonStyle API"
[T18]: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/button_style_button.dart "button_style_button.dart source"
[T19]: https://raw.githubusercontent.com/flutter/flutter/master/packages/flutter/lib/src/material/elevated_button.dart "elevated_button.dart source"
[T20]: https://docs.flutter.dev/resources/architectural-overview "Flutter architectural overview"
[T21]: https://docs.flutter.dev/resources/inside-flutter "Inside Flutter"
[T22]: https://firebase.google.com/docs/auth/flutter/start "Firebase Auth for Flutter"
[T23]: https://firebase.google.com/docs/firestore "Cloud Firestore"
[T24]: https://firebase.google.com/docs/analytics/flutter/get-started "Google Analytics for Flutter"
[T25]: https://firebase.google.com/docs/emulator-suite "Firebase Local Emulator Suite"
[T26]: https://firebase.google.com/docs/functions "Cloud Functions for Firebase"
[T27]: https://docs.flutter.dev/testing/overview "Testing Flutter apps"
[T28]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"
[T29]: https://docs.flutter.dev/ui/accessibility/accessibility-testing "Accessibility testing"
[T30]: https://docs.flutter.dev/platform-integration/web/renderers "Web renderers"

---

# TDD v1.2 추가 기획본 (Append-only)

- 문서 버전: v1.2
- 상태: Draft (Append-only Expansion)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 원문은 수정하지 않고 그대로 유지하며, 아래 내용만 추가한다.**

---

## 16. 아키텍처 결정(ADR) 요약 및 의존성 규칙

현재 TDD는 방향은 정확하지만, 실제 구현 단계에서 흔들리기 쉬운 결정들을 **변경하기 어려운 정책**으로 더 명시할 필요가 있다.

### 16.1 ADR-001 라우팅 표준

- 표준 라우팅은 `go_router` 기반으로 유지한다.
- Flutter 공식 권장 구조상 deep link, 모바일 deep link, 웹 주소창 동기화 요구가 있는 앱은 Router 기반 접근이 적합하며, app architecture recommendations 문서는 `go_router`를 90%의 Flutter 앱에 권장하는 방향을 제시한다.[T31][T32]
- 커스텀 `RouterDelegate` 직접 구현은 특수한 경우에만 허용한다.

### 16.2 ADR-002 상태관리 표준

- 표준 상태관리는 `flutter_riverpod` + 코드 생성 조합이다.
- 프로젝트 기본 패턴은 `Notifier` / `AsyncNotifier` 중심이다.
- `StateNotifier` 신규 도입은 금지한다.[T41][T42][T43][T44]

### 16.3 ADR-003 Riverpod 3 라이프사이클 정책

Riverpod 3은 이전 버전 대비 기본 동작이 달라진 부분이 있으므로, 프로젝트 차원에서 명시적으로 다룬다.

- provider 자동 재시도(auto retry)는 의도적으로 사용 여부를 정한다.
- 콘텐츠 로더, manifest 로더처럼 “잘못된 데이터면 즉시 실패를 노출해야 하는” provider는 기본 자동 retry를 비활성화한다.
- 뷰 이탈 시 provider pause 동작이 학습 타이머/analytics 로직에 영향을 주지 않도록 설계한다.[T45]

### 16.4 ADR-004 코드 규칙

- Riverpod 사용 시 `riverpod_lint`를 필수 도입한다.[T44]
- feature package 간 직접 import를 최소화하고, shared/core를 통해서만 공통 의존성을 노출한다.
- UI layer에서 JSON/raw map을 직접 다루지 않는다.

### 16.5 ADR-005 운영 앱과 저작 도구 분리

- 운영 앱은 Inspector/Widget Previewer를 임베드하지 않는다.
- Widget Previewer는 여전히 experimental feature이므로 저작 참고 도구로만 사용한다.[T40]

---

## 17. 도메인 모델 상세 및 콘텐츠 스키마 확장

현재 TDD는 lesson.md / anatomy.json / quiz.json 파일 분할은 훌륭하지만, 타입 모델과 스키마 버전 호환 규칙이 더 명확해야 한다.

### 17.1 핵심 도메인 모델

```text
LessonManifest
LessonDocument
AnatomyGraph
AnatomyNode
AnatomyEdge
PlaygroundSpec
PlaygroundControl
QuizDocument
QuizQuestion
SearchDocument
ProgressDocument
BookmarkDocument
SourceReference
```

### 17.2 LessonManifest 예시

```json
{
  "id": "elevated_button",
  "kind": "widget",
  "title": "ElevatedButton",
  "library": "material",
  "difficulty": "structural",
  "estimatedMinutes": 12,
  "prerequisites": ["widget_tree_basics", "material_theming_intro"],
  "learningOutcomes": [
    "Explain style resolution order",
    "Describe Widget/Element/RenderObject roles"
  ],
  "sections": [
    "overview",
    "public_api",
    "style_resolution",
    "runtime_structure",
    "semantics",
    "quiz"
  ],
  "sourceRefs": ["api:elevated_button", "source:button_style_button", "concept:architectural_overview"],
  "contentVersion": 2,
  "schemaVersion": 1,
  "flutterVersion": "3.41.x",
  "lastReviewedAt": "2026-03-09"
}
```

### 17.3 AnatomyGraph 예시

```json
{
  "lessonId": "elevated_button",
  "schemaVersion": 1,
  "nodes": [
    {
      "id": "elevated_button",
      "kind": "widget",
      "title": "ElevatedButton",
      "summary": "Material elevated button",
      "relatedSectionIds": ["overview", "public_api"],
      "sourceRefIds": ["api:elevated_button"]
    },
    {
      "id": "button_style",
      "kind": "style_model",
      "title": "ButtonStyle",
      "summary": "State-aware visual model",
      "relatedSectionIds": ["style_resolution"],
      "sourceRefIds": ["api:button_style"]
    }
  ],
  "edges": [
    {
      "from": "elevated_button",
      "to": "button_style",
      "relationship": "uses"
    }
  ]
}
```

### 17.4 QuizDocument 예시

```json
{
  "lessonId": "elevated_button",
  "schemaVersion": 1,
  "questions": [
    {
      "id": "style-order-001",
      "type": "priority_order",
      "prompt": "다음 중 style resolution 우선순위를 올바르게 배열하세요.",
      "choices": [
        "widget.style",
        "themeStyleOf",
        "defaultStyleOf"
      ],
      "answer": [
        "widget.style",
        "themeStyleOf",
        "defaultStyleOf"
      ],
      "relatedSectionIds": ["style_resolution"],
      "explanation": "비-null widget style이 가장 높은 우선순위를 가진다."
    }
  ]
}
```

### 17.5 스키마 호환성 규칙

- `schemaVersion`은 **파서 호환성**을 뜻한다.
- `contentVersion`은 **콘텐츠 검수/개정 횟수**를 뜻한다.
- schema major 변경 시 이전 콘텐츠는 migration script 없이는 publish 불가다.
- 신규 필드는 가능한 backward compatible 방식으로 optional 추가한다.

---

## 18. 콘텐츠 빌드 파이프라인 및 검증 자동화 상세

현재 TDD의 7.3 빌드 파이프라인은 좋지만, 자동 검사 대상이 더 구체적일수록 운영 품질이 올라간다.

### 18.1 빌드 단계 상세

1. raw content collect
2. frontmatter parse
3. JSON schema validate
4. sourceRef integrity validate
5. section id uniqueness validate
6. graph/node edge validate
7. quiz validation
8. search document generation
9. manifest generation
10. publish bundle generation

### 18.2 정적 검증 규칙

- lesson id 중복 금지
- section id 중복 금지
- 모든 related lesson id가 실제 manifest에 존재해야 함
- 모든 sourceRef id는 정의되어야 함
- quiz의 relatedSectionIds는 실제 section에 연결되어야 함
- anatomy edge는 존재하는 node만 참조 가능

### 18.3 링크 및 출처 검증

- 공식 문서 링크 404 검사
- GitHub/raw source 링크 유효성 검사
- Flutter stable release 태그 또는 검수 기준 버전 기록 확인
- `lastReviewedAt` 누락 시 publish 실패

Flutter breaking change 문서는 release 시점 이후 오래되면 정보가 달라질 수 있음을 명시하므로, 콘텐츠 파이프라인은 단순 스키마 검증뿐 아니라 버전 재검토 신호를 다뤄야 한다.[T54]

### 18.4 source drift 감지 전략

정교한 AST diff까지는 MVP 범위를 넘을 수 있으므로, 1차적으로 아래 수준의 감지를 도입한다.

- sourceRef URL hash 저장
- 주요 API 문서의 마지막 검수 버전 저장
- stable release bump 시 전체 lesson을 `needs_review` 후보로 일괄 표기

---

## 19. 검색 아키텍처 및 인덱싱 전략 상세

PRD에서 검색이 중요한 기능으로 지정된 만큼, TDD에는 구체적인 검색 문서 구조와 랭킹 규칙이 필요하다.

### 19.1 SearchDocument 구조

```json
{
  "id": "widget:elevated_button",
  "docType": "widget",
  "title": "ElevatedButton",
  "aliases": ["Material elevated button"],
  "body": "ButtonStyle, theme override, WidgetState, semantics",
  "concepts": ["ButtonStyle", "WidgetState", "Semantics"],
  "trackIds": ["button_family"],
  "difficulty": "structural",
  "url": "/widgets/elevated_button"
}
```

### 19.2 랭킹 규칙

- exact title match 가중치 최고
- alias match 다음 우선
- concept match 다음 우선
- body full-text match는 보조
- bookmarked/recently viewed 결과는 개인화 가중치로만 반영

### 19.3 동의어/용어 정규화

다음처럼 교육용 alias 사전을 유지한다.

- `material state` ↔ `widget state`
- `theme override` ↔ `component theme`
- `render tree` ↔ `render object tree`
- `disabled button` ↔ `onPressed null`

### 19.4 검색 인덱스 생성 위치

- 빌드 시 정적 JSON 인덱스 생성
- 앱 시작 시 lazy load
- 결과 수 증가 시 docType별 chunk 분리 고려

---

## 20. 라우트 상태, anchor, UI state 동기화 상세

현재 URL 설계는 좋지만, “route ↔ tab ↔ section ↔ state”가 충돌할 때의 규칙이 필요하다.

### 20.1 route state 우선순위

1. URL path
2. URL query
3. URL fragment/section
4. persisted local state
5. in-memory default state

### 20.2 추천 query/fragment 규칙

```text
/widgets/elevated_button?tab=playground
/widgets/elevated_button/anatomy/style-resolution
/widgets/elevated_button#quiz
/search?q=buttonstyle
```

### 20.3 restore 정책

- 공유 URL이 존재하면 persisted state를 덮어쓴다.
- query의 `tab`이 유효하지 않으면 lesson default tab으로 fallback 한다.
- section anchor가 유효하지 않으면 lesson 루트에 진입하고 non-blocking warning을 표시한다.

### 20.4 구현 메모

Flutter의 Router 계열과 웹 URL strategy는 주소창 동기화 및 path 기반 URL에 적합하다.[T31][T32][T33]

---

## 21. 로컬 저장소 상세 및 마이그레이션 정책

현재 TDD는 LocalStorage 우선이라고만 서술되어 있으므로, 실제 문서 구조와 migration 규칙을 명시한다.

### 21.1 저장 키 네임스페이스

```text
fal.userprefs.v1
fal.progress.v1
fal.bookmarks.v1
fal.recent.v1
fal.searchHistory.v1
```

### 21.2 ProgressDocument 예시

```json
{
  "schemaVersion": 1,
  "lessonId": "elevated_button",
  "visitedSections": ["overview", "style_resolution"],
  "completedSections": ["overview"],
  "quizAttempts": 2,
  "bestQuizScore": 3,
  "bookmarked": true,
  "lastVisitedAt": "2026-03-09T14:30:00Z"
}
```

### 21.3 migration 규칙

- schemaVersion mismatch 시 migration runner 수행
- migration 불가 시 데이터 폐기 대신 백업 후 초기화
- 사용자가 인지해야 할 major reset이면 changelog 또는 toast로 고지

### 21.4 IndexedDB 확장 조건

다음 중 하나에 해당하면 IndexedDB 확장을 검토한다.

- search index 용량 증가
- rich progress/event queue 누적
- offline content cache 요구 확대

---

## 22. 브라우저/Renderer/Build 전략 상세

Flutter web은 현재 default build와 WebAssembly build, 그리고 canvaskit / skwasm renderer 조합을 가진다. default build는 canvaskit을 사용하고, WebAssembly build는 skwasm을 우선 사용하되 미지원 브라우저에서 canvaskit으로 fallback 한다.[T34][T35][T36]

### 22.1 MVP 운영 기본값

- CI release artifact 기본은 **default JS build**
- Wasm build는 별도 실험 artifact 또는 internal QA artifact로 운용
- lesson 핵심 UX는 JS build 기준으로 품질 보장

### 22.2 Wasm 채택 전 점검 항목

- iOS 브라우저 비호환성 영향 검토
- Firefox/Safari 호환성 제약 검토
- 사용하는 plugin/package가 Wasm 제약과 충돌하지 않는지 확인
- JS interop가 `dart:html`에 강하게 묶여 있다면 Wasm 적합성 재검토

Flutter의 Wasm 문서는 iOS 브라우저 비지원과 특정 브라우저 제약, 그리고 `dart:html`/`package:js` 대신 새로운 interop 방식을 고려해야 함을 설명한다.[T35]

### 22.3 브라우저 지원 정책 문서화

공식 supported platforms 문서를 기준으로 지원 브라우저 기준선을 release note와 함께 갱신한다.[T36]

---

## 23. PWA/오프라인/캐시 전략 상세

현재 TDD는 static-first 철학은 좋지만, Flutter web의 최신 서비스 워커 정책 변화를 반영한 캐시 전략이 필요하다.

### 23.1 기본 원칙

- MVP는 **오프라인 전면 지원**을 목표로 하지 않는다.
- 핵심 목표는 “정적 콘텐츠의 빠른 재방문”과 “로컬 진도 보존”이다.
- Flutter가 생성하는 기본 서비스 워커에 제품 전략을 의존하지 않는다.

Flutter Web FAQ는 `flutter build web`이 생성하는 서비스 워커가 deprecated 되었음을 밝히고, 필요하면 직접 서비스 워커를 만들거나 third-party 도구를 검토하라고 안내한다.[T34]

### 23.2 권장 캐시 정책

- `index.html`: 짧은 cache-control
- app bundle(js/wasm/canvaskit): content hash 기반 long cache
- lesson content JSON/MD bundle: versioned asset naming
- search index: versioned asset naming

### 23.3 향후 오프라인 확장 정책

- Phase 1: 브라우저 기본 캐시 + local progress
- Phase 2: custom service worker 또는 Workbox 검토
- Phase 3: selected track offline pack 검토

### 23.4 웹 초기화 포인트

Flutter web initialization 문서는 `flutter_bootstrap.js`를 통해 초기화 과정을 커스터마이즈할 수 있음을 설명한다. 향후 로딩 셸, 초기 설정, 실험 플래그 주입은 이 초기화 단계와 함께 설계한다.[T38]

---

## 24. 관측성, 로깅, 크래시, 성능 모니터링

현재 TDD의 13.3 관측성은 이벤트 이름 목록 위주다. 실제 운영을 위해서는 앱 내부 로깅과 Firebase 계층을 분리할 필요가 있다.

### 24.1 관측성 계층 분리

1. **Local structured logging**
   - debug log
   - content parse log
   - route transition log
2. **App analytics**
   - 사용자 행동 이벤트
3. **Crash reporting**
   - 예외/실패 수집
4. **Performance monitoring**
   - route load, content parse, first interactive

### 24.2 Riverpod 관측성

Riverpod는 ProviderObserver를 통해 lifecycle event를 로깅/analytics/debugging에 사용할 수 있다. app-level observer를 두고 provider churn, repeated failure, unexpected invalidation을 기록한다.[T46]

### 24.3 Firebase 연동 권장 순서

- Phase 1: Analytics only (선택)
- Phase 2: Crashlytics + Performance Monitoring
- Phase 3: Remote Config / A/B Testing

Firebase Performance Monitoring은 Flutter 앱 성능 특성을 파악하는 데 사용할 수 있고, custom code traces를 지원한다.[T49]

### 24.4 성능 예산 예시

- app shell visible: 2.5~3.0초 목표
- lesson first meaningful content: 3초 이내 목표
- tab switch: 150ms 이내 목표
- playground control update: 100ms 이내 목표

---

## 25. Phase 2 백엔드 보안 모델 상세

현재 TDD는 Firebase 제품군 자체는 잘 제안했지만, 실제 운영에서 중요한 **보안 규칙과 환경 분리**가 아직 빠져 있다.

### 25.1 환경 분리

- `fal-dev`
- `fal-staging`
- `fal-prod`

Firebase는 개발 워크플로우 관점에서 프로젝트 환경 분리를 권장한다.[T47]

### 25.2 Firestore 보안 원칙

- 모든 user progress 문서는 본인 uid만 read/write 가능
- public lesson metadata는 서버 또는 정적 호스팅으로 제공
- admin/editor workflow 데이터는 별도 컬렉션 또는 별도 프로젝트 분리 검토

Cloud Firestore는 Authentication + Security Rules를 통한 보안을 권장하며, Emulator에서 규칙 테스트를 수행할 수 있다.[T47][T48]

### 25.3 App Check

Web/Flutter 클라이언트에서 직접 Firebase 백엔드를 붙일 경우, App Check로 비정상 클라이언트 접근을 줄인다. App Check는 사용자 인증과 별도로 앱/디바이스 정합성을 검증하는 계층이다.[T47]

### 25.4 인증과 권한 모델

```text
anonymous/local-only
member
editor
admin
```

MVP는 anonymous/local-only만 지원해도 되지만, Phase 2부터 editor/admin 권한을 고려한 데이터 분리가 필요하다.

---

## 26. CI/CD와 품질 게이트 상세

### 26.1 CI 파이프라인 제안

1. format check
2. analyze
3. unit test
4. provider test
5. widget test
6. content schema validation
7. broken link validation
8. build web (default)
9. optional build web --wasm (nightly/internal)
10. deploy preview

### 26.2 품질 게이트

- analyzer warning 0
- schema validation pass 100%
- 핵심 integration scenario pass
- 접근성 smoke pass
- deep link smoke pass
- build artifact 생성 성공

### 26.3 preview 배포

- PR 단위 preview URL 생성
- content author가 실제 브라우저에서 lesson 흐름 검수 가능
- staging에서 analytics debug mode / emulator 연결 가능

Firebase Hosting은 SPA 및 정적 배포에 적합하며 preview/staging 흐름과도 궁합이 좋다.[T52]

---

## 27. 접근성 구현 세부 및 테스트 매트릭스

### 27.1 구현 원칙

- standard widget 우선
- custom graph는 semantics + 대체 텍스트 뷰 병행
- keyboard traversal order 명시
- focus visible 일관성 유지

웹 접근성 문서는 표준 위젯이 많은 semantic 정보를 자동 제공한다고 설명하며, custom component에는 `Semantics`로 역할을 부여하라고 안내한다.[T53]

### 27.2 테스트 전략 추가

Flutter 접근성 테스트 문서는 Guideline API를 통해 label, target size, contrast 등을 검증할 수 있다고 설명한다. 따라서 widget test와 별도로 a11y guideline test를 운영한다.[T55]

대상:

- lesson header actions
- section navigator
- anatomy map alternative tree
- playground controls
- quiz answers

### 27.3 수동 접근성 smoke

- 웹 스크린리더로 섹션 이동 가능 여부
- Tab 키 순회 순서 확인
- 그래프 대신 대체 뷰로 동일 정보 접근 가능 여부

---

## 28. Source Lens와 저작권/출처 처리 상세

Flutter 문서와 API 사이트는 문서 본문에 대해 CC BY 4.0, 코드 샘플에 대해 3-Clause BSD License를 명시한다. 따라서 운영 정책은 아래와 같이 둔다.[T51]

### 28.1 원칙

- 원문 대량 미러링 금지
- 발췌는 최소화
- lesson이 제공하는 가치는 “구조 해설과 실험 경험”으로 정의
- 모든 source excerpt에는 원문 링크와 검수일 표기

### 28.2 SourceReference 타입

```json
{
  "id": "api:elevated_button",
  "kind": "api",
  "title": "ElevatedButton class",
  "url": "https://api.flutter.dev/flutter/material/ElevatedButton-class.html",
  "licenseNote": "Docs CC BY 4.0 / code samples BSD-3-Clause",
  "lastVerifiedAt": "2026-03-09"
}
```

---

## 29. 용어 정규화(Glossary) 정책

현재 문서 곳곳에서 `MaterialStatesController`, `WidgetState`, `MaterialStateProperty` 계열 용어가 섞여 등장한다. 최신 Flutter API는 `WidgetState` 계열을 전면에 두면서도 material library에 alias를 남겨 두고 있으므로, 교육 제품은 이 전환을 오히려 학습 포인트로 활용할 수 있다.[T56][T57][T58]

### 29.1 문서 표준 표기

- UI/설명 본문 기본 용어: `WidgetState`, `WidgetStateProperty`, `WidgetStatesController`
- 호환 표기: `(구 material alias: MaterialStateProperty / MaterialStatesController)`

### 29.2 검색 alias 처리

- 사용자가 `MaterialStatesController`로 검색해도 `WidgetStatesController` 관련 결과를 찾을 수 있어야 한다.
- Source Lens에는 alias 관계를 짧게 주석으로 남긴다.

---

## 30. 오픈 기술 이슈(ADR Backlog)

아래 의사결정은 나중으로 미뤄도 되지만, backlog로 명시해두면 확장 시 흔들림이 줄어든다.

1. Wasm build를 언제 public default로 올릴 것인가
2. search index를 정적 JSON으로 유지할지, Algolia/Meilisearch류로 확장할지
3. authoring을 완전 파일 기반으로 유지할지, 내부 CMS를 도입할지
4. AI 보조 요약/추천을 콘텐츠 제작 보조 도구로 도입할지
5. lesson 간 관계 그래프를 정적 curated 데이터로 유지할지, 부분 자동 생성할지
6. Phase 2 이후 Progress sync 충돌 해결 정책(last-write-wins vs merge-by-section)

---

## 추가 참고 자료

[T31]: https://docs.flutter.dev/app-architecture/recommendations "Architecture recommendations and resources"
[T32]: https://docs.flutter.dev/ui/navigation "Navigation and routing"
[T33]: https://docs.flutter.dev/ui/navigation/url-strategies "Configuring the URL strategy on the web"
[T34]: https://docs.flutter.dev/platform-integration/web/faq "Web FAQ"
[T35]: https://docs.flutter.dev/platform-integration/web/wasm "Support for WebAssembly (Wasm)"
[T36]: https://docs.flutter.dev/reference/supported-platforms "Supported deployment platforms"
[T37]: https://docs.flutter.dev/platform-integration/web/renderers "Web renderers"
[T38]: https://docs.flutter.dev/platform-integration/web/initialization "Flutter web app initialization"
[T39]: https://docs.flutter.dev/platform-integration/web/web-images "Display images on the web"
[T40]: https://docs.flutter.dev/tools/widget-previewer "Flutter Widget Previewer"
[T41]: https://riverpod.dev/docs/whats_new "What's new in Riverpod 3.0"
[T42]: https://riverpod.dev/docs/how_to/testing "Testing your providers"
[T43]: https://riverpod.dev/docs/concepts2/containers "ProviderContainers/ProviderScopes"
[T44]: https://riverpod.dev/docs/introduction/getting_started "Getting started"
[T45]: https://riverpod.dev/docs/3.0_migration "Migrating from 2.0 to 3.0"
[T46]: https://riverpod.dev/docs/concepts2/observers "ProviderObservers"
[T47]: https://firebase.google.com/docs/app-check "Firebase App Check"
[T48]: https://firebase.google.com/docs/firestore/security/test-rules-emulator "Test your Cloud Firestore Security Rules"
[T49]: https://firebase.google.com/docs/perf-mon/flutter/get-started "Get started with Performance Monitoring for Flutter"
[T50]: https://firebase.google.com/docs/remote-config/rollouts "Remote Config rollouts"
[T51]: https://docs.flutter.dev/ "Flutter documentation"
[T52]: https://firebase.google.com/docs/hosting "Firebase Hosting"
[T53]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"
[T54]: https://docs.flutter.dev/release/breaking-changes "Breaking changes and migration guides"
[T55]: https://docs.flutter.dev/ui/accessibility/accessibility-testing "Accessibility testing"
[T56]: https://api.flutter.dev/flutter/widgets/WidgetStatesController-class.html "WidgetStatesController class"
[T57]: https://api.flutter.dev/flutter/widgets/WidgetStateProperty-class.html "WidgetStateProperty class"
[T58]: https://api.flutter.dev/flutter/material/ "material library"

# TDD v1.3 범위 수정본 (Append-only: Phase 1 Core 5 Widget Track)

- 문서 버전: v1.3
- 상태: Draft (Append-only Scope Revision)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 / v1.2 원문은 수정하지 않고 그대로 유지하며, 아래 내용은 Phase 1 기술 범위와 구현 우선순위를 재정의한다.**
- 우선순위 규칙: **Phase 1의 lesson set, route 예시, content manifest 예시, Step B 구현 순서, 출시 기준과 관련해 기존 내용과 아래 내용이 충돌하면 v1.3 범위 수정본이 우선한다.**

---

## 31. Phase 1 기술 범위 재정의

현재 TDD의 핵심 아키텍처 방향은 그대로 유효하다. 즉, 아래 기술적 결론은 변하지 않는다.

- Flutter Web 우선
- `go_router` 기반 URL 동기화
- Riverpod 중심 상태관리
- 정적 콘텐츠 + 로컬 진도 저장 기반 MVP
- lesson / source / quiz / progress 분리
- 테스트 가능한 layered architecture
- 접근성과 source drift를 포함한 운영 구조

바뀌는 것은 **어떤 lesson portfolio를 Phase 1에 태우는가**다. 기존 문서는 `ElevatedButton`을 파일럿 모듈이자 Step B의 직접 대상처럼 설명하지만, v1.3부터 Phase 1의 정식 구현 범위는 아래 5개 위젯으로 재정의한다.

- `text`
- `container`
- `row`
- `gesture_detector`
- `list_view`

`ElevatedButton` 관련 기술 설계는 삭제하지 않고, **Phase 2 Button Family Track 설계 seed** 또는 **스키마/lesson template 검증용 고급 예시**로 보존한다.

---

## 31.1 기존 TDD에서 재해석해야 하는 영역

아래 항목은 기술적으로 무효가 되는 것이 아니라, **Phase 1 필수 구현 대상에서 제외**되는 것으로 해석한다.

1. **문서 목적(1장)의 `ElevatedButton` 시작점 표현**
2. **콘텐츠 시스템 예시의 `elevated_button` 중심 샘플**
3. **9장 `ElevatedButton` 파일럿 모듈의 기술 설계**
4. **11장 progress 예시의 `lessonId: elevated_button`**
5. **12.4 integration test의 `deep link (/widgets/elevated_button)` 예시**
6. **14장 Step B. ElevatedButton MVP**
7. **Source Lens / glossary의 button-state 중심 설명**

이 항목들은 앞으로 다음처럼 재배치한다.

- **Phase 1**: Core 5 Widget Track 구현
- **Phase 2**: Button Family Track 구현 시 직접 재사용
- **공통 엔진 검증**: 고급 lesson 예시로 내부 참고

---

## 31.2 Phase 1 공식 위젯 세트와 라우트 ID

| 순서 | lessonId | 라우트 | 대표 축 | 비고 |
|---|---|---|---|---|
| 1 | `text` | `/widgets/text` | text / semantics | 트랙 진입 추천 lesson |
| 2 | `container` | `/widgets/container` | constraints / box / paint | 박스 모델 이해의 기준 |
| 3 | `row` | `/widgets/row` | flex layout | overflow / space distribution |
| 4 | `gesture_detector` | `/widgets/gesture_detector` | input / hit testing | interaction foundation |
| 5 | `list_view` | `/widgets/list_view` | scrolling / viewport | Phase 1의 종합 lesson |

### 31.2.1 Track 라우트

```text
/tracks/core_widgets_foundation
```

### 31.2.2 Deep link 예시

```text
/widgets/text/anatomy/overflow
/widgets/container/anatomy/constraints
/widgets/row/anatomy/expanded
/widgets/gesture_detector/anatomy/hit-testing
/widgets/list_view/anatomy/viewport
```

---

## 31.3 콘텐츠 디렉터리와 Track Manifest 확장

기존 `content/widgets/<widgetId>/...` 구조는 유지하되, Track 단위 메타데이터를 위한 별도 디렉터리를 추가한다.

```text
content/
  widgets/
    text/
      lesson.md
      anatomy.json
      quiz.json
    container/
      lesson.md
      anatomy.json
      quiz.json
    row/
      lesson.md
      anatomy.json
      quiz.json
    gesture_detector/
      lesson.md
      anatomy.json
      quiz.json
    list_view/
      lesson.md
      anatomy.json
      quiz.json
  tracks/
    core_widgets_foundation/
      track.json
```

### 31.3.1 `track.json` 예시

```json
{
  "id": "core_widgets_foundation",
  "title": "Core 5 Widgets Foundation Track",
  "schemaVersion": 1,
  "contentVersion": 1,
  "orderedLessonIds": [
    "text",
    "container",
    "row",
    "gesture_detector",
    "list_view"
  ],
  "recommendedEntryLessonId": "text",
  "estimatedMinutes": 55,
  "learningOutcomes": [
    "Explain text, box, flex, gesture, and scrolling fundamentals",
    "Connect Widget, Element, RenderObject, and Semantics across lessons"
  ],
  "lastReviewedAt": "2026-03-09"
}
```

### 31.3.2 LessonManifest 공통 필드 추가

Phase 1 lesson에는 아래 필드를 추가하는 것을 권장한다.

```yaml
trackIds:
  - core_widgets_foundation
orderInTrack: 1
isCoreTrackLesson: true
recommendedNext:
  - container
conceptCoverage:
  - text
  - semantics
```

---

## 31.4 Phase 1 Lesson별 기술 사양 매트릭스

| lessonId | 필수 섹션 | 필수 Anatomy Node | 필수 Playground 축 | 핵심 테스트 포인트 |
|---|---|---|---|---|
| `text` | overview, api, anatomy, source, playground, runtime, semantics, quiz | text, text_style, default_text_style, overflow, semantics | font size, weight, align, max lines, overflow, semantics label | semantics label, overflow rendering, style inheritance |
| `container` | 동일 | container, constraints, padding, alignment, decoration, clip | size, padding, margin, alignment, decoration, clip | constraints behavior, alignment, decoration preview |
| `row` | 동일 | row, flex, expanded, flexible, mainAxis, crossAxis, overflow | child count, widths, expanded, alignment, direction | flex distribution, overflow, axis alignment |
| `gesture_detector` | 동일 | gesture_detector, callbacks, hit_test, behavior, semantics | tap/double tap/long press, behavior, hit area, semantics | event firing, hit testing, semantics visibility |
| `list_view` | 동일 | list_view, scroll_view, viewport, sliver_list, controller, item_extent | item count, builder mode, shrinkWrap, direction, scroll reset | scrolling, lazy build behavior, item extent, controller reset |

---

## 31.5 Preview Registry 및 렌더링 전략 수정

Phase 1부터는 lesson마다 서로 다른 preview 동작과 control schema가 필요하므로, 단일 `widgetId -> builder` registry 구조를 더 명확히 표준화한다.

### 31.5.1 Registry 인터페이스

```dart
typedef LessonPreviewBuilder = Widget Function(
  BuildContext context,
  LessonPreviewEnvironment environment,
);

class LessonPreviewEnvironment {
  final String lessonId;
  final Object playgroundState;
  final BoxConstraints shellConstraints;
  final ThemeMode themeMode;
  final Locale locale;
  const LessonPreviewEnvironment({
    required this.lessonId,
    required this.playgroundState,
    required this.shellConstraints,
    required this.themeMode,
    required this.locale,
  });
}
```

### 31.5.2 Phase 1 Registry 예시

```dart
final lessonPreviewRegistryProvider = Provider<Map<String, LessonPreviewBuilder>>((ref) {
  return {
    'text': buildTextLessonPreview,
    'container': buildContainerLessonPreview,
    'row': buildRowLessonPreview,
    'gesture_detector': buildGestureDetectorLessonPreview,
    'list_view': buildListViewLessonPreview,
  };
});
```

### 31.5.3 공통 규칙

- preview builder는 임의 사용자 코드를 실행하지 않는다.
- lesson-specific typed state만 입력으로 받는다.
- preview shell은 공통이되, 내부 demo surface는 lesson별로 커스터마이즈한다.
- preview는 widget의 “예쁜 데모”가 아니라 “구조를 드러내는 실험 장치”여야 한다.
- 하나의 preview 안에서 너무 많은 상태를 다루지 않는다. 핵심 학습 포인트가 흐려지면 separate control group으로 분리한다.

---

## 31.6 Typed Playground State 설계 재정의

기존 generic `PlaygroundController` 개념은 유지하되, Phase 1에서는 lesson마다 상태 모델이 충분히 다르므로 **widget-specific typed state + shared interface**를 권장한다.

### 31.6.1 공통 추상화

```dart
abstract interface class LessonPlaygroundState {
  String get lessonId;
}

abstract interface class LessonPlaygroundController<T extends LessonPlaygroundState> {
  T buildInitialState();
}
```

### 31.6.2 상태 모델 예시

```dart
class TextPlaygroundState implements LessonPlaygroundState {
  @override
  final String lessonId = 'text';
  final String textPreset;
  final double fontSize;
  final bool bold;
  final int maxLines;
  final String overflowMode;
  final bool softWrap;
  final String? semanticsLabel;
  const TextPlaygroundState(...);
}

class ContainerPlaygroundState implements LessonPlaygroundState {
  @override
  final String lessonId = 'container';
  final double? width;
  final double? height;
  final double padding;
  final double margin;
  final String alignmentPreset;
  final String decorationPreset;
  final bool clipEnabled;
  const ContainerPlaygroundState(...);
}

class RowPlaygroundState implements LessonPlaygroundState {
  @override
  final String lessonId = 'row';
  final int childCount;
  final bool useExpanded;
  final bool useFlexible;
  final String mainAxisAlignment;
  final String crossAxisAlignment;
  final String mainAxisSize;
  final String textDirection;
  const RowPlaygroundState(...);
}

class GestureDetectorPlaygroundState implements LessonPlaygroundState {
  @override
  final String lessonId = 'gesture_detector';
  final bool onTapEnabled;
  final bool onDoubleTapEnabled;
  final bool onLongPressEnabled;
  final String behavior;
  final double hitAreaSize;
  final bool excludeFromSemantics;
  const GestureDetectorPlaygroundState(...);
}

class ListViewPlaygroundState implements LessonPlaygroundState {
  @override
  final String lessonId = 'list_view';
  final int itemCount;
  final bool useBuilder;
  final bool useItemExtent;
  final bool shrinkWrap;
  final String scrollDirection;
  final double initialScrollOffset;
  const ListViewPlaygroundState(...);
}
```

### 31.6.3 왜 통합 giant state를 피하는가

- lesson 간 control 종류가 너무 다르다.
- giant union state는 validation 복잡도를 높인다.
- 위젯별 테스트가 불필요하게 결합된다.
- authoring과 QA가 lesson 단위로 분리되기 어렵다.

따라서 Phase 1은 **공통 추상화 + 개별 typed state** 전략이 적합하다.

---

## 31.7 위젯별 Preview Shell 규칙

### 31.7.1 `Text` Preview

- 제한된 너비를 가진 text surface를 기본 shell로 사용한다.
- `maxLines`, `overflow`, `softWrap` 차이를 드러내기 위해 width preset을 제공한다.
- semantics label on/off에 따라 별도 설명 panel을 노출한다.
- rich text 자유 편집은 Phase 1 범위에서 제외하고 preset 기반 비교만 허용한다.

### 31.7.2 `Container` Preview

- checker 혹은 bounded background 위에 container를 배치해 margin/padding/size를 시각적으로 구분한다.
- alignment 효과를 보여주기 위해 parent shell 크기를 고정한다.
- decoration preset은 color only / rounded box / border / shadow 정도의 curated set으로 제한한다.
- unconstrained vs constrained preset을 비교 모드로 노출할 수 있다.

### 31.7.3 `Row` Preview

- 고정 폭 shell 안에 child block들을 배치해 overflow 상황을 일부러 재현 가능하게 한다.
- `Expanded` / `Flexible` 토글은 child label과 함께 시각적으로 차이를 드러낸다.
- overflow가 발생하면 preview가 깨지는 대신, 교육용 warning banner와 함께 노출한다.

### 31.7.4 `GestureDetector` Preview

- 입력 영역을 시각적으로 드러내는 hit area overlay를 제공한다.
- onTap / onDoubleTap / onLongPress 이벤트는 side event log panel에 기록한다.
- child visibility preset을 통해 “보이는 영역”과 “입력 가능한 영역”의 차이를 설명한다.
- excludeFromSemantics on/off 결과는 Semantics View와 연결해서 보여준다.

### 31.7.5 `ListView` Preview

- 명시적인 viewport height를 가진 scroll shell을 사용한다.
- item count와 mode(children vs builder)에 따라 rendering 차이를 텍스트 설명과 함께 보여준다.
- scroll reset 버튼과 offset 표시를 제공한다.
- `shrinkWrap`은 단순 토글이 아니라 “언제 비용이 생길 수 있는가” 설명 배너와 함께 노출한다.

---

## 31.8 Phase 1 Anatomy Graph 기준선

기존 AnatomyGraph 스키마는 유지하되, Phase 1에서는 lesson별로 아래 최소 기준을 강제한다.

### 31.8.1 공통 규칙

- node 5개 이상
- edge 4개 이상
- 각 node는 `summary`, `relatedSectionIds`, `sourceRefIds`를 가져야 함
- 최소 1개 이상의 edge는 다른 Phase 1 lesson으로 연결되는 conceptual relation 이어야 함
- 최소 1개 node는 `Semantics` 또는 접근성 관련 설명으로 연결되어야 함

### 31.8.2 lesson별 필수 node set

```text
text:
  text
  text_style
  default_text_style
  overflow
  semantics

container:
  container
  constraints
  padding
  alignment
  decoration

row:
  row
  flex
  expanded
  flexible
  overflow

gesture_detector:
  gesture_detector
  callbacks
  hit_test
  behavior
  semantics

list_view:
  list_view
  scroll_view
  viewport
  sliver_list
  scroll_controller
```

### 31.8.3 cross-lesson relation 예시

- `text.overflow` → `row.overflow`
- `text.semantics` → `gesture_detector.semantics`
- `container.constraints` → `row.flex`
- `row.overflow` → `list_view.scrollable_alternative`
- `gesture_detector.hit_test` → `list_view.scroll_gesture`

---

## 31.9 Search Index 및 Alias 전략 보강

Phase 1부터 검색은 단일 widget lookup이 아니라 track navigation 도구가 된다. 따라서 search document에 lesson 간 관계를 더 직접 반영한다.

### 31.9.1 SearchDocument 예시: `text`

```json
{
  "id": "widget:text",
  "docType": "widget",
  "title": "Text",
  "aliases": ["typography", "label", "overflow text"],
  "body": "TextStyle, DefaultTextStyle, maxLines, overflow, semantics label",
  "concepts": ["TextStyle", "DefaultTextStyle", "Semantics"],
  "trackIds": ["core_widgets_foundation"],
  "difficulty": "basic",
  "url": "/widgets/text"
}
```

### 31.9.2 Search alias 가이드

- `Text`
  - aliases: typography, label, maxLines, ellipsis
- `Container`
  - aliases: box, padding, decoration, constraints
- `Row`
  - aliases: flex, horizontal layout, expanded, overflow
- `GestureDetector`
  - aliases: tap, long press, hit test, pointer
- `ListView`
  - aliases: scroll list, lazy list, viewport, itemExtent

### 31.9.3 초기 검색 boosting 규칙

- 신규 사용자에게는 Core 5 track lesson을 우선 노출
- 동일 개념어가 여러 lesson에 걸치면, Phase 1 recommended order 기준으로 더 기초적인 lesson을 우선 노출
- 단, 사용자가 명시적으로 `gesture`, `scroll`, `viewport`처럼 고급 용어를 입력했다면 해당 lesson을 우선 노출한다

---

## 31.10 Progress / Track Progress 데이터 모델 추가

기존 lesson progress만으로는 Phase 1의 핵심 지표를 설명하기 어렵기 때문에, Track progress 문서를 별도로 둔다.

### 31.10.1 TrackProgressDocument 예시

```json
{
  "schemaVersion": 1,
  "trackId": "core_widgets_foundation",
  "orderedLessonIds": [
    "text",
    "container",
    "row",
    "gesture_detector",
    "list_view"
  ],
  "completedLessonIds": ["text", "container"],
  "currentLessonId": "row",
  "completionPercent": 40,
  "lastVisitedAt": "2026-03-09T14:30:00Z"
}
```

### 31.10.2 로컬 저장 키 추가

```text
fal.trackProgress.v1
```

### 31.10.3 계산 규칙

- `completionPercent = completedLessonIds.length / orderedLessonIds.length * 100`
- lesson 완료와 track 완료는 별도 이벤트로 기록
- 사용자가 공유 URL로 중간 lesson에 진입해도 track progress 계산은 유지
- 추천 이어보기는 `currentLessonId` 기준으로 노출

---

## 31.11 테스트 전략 재정의(Phase 1 5개 위젯 기준)

기존 unit / widget / integration / provider test 원칙은 유지하되, 대상 범위를 아래처럼 구체화한다.

### 31.11.1 `Text`

- unit: text playground state validation
- widget: overflow / maxLines / alignment rendering
- widget: semantics label 유무에 따른 접근성 검증
- provider: text control mutation
- golden: width별 overflow 상태 snapshot

### 31.11.2 `Container`

- unit: decoration preset mapping
- widget: padding / margin / alignment 반영
- widget: constrained preset에 따른 크기 반영
- golden: decoration / clip variation snapshot

### 31.11.3 `Row`

- unit: flex distribution rules mapping
- widget: `Expanded` / `Flexible` toggle
- widget: mainAxis / crossAxis alignment 변화
- widget: overflow warning UX 노출
- golden: 대표 정렬 preset snapshot

### 31.11.4 `GestureDetector`

- unit: event log model
- widget: onTap / onDoubleTap / onLongPress firing
- widget: behavior 변경에 따른 입력 반응 차이
- widget: excludeFromSemantics on/off 확인
- integration: keyboard / pointer 기본 흐름 smoke

### 31.11.5 `ListView`

- unit: list playground config validation
- widget: item count / builder mode / itemExtent toggle
- widget: scroll reset 및 initial offset 반영
- widget: shrinkWrap preset 별 레이아웃 동작
- integration: deep link 진입 후 list lesson interaction

### 31.11.6 Track 레벨 테스트

- `/tracks/core_widgets_foundation` 진입
- lesson 1 → 2 → 3 이어보기
- track progress 계산
- related lesson 추천 링크
- search result에서 lesson 진입
- deep link 충돌 시 URL 우선 복원

---

## 31.12 구현 단계 재정의

## 31.12.1 Step A. Foundation (유지)

- app shell
- Riverpod bootstrap
- go_router 설정
- content schema / parser
- local progress repository
- 에러/로딩 상태 UI 규칙 정의

## 31.12.2 Step B. Core 5 Widgets MVP (신규 표준)

### B1. Track Shell

- `/tracks/core_widgets_foundation` 라우트
- track manifest parser
- track progress UI
- previous / next / continue CTA

### B2. Shared Lesson Engine Stabilization

- lesson shell
- section navigator
- source lens card
- anatomy map renderer
- common playground control framework
- related lesson rail

### B3. Wave 1 Lessons

- `Text`
- `Container`
- `Row`

### B4. Wave 2 Lessons

- `GestureDetector`
- `ListView`

### B5. Search / Recommendation / Progress 연결

- search documents for 5 lessons
- related lesson mapping
- track progress persistence
- lesson complete / track complete event hooks

## 31.12.3 Step C. Quality

- lesson/provider tests
- track-level integration test
- accessibility guideline tests
- analytics event 검증
- 주요 브라우저 smoke QA

## 31.12.4 Step D. Phase 2 Button Family

- `ElevatedButton`
- `FilledButton`
- `TextButton`
- `OutlinedButton`
- `ButtonStyleButton`

즉, 기존 “Step B. ElevatedButton MVP”는 이제 “Step D의 직접 입력 설계 자산”으로 이동한다.

---

## 31.13 Phase 1 범위에서 의도적으로 미루는 항목

Phase 1의 5개 기본 위젯 트랙을 명확히 유지하기 위해 아래 항목은 MVP 필수 범위에서 제외한다.

1. Material 2 / Material 3 비교 모드
2. `ButtonStyle`, `ButtonStyleButton`, `ElevatedButtonTheme` 상세 학습
3. `WidgetStatesController` 기반 상태 시뮬레이터
4. 버튼 전용 style resolution 실험기
5. component theme / app theme / default style 3계층 우선순위 교육
6. button-family 공통 glossary 정교화

이 항목들은 모두 **Button Family Track의 핵심 가치**로 이동한다.

---

## 31.14 `ElevatedButton` 설계 자산의 재사용 방식

기존 9장의 `ElevatedButton` 기술 설계는 사라지지 않는다. 오히려 아래 목적에 유용하다.

1. **lesson template의 고급 사례 검증**
2. **Phase 2 트랙 설계의 기반 문서**
3. **Phase 1 완료 후 bridge lesson 설계 초안**
4. **Playground / Source Lens / Runtime View가 어디까지 확장 가능한지 검증하는 reference**

따라서 repo와 문서 구조상 `elevated_button` 관련 콘텐츠 예시는 아래 중 하나로 유지할 수 있다.

- internal example content
- experimental draft lesson
- Phase 2 pre-production material

다만, 사용자에게 노출되는 Phase 1 공식 범위에는 포함하지 않는다.

---

## 31.15 SourceReference 및 lesson source 매핑 권장안

### `text`

- Text API
- Web accessibility / Semantics 관련 공식 문서
- architectural overview

### `container`

- Container API
- architectural overview
- Inside Flutter의 layout / constraints 설명

### `row`

- Row API
- architectural overview
- constraints / layout 관련 문서

### `gesture_detector`

- GestureDetector API
- accessibility / semantics 관련 문서
- 입력 장치 및 interaction 관련 문서

### `list_view`

- ListView API
- architectural overview
- scrolling / viewport 개념 설명에 연결되는 문서

이렇게 하면 Phase 1은 Material 컴포넌트에 묶이지 않고도 충분히 풍부한 Source Lens를 제공할 수 있다.

---

## 31.16 운영 / 분석 이벤트 추가

기존 이벤트 외에 Phase 1 트랙 운영을 위해 아래 이벤트를 추가한다.

- `track_open`
- `track_resume`
- `track_complete`
- `lesson_next_click`
- `lesson_prev_click`
- `related_lesson_open`
- `search_result_open`
- `playground_reset`
- `deep_link_fallback`

각 이벤트는 최소 아래 속성을 포함한다.

- `trackId`
- `lessonId`
- `sectionId`(해당 시)
- `contentVersion`
- `schemaVersion`
- `orderInTrack`

---

## 31.17 접근성 기준의 Lesson별 적용 포인트

### `Text`

- screen reader가 읽는 label과 화면 표시 텍스트의 차이를 설명
- overflow가 발생해도 핵심 의미가 유실되지 않도록 안내

### `Container`

- purely decorative box와 의미 있는 container를 구분해 설명
- decorative preview가 핵심 정보 단독 전달 수단이 되지 않게 함

### `Row`

- 시각적 위치만으로 의미가 결정되지 않도록 텍스트/label 보완
- 좁은 폭에서 overflow 시 fallback 설명 제공

### `GestureDetector`

- click/tap 대상이 명확한 semantic label을 가져야 함
- 보이는 영역과 입력 영역이 다를 때 학습용 설명 제공

### `ListView`

- scrollable region 의미를 보조기기 관점에서도 설명
- item count와 현재 위치를 텍스트로 함께 제공하는 UX 검토

---

## 추가 참고 자료

[T59]: https://api.flutter.dev/flutter/widgets/Text-class.html "Text class"
[T60]: https://api.flutter.dev/flutter/widgets/Container-class.html "Container class"
[T61]: https://api.flutter.dev/flutter/widgets/Row-class.html "Row class"
[T62]: https://api.flutter.dev/flutter/widgets/GestureDetector-class.html "GestureDetector class"
[T63]: https://api.flutter.dev/flutter/widgets/ListView-class.html "ListView class"
[T64]: https://api.flutter.dev/flutter/widgets/Semantics-class.html "Semantics class"
[T65]: https://docs.flutter.dev/resources/architectural-overview "Flutter architectural overview"
[T66]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"
[T67]: https://docs.flutter.dev/ui/accessibility/accessibility-testing "Accessibility testing"



# TDD v1.4 로드맵 확장본 (Append-only: Phase 1~5 Capability Roadmap + Beyond)

- 문서 버전: v1.4
- 상태: Draft (Reviewed, Append-only Technical Expansion)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 / v1.2 / v1.3 원문은 수정하지 않고 그대로 유지한다.**
- 우선순위 규칙: **Phase 2~5 기술 범위, phase-aware content model, capability plugin 구조, routing/progress/search 확장, test strategy, release sequence, 이후 확장 방향과 관련해 기존 문장과 아래 문장이 충돌하면 v1.4 기술 확장본이 우선한다.**
- 해석 원칙: **기존의 Step D(Button Family)와 `ElevatedButton` 설계는 삭제하지 않는다. 다만 그것을 더 큰 multi-phase capability roadmap 안의 일부로 재배치한다.**

---

## 32. 현재 기술문서 구조 분석과 v1.4가 해결해야 할 문제

v1.3까지의 TDD는 Phase 1 구현에는 충분히 강하다. 특히 아래 항목은 이미 매우 좋은 토대다.

- feature/application/data 분리
- Flutter Web + `go_router` + Riverpod 중심 구조
- content manifest / lesson schema / anatomy graph
- widget-specific typed playground state
- track progress / search / analytics event 기반 설계

또한 Flutter의 app architecture guide는 separation of concerns, UI/Data layer 분리, view/view model/repository/service 구조를 권장하고 있으며, navigation 문서는 URL sync와 deep link를 위해 Router 기반 구성을 사용하도록 안내한다.[T85][T86]

하지만 현재 문서는 아직 다음 기술적 공백을 가진다.

1. **Phase 2 이후 capability roadmap이 약하다.**  
   Phase 1은 어떤 engine이 필요한지 비교적 명확하지만, Phase 2~5에서는 “무슨 lesson을 만든다”는 말만 있고 “그 lesson을 위해 preview runtime이 어떤 새 능력을 가져야 하는가”가 충분히 분리되어 있지 않다.

2. **content model이 phase-aware하지 않다.**  
   현재 schema는 lesson 중심으로 강하지만, 이제는 phase / core / satellite / compare / capstone / prerequisite / capability tags가 추가되어야 한다.

3. **Playground가 phase별로 다른 복잡도를 수용할 준비가 더 필요하다.**  
   Phase 1의 controls는 비교적 단순하다. 그러나 이후에는 theme sandbox, focus/input inspector, async scenario runner, sliver viewport visualizer, overlay/nav stack inspector 같은 전혀 다른 종류의 실험 도구가 필요하다.

4. **search / recommendation / progress가 phase ladder를 인식하지 못한다.**  
   이제 lesson은 고립된 단위가 아니라, 난이도 사다리 안의 위치를 가진다. 기술적으로도 phase-aware ranking과 prerequisite graph가 필요하다.

5. **test strategy가 phase별 위험 지점을 직접 매핑하지 못한다.**  
   Future/Stream/Animation, sliver/paint, overlay/focus/nav는 실패 양상이 서로 다르다. 따라서 Phase 2~5는 서로 다른 testing harness를 가진다.

따라서 v1.4는 전체 TDD를 **capability-driven curriculum engine** 으로 확장한다. 핵심 아이디어는 다음과 같다.

- lesson 자체는 content-driven으로 유지한다.
- 하지만 lesson이 필요로 하는 lab 기능은 **capability plugin** 으로 모듈화한다.
- phase는 “lesson 묶음”이 아니라 “새로운 capability pack이 열린 단계”로 해석한다.

---

## 32.1 v1.4 기술 설계 원칙

1. **Core app shell은 안정적으로 유지하고, phase는 capability pack으로 확장한다.**
   - 공통 app/router/theme/progress/search 뼈대는 변하지 않는다.
   - 새 phase가 열릴 때마다 lesson registry가 아니라 capability pack이 추가된다.

2. **content model은 lesson-first를 유지하되 phase metadata를 필수화한다.**
   - lesson은 여전히 기본 단위다.
   - 하지만 phase와 prerequisite가 명시되지 않으면 recommended path를 만들 수 없다.

3. **사용자 임의 Dart 코드 실행은 여전히 범위 밖이다.**
   - 모든 lab은 schema-driven / preset-driven / simulation-driven 이어야 한다.
   - 즉, 고급 phase라도 DartPad형 자유 실행 환경으로 변하지 않는다.

4. **phase별 typed state는 유지하되, 공통 capability interface를 얹는다.**
   - Phase 1에서 이미 채택한 widget-specific typed state 전략은 유지한다.
   - 대신 phase가 올라갈수록 공통 panel과 inspector를 capability plugin으로 재사용한다.

5. **검색, 추천, 진도, 분석은 모두 phase-aware로 승격한다.**
   - 사용자의 현재 phase, 완료한 core lesson, satellite 소비 패턴, capstone 진입 여부를 모두 인지해야 한다.

6. **고급 lab일수록 deterministic test harness가 선행되어야 한다.**
   - Future/Stream/Animation은 fake async가,
   - sliver/viewport는 scripted scroll state가,
   - overlay/nav/focus는 explicit simulator와 inspectable model이 필요하다.

---

## 32.2 통합 Phase/Track 콘텐츠 모델

### 32.2.1 새 엔터티 정의

기존 lesson 중심 구조에 아래 엔터티를 추가한다.

- `PhaseManifest`
- `TrackManifest`
- `LessonDescriptor`
- `CompareLabDescriptor`
- `CapstoneDescriptor`
- `CapabilityDescriptor`

### 32.2.2 권장 디렉터리 구조

```text
content/
  phases/
    phase_1_foundation/
      phase.yaml
    phase_2_composition_material/
      phase.yaml
    phase_3_reactive_async/
      phase.yaml
    phase_4_layout_scroll_paint/
      phase.yaml
    phase_5_framework_internals/
      phase.yaml

  widgets/
    text/
    container/
    row/
    gesture_detector/
    list_view/
    stack/
    scaffold/
    inkwell/
    text_field/
    elevated_button/
    form/
    value_listenable_builder/
    future_builder/
    stream_builder/
    animated_builder/
    layout_builder/
    custom_scroll_view/
    sliver_list/
    sliver_app_bar/
    custom_paint/
    inherited_widget/
    notification_listener/
    focus/
    overlay/
    navigator/

  compare/
    gesture_detector_vs_inkwell/
    text_vs_text_field/
    future_vs_stream_builder/
    listview_vs_customscrollview/
    inherited_vs_prop_drilling/

  capstones/
    phase_2_material_shell/
    phase_3_live_dashboard/
    phase_4_sliver_explorer/
    phase_5_mini_app_shell/
```

### 32.2.3 `PhaseManifest` 예시

```yaml
id: phase_2_composition_material
title: Composition & Material Interaction Track
difficultyTier: 2
coreLessons:
  - stack
  - scaffold
  - inkwell
  - text_field
  - elevated_button
satelliteLessons:
  - text_button
  - filled_button
  - outlined_button
  - button_style_button
compareLabs:
  - gesture_detector_vs_inkwell
  - text_vs_text_field
capstone:
  id: phase_2_material_shell
prerequisites:
  phases:
    - phase_1_foundation
  minimumCoreCompletion: 5
requiredCapabilities:
  - material_shell_host
  - theme_sandbox
  - input_focus_panel
  - material_state_simulator
  - compare_lab_runner
```

### 32.2.4 `LessonDescriptor` 추가 필드

```yaml
id: elevated_button
kind: widget
phaseId: phase_2_composition_material
lessonType: core # core | satellite | compare_ref
difficultyTier: 2
estimatedMinutes: 20
prerequisites:
  lessons:
    - gesture_detector
    - text
capabilityTags:
  - material_state_simulator
  - theme_sandbox
  - semantics_panel
compareWith:
  - filled_button
  - text_button
capstoneRefs:
  - phase_2_material_shell
```

### 32.2.5 설계 이유

- phase landing page와 recommended order를 만들기 위해 `PhaseManifest`가 필요하다.
- core/satellite/capstone 분리는 progress 가중치와 추천 전략에 직접 영향을 준다.
- capability tag는 preview/runtime이 어떤 panel을 붙일지 결정하는 핵심 키가 된다.

---

## 32.3 라우팅과 IA 확장

기존 route는 유지하되, v1.4부터는 phase 관점의 진입점을 공식 구조로 추가한다.

### 32.3.1 권장 URL 구조

```text
/
/phases
/phases/:phaseId
/phases/:phaseId/readiness
/phases/:phaseId/capstone
/tracks/:trackId
/widgets/:widgetId
/widgets/:widgetId/anatomy/:sectionId
/widgets/:widgetId/labs/:labId
/compare/:compareId
/search?q=
/settings
```

예시:

- `/phases/phase_2_composition_material`
- `/widgets/elevated_button`
- `/widgets/custom_scroll_view/labs/viewport-shell`
- `/compare/future_vs_stream_builder`
- `/phases/phase_5_framework_internals/capstone`

### 32.3.2 라우팅 설계 원칙

- phase landing page는 **phase overview + prerequisites + core/satellite/capstone 구조**를 보여준다.
- compare lab은 lesson route의 부속 섹션이 아니라 독립 route도 가져야 한다.
- capstone은 phase completion funnel의 핵심이므로 direct URL을 가져야 한다.
- 기존 `go_router` 기반 nested routing을 유지하되, phase shell route를 추가한다.[T81]

---

## 32.4 Capability-based Preview Runtime

Phase가 올라갈수록 단일 Playground라는 이름으로는 부족하다. 따라서 v1.4에서는 “Playground”를 상위 개념으로 두되, 내부 구현은 **Capability Plugin** 조합으로 재정의한다.

### 32.4.1 핵심 인터페이스 예시

```dart
abstract class LessonCapabilityPlugin<TState extends Object> {
  String get capabilityId;
  bool supports(LessonDescriptor lesson);
  Widget buildPanel(BuildContext context, TState state, void Function(TState next) onChanged);
  Map<String, Object?> serializeAnalytics(TState state);
}

abstract class LessonPreviewHost<TState extends Object> {
  Widget buildPreview(BuildContext context, TState state);
  TState deserializeState(Map<String, Object?> raw);
  Map<String, Object?> serializeState(TState state);
}
```

### 32.4.2 권장 capability taxonomy

```text
basic_preview
constraint_overlay
event_log
semantics_panel
compare_lab_runner

material_shell_host
theme_sandbox
material_state_simulator
input_focus_panel
style_resolution_table

validation_flow
async_scenario_runner
snapshot_timeline
rebuild_heatmap
listenable_ticker

viewport_shell
scroll_metrics_hud
sliver_visualizer
breakpoint_emulator
paint_canvas_host

dependency_graph
notification_tracer
focus_tree_inspector
overlay_stack_inspector
nav_stack_simulator
```

### 32.4.3 운영 원칙

- lesson은 하나 이상의 capability tag를 가진다.
- preview host는 lesson type별로 달라도 된다.
- capability panel은 lesson descriptor를 보고 동적으로 조합된다.
- 같은 capability는 서로 다른 lesson에서 재사용 가능해야 한다.

예를 들어:

- `ElevatedButton`과 `FilledButton`은 `theme_sandbox`와 `material_state_simulator`를 공유한다.
- `FutureBuilder`와 `StreamBuilder`는 `async_scenario_runner`와 `snapshot_timeline`을 공유한다.
- `CustomScrollView`와 `SliverList`는 `viewport_shell`과 `sliver_visualizer`를 공유한다.

---

## 32.5 Phase별 capability pack 정의

| Phase | 핵심 capability pack | 대표 lesson | 새로 열리는 기술적 실험 능력 |
|---|---|---|---|
| 1 | `basic_preview`, `constraint_overlay`, `event_log`, `semantics_panel` | `Text`, `Container`, `Row`, `GestureDetector`, `ListView` | 기본 preview, constraints, gesture log, semantics 설명 |
| 2 | `material_shell_host`, `theme_sandbox`, `input_focus_panel`, `material_state_simulator`, `style_resolution_table` | `Stack`, `Scaffold`, `InkWell`, `TextField`, `ElevatedButton` | shell slot 실험, focus/input 실험, material state 및 style 확인 |
| 3 | `validation_flow`, `async_scenario_runner`, `snapshot_timeline`, `rebuild_heatmap`, `listenable_ticker` | `Form`, `FutureBuilder`, `StreamBuilder`, `AnimatedBuilder` | async state script, validator 흐름, rebuild 분석 |
| 4 | `viewport_shell`, `scroll_metrics_hud`, `sliver_visualizer`, `breakpoint_emulator`, `paint_canvas_host` | `LayoutBuilder`, `CustomScrollView`, `SliverList`, `SliverAppBar`, `CustomPaint` | viewport/sliver/paint 실험 |
| 5 | `dependency_graph`, `notification_tracer`, `focus_tree_inspector`, `overlay_stack_inspector`, `nav_stack_simulator` | `InheritedWidget`, `NotificationListener`, `Focus`, `Overlay`, `Navigator` | tree-wide coordination / route stack / focus / overlay 시뮬레이션 |

이 표가 의미하는 바는 분명하다. 앞으로의 phase는 단지 lesson을 더 넣는 작업이 아니라, **새로운 종류의 실험 도구를 여는 기술 릴리즈**다.

---

## 32.6 Phase 2 기술 설계 상세 — Composition & Material Interaction

### 32.6.1 새 패키지/모듈 권장안

```text
lib/
  labs/
    material/
      material_shell_host.dart
      theme_sandbox_panel.dart
      material_state_simulator_panel.dart
      style_resolution_table.dart
    input/
      input_focus_panel.dart
      text_controller_log_panel.dart
```

### 32.6.2 lesson별 typed state 예시

```dart
sealed class Phase2LessonState {}

class StackLessonState extends Phase2LessonState { /* child positions, alignment, clip */ }
class ScaffoldLessonState extends Phase2LessonState { /* drawer, snackbar, fab, sheet toggles */ }
class InkWellLessonState extends Phase2LessonState { /* splash, radius, shape, enabled */ }
class TextFieldLessonState extends Phase2LessonState { /* text, focus, error, obscure */ }
class ElevatedButtonLessonState extends Phase2LessonState { /* enabled, colors, shape, m2/m3, state */ }
```

### 32.6.3 주요 capability

- `material_shell_host`: `Scaffold`, `SnackBar`, `BottomSheet`, `FloatingActionButton` 실험용 shell
- `theme_sandbox`: component theme / app theme / local style 비교
- `input_focus_panel`: `TextField` focus, text value, enabled/error 상태 관찰
- `material_state_simulator`: pressed/hover/focus/disabled preset
- `style_resolution_table`: widget style → component theme → default style 순서 설명

### 32.6.4 기존 Step D의 재해석

기존 31.12.4의 “Phase 2 Button Family”는 v1.4부터 **Phase 2의 satellite/module B**로 해석한다.

- core phase: `Stack`, `Scaffold`, `InkWell`, `TextField`, `ElevatedButton`
- satellite pack: `FilledButton`, `OutlinedButton`, `TextButton`, `ButtonStyleButton`

즉, Button Family는 사라지지 않고, 더 넓은 Composition & Material phase의 한 묶음으로 승격된다.

---

## 32.7 Phase 3 기술 설계 상세 — Reactive State, Form & Async

### 32.7.1 새 패키지/모듈 권장안

```text
lib/
  labs/
    reactive/
      validation_flow_panel.dart
      async_scenario_runner.dart
      snapshot_timeline_panel.dart
      rebuild_heatmap_overlay.dart
      listenable_ticker_panel.dart
```

### 32.7.2 lesson별 typed state 예시

```dart
class FormLessonState { /* fields, dirty, touched, validator mode */ }
class ValueListenableBuilderLessonState { /* current value, child optimization */ }
class FutureBuilderLessonState { /* scenario id, latency, current snapshot */ }
class StreamBuilderLessonState { /* scripted events, active/done state */ }
class AnimatedBuilderLessonState { /* ticker status, speed, child caching */ }
```

### 32.7.3 기술 요구사항

- `FutureBuilder`/`StreamBuilder`는 deterministic scripted scenario를 가져야 한다.
- `Form`은 validator 호출 순서와 submit 흐름을 기록하는 panel이 있어야 한다.
- `AnimatedBuilder`는 `child` 최적화 효과를 숫자나 heatmap으로 드러내야 한다.
- `ValueListenableBuilder`는 작은 reactive binding의 장점을 비교 실험할 수 있어야 한다.

### 32.7.4 테스트 harness 요구사항

- fake async 기반 unit/widget test
- scripted stream playback test
- validation scenario snapshot test
- rebuild counter assertion

---

## 32.8 Phase 4 기술 설계 상세 — Advanced Layout, Scroll & Paint

### 32.8.1 새 패키지/모듈 권장안

```text
lib/
  labs/
    viewport/
      viewport_shell.dart
      scroll_metrics_hud.dart
      sliver_visualizer.dart
      breakpoint_emulator.dart
    paint/
      paint_canvas_host.dart
      painter_state_panel.dart
      semantics_fallback_panel.dart
```

### 32.8.2 lesson별 typed state 예시

```dart
class LayoutBuilderLessonState { /* width preset, branch thresholds */ }
class CustomScrollViewLessonState { /* sliver order, scroll offset, physics */ }
class SliverListLessonState { /* item count, delegate mode, cache extent */ }
class SliverAppBarLessonState { /* pinned, floating, snap, expandedHeight */ }
class CustomPaintLessonState { /* painter mode, repaint reason, semantics label */ }
```

### 32.8.3 기술 요구사항

- `viewport_shell`은 scripted scroll offset과 phase markers를 지원해야 한다.
- `sliver_visualizer`는 현재 viewport에 어떤 sliver가 걸쳐 있는지 표시해야 한다.
- `breakpoint_emulator`는 `LayoutBuilder` branch 전환 시점을 명시해야 한다.
- `paint_canvas_host`는 layout size와 paint output의 차이를 설명해야 한다.
- `CustomPaint` lesson에는 semantics fallback 또는 대체 텍스트 설명이 필요하다.[T88]

### 32.8.4 품질 주의점

- 브라우저/renderer별 pixel 차이가 생길 수 있으므로 full-screen pixel golden보다 **diagram/inspector 수준의 deterministic visual test**를 우선한다.
- sliver 및 scroll 관련 통합 테스트는 스크립트 기반 offset assertion을 우선 사용한다.

---

## 32.9 Phase 5 기술 설계 상세 — Framework Internals & App Infrastructure

### 32.9.1 새 패키지/모듈 권장안

```text
lib/
  labs/
    internals/
      dependency_graph_panel.dart
      notification_tracer_panel.dart
      focus_tree_inspector.dart
      overlay_stack_inspector.dart
      nav_stack_simulator.dart
```

### 32.9.2 lesson별 typed state 예시

```dart
class InheritedWidgetLessonState { /* provided values, dependent nodes */ }
class NotificationListenerLessonState { /* event scripts, handled flag, bubble path */ }
class FocusLessonState { /* focus order, requested node, key events */ }
class OverlayLessonState { /* entries, z-order, barrier, anchors */ }
class NavigatorLessonState { /* route stack, push/pop/replace scripts */ }
```

### 32.9.3 기술 요구사항

- `dependency_graph_panel`은 어떤 노드가 어떤 inherited value에 의존하는지 시각화해야 한다.
- `notification_tracer_panel`은 notification bubble path와 stop propagation 여부를 기록해야 한다.
- `focus_tree_inspector`는 현재 focus node, traversal order, key event를 보여줘야 한다.
- `overlay_stack_inspector`는 entry insert/remove 순서와 layering을 표현해야 한다.
- `nav_stack_simulator`는 push/pop/replace와 현재 stack 상태를 명시해야 한다.

### 32.9.4 주의점

- `Navigator` lesson은 제품 라우터(`go_router`)를 설명하는 문서가 아니라, **Flutter framework의 underlying navigation stack mental model**을 설명하는 lesson이어야 한다.
- 실제 앱 라우터 구현과 lesson 내부 simulator를 분리해야 혼동이 줄어든다.

---

## 32.10 Progress / Search / Recommendation 스키마 확장

### 32.10.1 Progress 저장 구조 권장안

```json
{
  "schemaVersion": 3,
  "phases": {
    "phase_2_composition_material": {
      "coreCompleted": ["stack", "scaffold"],
      "satelliteCompleted": ["filled_button"],
      "compareCompleted": ["gesture_detector_vs_inkwell"],
      "capstoneCompleted": false,
      "readinessPassed": false,
      "lastOpenedLessonId": "text_field"
    }
  },
  "lessons": {
    "text_field": {
      "sectionsCompleted": ["overview", "api", "playground"],
      "quizBestScore": 80,
      "labsUsed": ["input_focus_panel"]
    }
  }
}
```

### 32.10.2 Search document 확장 필드

- `phaseId`
- `difficultyTier`
- `lessonType`
- `prerequisiteLessonIds`
- `capabilityTags`
- `isCapstone`
- `compareLessonIds`

### 32.10.3 Ranking 규칙

1. 사용자의 현재 phase와 같은 phase의 core lesson을 우선 노출
2. query가 정확히 일치하면 satellite라도 상단 노출 가능
3. 아직 배우지 않은 고급 lesson은 숨기지 않고 `Advanced` 배지 부여
4. compare lab은 관련 core lesson을 1개 이상 완료한 경우 가중치 상승
5. capstone은 phase 완료에 가까울수록 추천 강화

---

## 32.11 테스트 전략 재정의 (Phase 2~5)

Flutter는 접근성 guideline 테스트를 제공하고, 웹 접근성 문서는 semantics tree가 accessible DOM으로 연결되는 점을 설명한다. 따라서 고급 phase로 갈수록 semantics와 interaction을 테스트에서 더 직접 다뤄야 한다.[T87][T88]

### 32.11.1 공통 원칙

- repository/provider/unit test
- lesson widget test
- capability panel test
- route/deep link integration test
- accessibility guideline test
- 주요 브라우저 smoke QA

### 32.11.2 Phase별 핵심 테스트

| Phase | 우선 테스트 포인트 | 대표 검증 방식 |
|---|---|---|
| 2 | theme precedence, input focus, ink reaction state, scaffold shell behavior | widget test + integration test |
| 3 | async snapshot transitions, validation order, rebuild counts, animation ticker | fake async + widget test |
| 4 | viewport offset invariants, sliver composition, breakpoint branch, painter semantics fallback | scripted integration + targeted visual assertions |
| 5 | inherited dependency updates, notification bubbling, focus traversal, overlay insert/remove, navigator stack | widget/integration hybrid test |

### 32.11.3 Golden 전략 보정

- golden은 renderer 차이에 민감한 전체 화면 캡처보다, **자체 diagram / inspector / table UI** 중심으로 제한한다.
- interaction state는 가능하면 semantic/state assertion을 우선하고 pixel-perfect 검증은 최소화한다.

---

## 32.12 릴리즈 순서 재정의

기존 문서의 Step A~D는 v1.4 이후 아래처럼 해석한다.

### Step A. Foundation infrastructure
- 유지

### Step B. Phase 1 Core 5
- 유지

### Step C. Phase 1 quality / search / progress
- 유지

### Step D. Phase 2 satellite seed (기존 Button Family 설계 자산)
- **유지하되, 더 이상 “전체 Phase 2”를 의미하지 않는다.**
- 해석: Material/button-related capability와 content seed

### Step E. Phase 2 Composition & Material Interaction
- phase manifest 및 phase page 도입
- material/input capability pack 구현
- `Stack`, `Scaffold`, `InkWell`, `TextField`, `ElevatedButton`
- satellite: Button Family

### Step F. Phase 3 Reactive State, Form & Async
- reactive capability pack 구현
- async scenario runner
- validation flow
- rebuild/ticker instrumentation

### Step G. Phase 4 Advanced Layout, Scroll & Paint
- viewport/sliver capability pack 구현
- paint canvas host
- breakpoint emulator

### Step H. Phase 5 Framework Internals & App Infrastructure
- dependency/focus/overlay/navigation capability pack 구현
- internals inspector suite
- capstone-quality simulator 고도화

즉, 기존의 Step D는 v1.4 기준으로 더 큰 multi-phase roadmap 속의 **하위 모듈**로 재배치된다.

---

## 32.13 백엔드 / 분석 / 운영 체계의 phase별 확장

### Phase 1
- local progress
- optional analytics

### Phase 2
- 로그인/동기화의 최초 도입 가능 시점
- theme/input/material usage analytics

### Phase 3
- async scenario usage, validation failure pattern, rebuild heatmap analytics
- learning bottleneck 분석

### Phase 4
- heavy lab performance telemetry
- feature flag / rollout control 강화

### Phase 5
- editor review workflow
- source drift monitoring
- phase-level dashboard
- team/cohort analytics 준비

### 운영상 원칙

- 백엔드 채택은 core content delivery를 방해하지 않아야 한다.
- sync/analytics는 phase와 독립적으로 확장 가능해야 한다.
- content version과 app version은 별도 추적해야 한다.

---

## 32.14 Phase 5 이후 기술 확장 방향

Phase 5 이후는 고정 phase 번호보다, 아래 기술 방향을 미리 수용할 수 있는 구조를 준비하는 것이 중요하다.

### 32.14.1 Authoring / CMS

- visual lesson authoring console
- schema-aware editor
- source ref validator
- review/approval workflow

### 32.14.2 Source Drift / Version Diff Engine

- Flutter 버전별 source ref 재검수 도구
- deprecated API 감지
- lesson별 “last verified against Flutter x.y.z” 배지

### 32.14.3 Package Anatomy Pipeline

- package-level manifest
- package API/source/reference ingestion
- widget lesson과 package lesson의 공통 capability 재사용

### 32.14.4 Multilingual / Platform Shell

- i18n-ready content pipeline
- mobile/desktop shell reuse
- offline lesson pack bundling

### 32.14.5 Advanced Internals Sandbox

- render object / custom layout / sliver internals용 high-risk lab
- core curriculum과 분리된 experimental flag 운영

---

## 추가 참고 자료

[T68]: https://api.flutter.dev/flutter/widgets/Stack-class.html "Stack class"
[T69]: https://api.flutter.dev/flutter/material/Scaffold-class.html "Scaffold class"
[T70]: https://api.flutter.dev/flutter/material/InkWell-class.html "InkWell class"
[T71]: https://api.flutter.dev/flutter/material/TextField-class.html "TextField class"
[T72]: https://api.flutter.dev/flutter/material/ElevatedButton-class.html "ElevatedButton class"
[T73]: https://api.flutter.dev/flutter/widgets/Form-class.html "Form class"
[T74]: https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html "ValueListenableBuilder class"
[T75]: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html "FutureBuilder class"
[T76]: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html "StreamBuilder class"
[T77]: https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html "AnimatedBuilder class"
[T78]: https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html "LayoutBuilder class"
[T79]: https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html "CustomScrollView class"
[T80]: https://api.flutter.dev/flutter/widgets/SliverList-class.html "SliverList class"
[T81]: https://api.flutter.dev/flutter/material/SliverAppBar-class.html "SliverAppBar class"
[T82]: https://api.flutter.dev/flutter/widgets/CustomPaint-class.html "CustomPaint class"
[T83]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html "InheritedWidget class"
[T84]: https://api.flutter.dev/flutter/widgets/Navigator-class.html "Navigator class"
[T85]: https://docs.flutter.dev/app-architecture/guide "Guide to app architecture"
[T86]: https://docs.flutter.dev/ui/navigation "Navigation and routing"
[T87]: https://docs.flutter.dev/ui/accessibility/accessibility-testing "Accessibility testing"
[T88]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"

# TDD v1.5 구현 스캐폴드 확장본 (Append-only: Repository Scaffold + Manifest Contract + Delivery Blueprint)

- append 작성일: 2026-03-10
- 원칙: **위의 v1.1 ~ v1.4 원문은 수정하지 않고 그대로 유지하며, 아래 내용은 Phase 1~5 커리큘럼을 실제 구현 가능한 저장소 구조와 콘텐츠 계약으로 구체화하는 기술 확장본이다.**
- 우선순위 규칙: **lib/ 구조, content/ 구조, manifest 스키마, registry 연결, build script, 테스트 트리, 구현 순서와 관련해 기존 문장과 아래 내용이 충돌하면 v1.5 구현 스캐폴드 확장본이 우선한다.**

---

## 33. 왜 v1.5 기술 확장본이 필요한가

v1.4까지의 TDD는 Phase 1~5 로드맵과 capability 방향을 잘 정의했지만, 실제 개발 킥오프 직전 단계에서 아직 비어 있는 부분이 있다.

1. **저장소 루트 구조가 충분히 구체적이지 않다.**
2. **콘텐츠를 어떤 폴더 단위로 저장할지에 대한 canonical tree가 필요하다.**
3. **Phase / Track / Lesson / Lab / Assessment가 어떤 manifest로 연결되는지 명시돼야 한다.**
4. **개발자가 어떤 순서로 파일을 만들기 시작해야 하는지 더 직접적인 scaffold가 필요하다.**

따라서 v1.5는 아키텍처 원칙을 바꾸지 않고, 그것을 **실행 가능한 저장소 계약**으로 내린다.

---

## 34. 권장 저장소 루트 구조

```text
flutter_anatomy_lab/
  .github/
    workflows/
      ci.yml
      web_preview.yml
      release_web.yml
  .vscode/
  analysis_options.yaml
  pubspec.yaml
  README.md
  docs/
    product/
      PRD_current.md
      TDD_current.md
      roadmap.md
      release_checklists/
    content/
      authoring_guide.md
      naming_convention.md
      source_review_policy.md
      glossary_policy.md
  lib/
    app/
    core/
    content/
    features/
    shared/
  content/
    phases/
    tracks/
    lessons/
    labs/
    assessments/
    glossary/
    search/
  scripts/
    validate_content.dart
    build_content_manifest.dart
    build_search_index.dart
    build_phase_registry.dart
    check_source_refs.dart
    export_content_report.dart
  test/
    unit/
    widget/
    golden/
    contract/
    accessibility/
  integration_test/
  tool/
    schemas/
    fixtures/
    generators/
  web/
    index.html
    manifest.json
    icons/
  firebase/
    firestore.rules
    firestore.indexes.json
    storage.rules
```

### 34.1 운영 원칙

- `lib/`는 앱 런타임 코드만 둔다.
- `content/`는 사람이 읽고 수정하는 교육 자산을 둔다.
- `scripts/`는 CI 또는 로컬 빌드 시 사용하는 content pipeline 도구를 둔다.
- `tool/schemas/`는 manifest JSON schema 또는 YAML contract 예시를 둔다.
- `docs/`는 운영 문서와 저작 규칙을 둔다.

---

## 35. `lib/` 상세 스캐폴드

```text
lib/
  main.dart
  app/
    app.dart
    bootstrap.dart
    env.dart
    router/
      app_router.dart
      route_names.dart
      route_guards.dart
      shell_scaffold.dart
    providers/
      app_providers.dart
  core/
    constants/
      app_constants.dart
      breakpoints.dart
      storage_keys.dart
    theme/
      app_theme.dart
      tokens.dart
      typography.dart
      spacing.dart
    errors/
      app_exception.dart
      error_mapper.dart
      failure.dart
    logging/
      app_logger.dart
      analytics_logger.dart
    analytics/
      analytics_service.dart
      analytics_events.dart
    platform/
      browser_support.dart
      url_strategy.dart
    storage/
      key_value_store.dart
      local_storage_store.dart
    utils/
      debounce.dart
      slug.dart
      date_formatters.dart
  content/
    models/
      phase_manifest.dart
      track_manifest.dart
      lesson_manifest.dart
      lab_manifest.dart
      assessment_manifest.dart
      glossary_term.dart
      anatomy_graph.dart
      playground_schema.dart
      source_ref.dart
    parsers/
      frontmatter_parser.dart
      markdown_lesson_parser.dart
      json_graph_parser.dart
      quiz_parser.dart
    repositories/
      content_repository.dart
      content_repository_impl.dart
      search_repository.dart
      glossary_repository.dart
    services/
      content_loader.dart
      manifest_registry.dart
      search_index_loader.dart
  features/
    catalog/
      application/
        catalog_controller.dart
        catalog_filters.dart
      presentation/
        pages/catalog_page.dart
        widgets/catalog_grid.dart
        widgets/phase_section.dart
    phase/
      application/
        phase_controller.dart
        phase_progress_controller.dart
      presentation/
        pages/phase_landing_page.dart
        widgets/phase_header.dart
        widgets/recommended_path.dart
        widgets/phase_completion_card.dart
    lesson/
      application/
        lesson_controller.dart
        lesson_navigation_controller.dart
        lesson_progress_controller.dart
      presentation/
        pages/lesson_page.dart
        widgets/lesson_header.dart
        widgets/section_nav.dart
        widgets/source_lens_panel.dart
        widgets/runtime_view_panel.dart
        widgets/semantics_view_panel.dart
    playground/
      application/
        playground_registry.dart
        playground_session_controller.dart
        preview_capability_registry.dart
      domain/
        preview_capability.dart
        preview_surface.dart
      presentation/
        widgets/playground_shell.dart
        widgets/control_panel.dart
        widgets/preview_canvas.dart
        widgets/state_badges.dart
    labs/
      application/
        lab_controller.dart
      presentation/
        pages/lab_page.dart
        widgets/compare_panel.dart
        widgets/reflection_panel.dart
    assessment/
      application/
        assessment_controller.dart
      presentation/
        pages/assessment_page.dart
        widgets/question_card.dart
        widgets/result_summary.dart
    progress/
      application/
        progress_controller.dart
        bookmark_controller.dart
      data/
        progress_repository.dart
        local_progress_repository.dart
        sync_progress_repository.dart
      domain/
        lesson_progress.dart
        phase_progress.dart
        bookmark.dart
    search/
      application/
        search_controller.dart
      presentation/
        pages/search_page.dart
        widgets/search_result_list.dart
    settings/
      application/
        settings_controller.dart
      presentation/
        pages/settings_page.dart
    auth/
      application/
        auth_controller.dart
      data/
        auth_repository.dart
        firebase_auth_repository.dart
  shared/
    widgets/
      app_shell.dart
      empty_state.dart
      loading_view.dart
      error_view.dart
      pill_badge.dart
      markdown_block.dart
    diagrams/
      anatomy_graph_view.dart
      graph_legend.dart
      dependency_flow_view.dart
    code_viewer/
      code_snippet_card.dart
      source_diff_card.dart
    layout/
      responsive_scaffold.dart
      two_panel_layout.dart
      sticky_side_nav_layout.dart
```

### 35.1 구조 원칙

- `phase/` feature를 별도로 둬서 lesson보다 상위 단위의 UX를 명확히 다룬다.
- `labs/`와 `assessment/`를 lesson과 분리하여 커리큘럼 제품화를 반영한다.
- `playground/`는 단일 위젯 preview가 아니라, capability 조합 엔진으로 유지한다.

---

## 36. `content/` 상세 스캐폴드

```text
content/
  phases/
    phase_1_foundation/
      phase_manifest.yaml
      landing.md
      glossary.yaml
      cross_links.yaml
    phase_2_composition/
      phase_manifest.yaml
      landing.md
      glossary.yaml
      cross_links.yaml
    phase_3_reactive_async/
      phase_manifest.yaml
      landing.md
      glossary.yaml
      cross_links.yaml
    phase_4_advanced_layout_scroll_paint/
      phase_manifest.yaml
      landing.md
      glossary.yaml
      cross_links.yaml
    phase_5_framework_internals_infra/
      phase_manifest.yaml
      landing.md
      glossary.yaml
      cross_links.yaml
  tracks/
    foundation_core/
      track_manifest.yaml
    composition_material/
      track_manifest.yaml
    reactive_async/
      track_manifest.yaml
    advanced_layout_scroll_paint/
      track_manifest.yaml
    framework_internals_infra/
      track_manifest.yaml
  lessons/
    text/
      lesson.md
      lesson_manifest.yaml
      anatomy.json
      playground.schema.json
      quiz.json
      sources.yaml
    container/
      lesson.md
      lesson_manifest.yaml
      anatomy.json
      playground.schema.json
      quiz.json
      sources.yaml
    row/
      ...
    gesture_detector/
      ...
    list_view/
      ...
    stack/
      ...
    scaffold/
      ...
    inkwell/
      ...
    text_field/
      ...
    elevated_button/
      ...
    form/
      ...
    value_listenable_builder/
      ...
    future_builder/
      ...
    stream_builder/
      ...
    animated_builder/
      ...
    layout_builder/
      ...
    custom_scroll_view/
      ...
    sliver_list/
      ...
    sliver_app_bar/
      ...
    custom_paint/
      ...
    inherited_widget/
      ...
    notification_listener/
      ...
    focus/
      ...
    overlay/
      ...
    navigator/
      ...
  labs/
    phase_1_compare_row_column_wrap/
      lab_manifest.yaml
      brief.md
      quiz.json
    phase_1_capstone_feed_card/
      lab_manifest.yaml
      brief.md
      quiz.json
    phase_2_compare_gesture_vs_inkwell/
      ...
    phase_2_capstone_feedback_form/
      ...
    phase_3_compare_future_stream_value/
      ...
    phase_3_capstone_signup_flow/
      ...
    phase_4_compare_listview_vs_customscrollview/
      ...
    phase_4_capstone_dashboard/
      ...
    phase_5_compare_inherited_vs_notification/
      ...
    phase_5_capstone_mini_app_shell/
      ...
  assessments/
    phase_1_foundation_assessment/
      assessment_manifest.yaml
      questions.json
    phase_2_composition_assessment/
      ...
    phase_3_reactive_async_assessment/
      ...
    phase_4_advanced_layout_assessment/
      ...
    phase_5_framework_internals_assessment/
      ...
  glossary/
    global_terms.yaml
  search/
    generated_search_index.json
    generated_related_index.json
```

### 36.1 핵심 원칙

- `phase`와 `track`은 상위 내비게이션/학습 순서 정의를 담당한다.
- `lesson`은 위젯 또는 개념 해부의 기본 단위다.
- `lab`는 lesson보다 더 응용적인 단위이므로 별도 폴더를 갖는다.
- `assessment`는 phase 단위로 묶어서 관리한다.

---

## 37. 필수 Manifest 계약

v1.5부터는 아래 manifest를 표준 계약으로 둔다.

### 37.1 `phase_manifest.yaml`

필수 필드:
- `id`
- `title`
- `difficulty_label`
- `recommended_order`
- `track_id`
- `landing_lesson_ids`
- `core_lesson_ids`
- `satellite_lesson_ids`
- `compare_lab_id`
- `capstone_lab_id`
- `assessment_pack_id`
- `glossary_id`
- `cross_link_pack_id`
- `phase_outcomes`
- `release_status`

예시:

```yaml
id: phase_1_foundation
title: Foundation Track
difficulty_label: beginner
track_id: foundation_core
core_lesson_ids:
  - text
  - container
  - row
  - gesture_detector
  - list_view
satellite_lesson_ids:
  - padding
  - column
  - expanded
  - single_child_scroll_view
compare_lab_id: phase_1_compare_row_column_wrap
capstone_lab_id: phase_1_capstone_feed_card
assessment_pack_id: phase_1_foundation_assessment
release_status: beta
```

### 37.2 `track_manifest.yaml`

필수 필드:
- `id`
- `phase_id`
- `title`
- `summary`
- `entry_points`
- `bridge_targets`
- `capability_packs`
- `default_route`

### 37.3 `lesson_manifest.yaml`

필수 필드:
- `id`
- `phase_id`
- `track_id`
- `title`
- `kind` (`widget` or `concept`)
- `primary_symbol`
- `difficulty`
- `estimated_minutes`
- `prerequisites`
- `learning_outcomes`
- `sections`
- `anatomy_graph_file`
- `playground_schema_file`
- `quiz_file`
- `source_refs_file`
- `capabilities`
- `search_keywords`
- `release_status`

예시:

```yaml
id: elevated_button
phase_id: phase_2_composition
track_id: composition_material
title: ElevatedButton
kind: widget
primary_symbol: ElevatedButton
difficulty: intermediate
estimated_minutes: 25
prerequisites:
  - gesture_detector
  - text
  - container
sections:
  - overview
  - public_api
  - style_resolution
  - state_simulator
  - runtime_structure
  - semantics
capabilities:
  - material_state_simulator
  - theme_sandbox
  - source_lens
  - runtime_tree
release_status: planned
```

### 37.4 `lab_manifest.yaml`

필수 필드:
- `id`
- `phase_id`
- `type` (`compare` or `capstone`)
- `title`
- `related_lesson_ids`
- `required_capabilities`
- `success_criteria`
- `reflection_questions`

### 37.5 `assessment_manifest.yaml`

필수 필드:
- `id`
- `phase_id`
- `question_bank_file`
- `passing_policy`
- `unlocks`
- `analytics_key`

### 37.6 `sources.yaml`

필수 필드:
- `api_docs`
- `architecture_docs`
- `source_links`
- `last_reviewed_at`
- `framework_version_target`

---

## 38. `playground.schema.json` 설계 원칙

모든 lesson은 자유 코드 편집기 대신 schema-driven control panel을 사용한다.

### 38.1 공통 필드

- `previewType`
- `capabilities`
- `controls`
- `presets`
- `stateBadges`
- `compareModes`
- `accessibilityNotes`

### 38.2 예시: `text_field/playground.schema.json`

```json
{
  "previewType": "widget_preview",
  "capabilities": [
    "focus_inspector",
    "input_state_panel",
    "semantics_overlay"
  ],
  "controls": [
    { "id": "enabled", "type": "boolean", "default": true },
    { "id": "hasError", "type": "boolean", "default": false },
    { "id": "obscureText", "type": "boolean", "default": false },
    { "id": "maxLines", "type": "number", "default": 1, "min": 1, "max": 5 }
  ],
  "presets": [
    { "id": "default" },
    { "id": "focused" },
    { "id": "error" },
    { "id": "disabled" }
  ]
}
```

---

## 39. Playground Capability Registry 표준화

v1.4의 capability pack 설계를 실제 파일/클래스 레벨로 내리면 아래 구조를 권장한다.

```text
lib/features/playground/
  domain/
    preview_capability.dart
    capability_context.dart
  capabilities/
    basic_preview/
      basic_preview_capability.dart
    layout_overlay/
      layout_overlay_capability.dart
    state_badges/
      state_badges_capability.dart
    material_state_simulator/
      material_state_simulator_capability.dart
    theme_sandbox/
      theme_sandbox_capability.dart
    input_state_panel/
      input_state_panel_capability.dart
    focus_inspector/
      focus_inspector_capability.dart
    async_timeline/
      async_timeline_capability.dart
    snapshot_viewer/
      snapshot_viewer_capability.dart
    viewport_visualizer/
      viewport_visualizer_capability.dart
    sliver_composer/
      sliver_composer_capability.dart
    paint_layer_viewer/
      paint_layer_viewer_capability.dart
    dependency_tree_viewer/
      dependency_tree_viewer_capability.dart
    bubbling_trace_viewer/
      bubbling_trace_viewer_capability.dart
    overlay_stack_viewer/
      overlay_stack_viewer_capability.dart
    navigation_stack_viewer/
      navigation_stack_viewer_capability.dart
```

### 39.1 Phase별 기본 capability 매핑

- Phase 1: `basic_preview`, `layout_overlay`, `state_badges`
- Phase 2: + `material_state_simulator`, `theme_sandbox`, `input_state_panel`, `focus_inspector`
- Phase 3: + `async_timeline`, `snapshot_viewer`
- Phase 4: + `viewport_visualizer`, `sliver_composer`, `paint_layer_viewer`
- Phase 5: + `dependency_tree_viewer`, `bubbling_trace_viewer`, `overlay_stack_viewer`, `navigation_stack_viewer`

---

## 40. 라우팅 스캐폴드

권장 라우트 구조는 아래와 같다.

```text
/
/phases
/phases/:phaseId
/tracks/:trackId
/widgets/:lessonId
/widgets/:lessonId/:sectionId
/labs/:labId
/assessments/:assessmentId
/search
/settings
```

### 40.1 라우트 파일 분해

```text
lib/app/router/
  app_router.dart
  route_names.dart
  route_builders.dart
  phase_routes.dart
  lesson_routes.dart
  lab_routes.dart
  assessment_routes.dart
```

### 40.2 URL 설계 원칙

- lesson detail은 위젯명 중심 slug를 유지한다.
- phase landing과 lab/assessment는 별도 최상위 route를 갖는다.
- deep link는 section 단위까지 허용한다.

---

## 41. Progress / Bookmark / Unlock 데이터 모델 스캐폴드

```text
lib/features/progress/domain/
  lesson_progress.dart
  phase_progress.dart
  bookmark.dart
  unlock_state.dart
```

예시 필드:

```dart
class LessonProgress {
  final String lessonId;
  final bool started;
  final bool completed;
  final Set<String> completedSectionIds;
  final int checkpointScore;
  final DateTime? lastVisitedAt;
}

class PhaseProgress {
  final String phaseId;
  final Set<String> completedLessonIds;
  final Set<String> completedLabIds;
  final bool assessmentPassed;
  final bool capstoneCompleted;
}
```

### 41.1 Unlock 정책 저장

unlock는 단순 UI 상태가 아니라, phase ladder를 유지하는 핵심 규칙이므로 명시적 모델을 둔다.

---

## 42. Search 인덱스 스캐폴드

`generated_search_index.json`은 단일 텍스트 검색을 넘어 아래 엔티티를 함께 담아야 한다.

- phase
- track
- lesson
- lab
- glossary term
- source ref alias
- related concepts

예시 문서 구조:

```json
{
  "id": "lesson:elevated_button",
  "entityType": "lesson",
  "title": "ElevatedButton",
  "phaseId": "phase_2_composition",
  "keywords": ["button", "material", "style", "pressed", "theme"],
  "relatedIds": ["lesson:inkwell", "lesson:text_field", "lab:phase_2_compare_gesture_vs_inkwell"]
}
```

---

## 43. 테스트 디렉터리와 책임 분리

```text
test/
  unit/
    content/
      manifest_parser_test.dart
      search_index_builder_test.dart
    features/
      progress_controller_test.dart
      lesson_controller_test.dart
  widget/
    phase/
      phase_landing_page_test.dart
    lesson/
      lesson_page_test.dart
      source_lens_panel_test.dart
    labs/
      lab_page_test.dart
  golden/
    lessons/
      text_lesson_golden_test.dart
      elevated_button_lesson_golden_test.dart
    labs/
      dashboard_lab_golden_test.dart
  contract/
    content_contract_test.dart
    phase_manifest_contract_test.dart
    lesson_manifest_contract_test.dart
  accessibility/
    accessibility_guideline_test.dart
integration_test/
  app_smoke_test.dart
  phase_progress_flow_test.dart
  deep_link_test.dart
  search_flow_test.dart
  lab_completion_test.dart
```

### 43.1 우선순위

- `contract/`는 content schema 붕괴를 막는 핵심이다.
- `integration_test/`는 deep link, progress, phase 이동, search를 먼저 본다.
- `accessibility/`는 최소 smoke 수준이라도 phase마다 유지한다.

---

## 44. CI / Build Pipeline 스캐폴드

권장 파이프라인 순서:

1. `dart format --set-exit-if-changed .`
2. `flutter analyze`
3. `dart run scripts/validate_content.dart`
4. `dart run scripts/build_content_manifest.dart`
5. `dart run scripts/build_search_index.dart`
6. `flutter test`
7. `flutter test integration_test` 또는 preview 환경용 smoke test
8. `flutter build web`

### 44.1 필수 스크립트

- `validate_content.dart`
  - 모든 YAML/JSON/Markdown 계약 검증
- `build_content_manifest.dart`
  - phase/track/lesson/lab/assessment registry 생성
- `build_search_index.dart`
  - 통합 검색 인덱스 생성
- `build_phase_registry.dart`
  - phase landing 페이지와 순서 맵 생성
- `check_source_refs.dart`
  - source link 누락 여부 검토

---

## 45. 초기 구현 순서 재정의

v1.5부터는 아래 순서를 권장한다.

### Step A. 앱 쉘과 URL 전략 세팅
- Router
- path URL strategy
- app shell / theme / responsive layout

### Step B. Content pipeline 최소 구현
- phase manifest parser
- lesson manifest parser
- build scripts
- search index 생성

### Step C. Phase landing + catalog UX 구현
- `/phases`
- `/phases/:phaseId`
- recommended path / progress card

### Step D. Lesson shell 구현
- lesson header
- section nav
- source lens
- runtime view
- semantics panel

### Step E. Playground capability engine 구현
- basic preview
- control schema
- registry pattern

### Step F. Phase 1 Core 5 구현
- `Text`
- `Container`
- `Row`
- `GestureDetector`
- `ListView`

### Step G. Phase 1 Compare / Capstone / Assessment 구현
- Row vs Column vs Wrap lab
- Feed card capstone
- phase assessment

### Step H. Phase 2 capability 확장
- material state simulator
- theme sandbox
- input/focus panel

### Step I. Phase 2 이후 순차 확장
- Phase 2 → Phase 3 → Phase 4 → Phase 5

---

## 46. 브라우저 / 배포 지원 정책 스캐폴드

현재 기준으로 배포 정책은 아래처럼 문서화한다.

### 46.1 런타임 지원
- Chrome
- Safari
- Edge
- Firefox

### 46.2 개발 디버깅 기준
- Chrome 우선
- 필요 시 Edge 보조

### 46.3 배포 원칙
- path URL strategy 사용
- SPA rewrite 설정 필수
- web build smoke test 필수
- accessibility smoke test 포함

---

## 47. Phase 5 이후 기술 확장 스캐폴드

v1.5부터는 이후 확장도 실제 디렉터리와 계약을 상상할 수 있어야 한다.

### 47.1 Package Anatomy 대비 구조

```text
content/packages/
  go_router/
  riverpod/
  intl/
```

### 47.2 Instructor / Cohort 대비 구조

```text
lib/features/cohort/
lib/features/instructor/
content/assignments/
```

### 47.3 Enterprise Edition 대비 구조

```text
content/enterprise_packs/
  company_a_onboarding/
  design_system_pack/
```

### 47.4 Experimental Lab 대비 구조

```text
content/experimental/
lib/features/experimental/
```

---

## 48. v1.5의 최종 기술 정의

v1.5 기준 Flutter Anatomy Lab의 기술 정의는 다음과 같다.

> **Flutter Web 기반의 phase-aware curriculum application이며, content-as-data 구조와 capability-driven playground runtime을 중심으로 확장된다.**

이 문장에서 중요한 것은 세 가지다.

1. **phase-aware**: 앱 구조가 phase 단위를 1급 개념으로 다룬다.
2. **content-as-data**: lesson/lab/assessment는 코드에 하드코딩되지 않는다.
3. **capability-driven runtime**: playground는 lesson마다 다른 실험 능력을 조합해 제공한다.

이제부터 구현은 추상적 설계가 아니라, 위 스캐폴드를 기준으로 바로 시작할 수 있다.

---

## 49. 공식문서형 UI 셸 및 디자인 시스템 구현 가이드 (Append-only)

- 문서 버전: v1.6
- 상태: Draft (Append-only UI System Addendum)
- 작성일: 2026-03-10
- 원칙: **위의 v1.1 ~ v1.5 원문은 그대로 유지하며, 아래 내용은 Phase 1의 화면 조합 방식과 shared UI contract를 구체화한다.**
- 우선순위 규칙: **app shell, responsive layout, section navigation, docs-style component, visual token, interaction density와 관련해 기존 문장과 아래 내용이 충돌하면 49장이 우선한다.**

### 49.1 구현 목표

PRD v1.6의 “official docs visual direction”을 코드 레벨 계약으로 번역한다. 즉, 화면은 아래 성격을 가져야 한다.

- 읽기 중심
- 구조 추적 가능
- deep link 친화적
- 과장 없는 시각 톤
- 실험 패널과 문서 본문이 자연스럽게 공존하는 조합

### 49.2 Shared app shell 계약

Phase 1의 공통 레이아웃은 아래 3영역을 1급 개념으로 가져야 한다.

1. **Primary navigation**
2. **Document content column**
3. **Context rail / outline**

권장 구조:

```text
lib/shared/layout/
  docs_app_shell.dart
  docs_top_bar.dart
  docs_side_nav.dart
  docs_content_column.dart
  docs_context_rail.dart
  responsive_docs_scaffold.dart
```

역할:

- `docs_app_shell.dart`: 전체 문서형 3열 레이아웃 조립
- `docs_top_bar.dart`: 전역 탐색, 검색, 설정, phase 진입
- `docs_side_nav.dart`: track/lesson/section 이동
- `docs_content_column.dart`: heading, body, table, callout, embedded lab 배치
- `docs_context_rail.dart`: outline, source refs, related lesson, next step
- `responsive_docs_scaffold.dart`: breakpoint별 3열/2열/1열 전환

### 49.3 Breakpoint 계약

```text
Desktop >= 1280
- left nav: persistent
- content: primary reading column
- context rail: persistent

Tablet 840..1279
- left nav: persistent or collapsible
- content: primary
- context rail: collapsed into inline section or bottom sheet

Mobile < 840
- single column
- section nav: sticky compact summary
- context rail: inline blocks below section intro or at page end
```

레이아웃 전환 시에도 section anchor, deep link, scroll position 해석은 동일해야 한다.

### 49.4 Visual token 계약

권장 토큰 범주:

```text
color.background
color.surface
color.surfaceSubtle
color.border
color.textPrimary
color.textSecondary
color.accent
color.success
color.warning
color.danger

space.4 / 8 / 12 / 16 / 24 / 32 / 48
radius.8 / 12
stroke.1 / 2
motion.fast / normal
```

토큰 원칙:

- surface 차이는 과한 elevation보다 명도 차이와 border로 만든다.
- accent는 active state와 핵심 링크에만 제한적으로 사용한다.
- section 간 구분은 background block보다 spacing rhythm을 우선한다.

### 49.5 Theme 구현 방향

권장 위치:

```text
lib/core/theme/
  app_theme.dart
  color_tokens.dart
  spacing_tokens.dart
  typography_tokens.dart
  docs_component_theme.dart
```

필수 조건:

- light theme를 기본 기준으로 설계한다.
- dark theme는 추후 확장 가능하되, Phase 1 완성 조건으로 두지 않는다.
- body, heading, caption, mono typography를 명시적으로 분리한다.
- table, chip, callout, diagram frame, playground frame에 대한 component theme를 별도 둔다.

### 49.6 Shared 문서형 컴포넌트 계약

권장 구조:

```text
lib/shared/widgets/
  docs_section_header.dart
  metadata_chip_row.dart
  callout_box.dart
  spec_table.dart
  source_ref_card.dart
  inline_definition_list.dart
  section_anchor_link.dart
  reading_progress_marker.dart

lib/shared/diagrams/
  anatomy_diagram_frame.dart
  runtime_diagram_frame.dart

lib/shared/code_viewer/
  source_excerpt_card.dart
```

구현 규칙:

- `callout_box.dart`: info / note / caution / why-it-matters variant 지원
- `spec_table.dart`: dense table과 readable table 두 밀도 모드 지원
- `source_ref_card.dart`: canonical link, source type, last reviewed, short excerpt 표시
- diagram frame은 light canvas와 얇은 border를 기본으로 한다
- code/source card는 heavy chrome 없이 문서와 이어지는 surface처럼 보여야 한다

### 49.7 Lesson shell 계약

Lesson page는 아래 순서를 기본값으로 유지한다.

1. breadcrumb + metadata
2. title + thesis
3. section nav summary
4. overview
5. api
6. anatomy
7. source
8. playground
9. runtime
10. semantics
11. quiz

이 순서는 scroll 문서형 탐색을 기준으로 하며, tab-only UI로 대체하지 않는다.

### 49.8 Section navigation 및 deep link 동기화

필수 동작:

- 현재 scroll 위치에 따라 active section이 left nav와 context rail에 동기화된다.
- URL fragment 또는 section route 진입 시 heading reveal이 즉시 일어난다.
- 모바일에서도 section nav가 사라지지 않고 compact 형태로 유지된다.
- `overview`, `api`, `anatomy`, `source`, `playground`, `runtime`, `semantics`, `quiz`는 모두 canonical anchor를 가진다.

권장 구현 포인트:

- scroll observer 또는 heading registration 레이어 분리
- section id와 nav state의 단일 진실 원천 유지
- route state가 local selected tab state보다 우선

### 49.9 Playground 패널 외형 계약

Playground는 “mini IDE”가 아니라 “embedded lab”이다.

따라서 아래 규칙을 따른다.

- 좌측 controls, 우측 preview 또는 상하 stack 구조
- control label, helper text, reset action을 명확히 둔다
- preview shell은 항상 deterministic constraints를 가진다
- preview 옆에 state badge, semantics hint, runtime note 같은 설명 보조 요소를 둘 수 있다
- 임의 Dart 입력 에디터, multi-pane console, terminal-like surface는 Phase 1에서 두지 않는다

### 49.10 Anatomy / Runtime 시각화 계약

- 그래프는 line-heavy, light-background, restrained accent 스타일을 사용한다.
- 현재 노드 또는 active path만 강조한다.
- 색만으로 의미를 구분하지 않는다.
- 그래프와 동일 정보를 텍스트 outline 또는 tree view로 제공한다.
- runtime view는 inspector-like panel을 사용하되, DevTools clone처럼 복잡해지지 않게 제한한다.

### 49.11 Motion 계약

공식문서형 경험을 유지하기 위해 모션은 아래 원칙을 따른다.

- 짧고 조용한 전환
- 위치 기억을 돕는 정도의 이동만 허용
- decorative motion 금지
- sticky rail, section reveal, accordion expansion 정도에 한정

권장 시간:

- fast: 120ms
- normal: 180ms

### 49.12 테스트 계약

우선 테스트해야 할 범위:

- docs shell breakpoint 전환
- section nav active state 동기화
- deep link 진입 시 해당 section reveal
- callout/diagram/source card semantics
- playground frame의 deterministic layout

golden 정책:

- full-screen marketing-style golden보다 section-level golden 우선
- renderer 차이를 크게 타는 그림자/배경 효과는 테스트 기준에서 배제
- table, callout, source card, docs shell 같은 구조성 높은 surface 위주로 검증

### 49.13 구현 우선순위

Step A:
- theme token 기초
- docs shell
- section header / table / callout / source ref card

Step B:
- lesson shell
- left nav / context rail 동기화
- responsive docs scaffold

Step C:
- playground frame
- anatomy frame
- runtime frame

Step D:
- progress marker
- reading density polish
- docs-specific accessibility sweep

### 49.14 최종 기술 문장

Phase 1의 UI는 아래 한 문장으로 구현 해석한다.

> **Flutter Anatomy Lab의 화면은 app dashboard가 아니라, 구조를 실험할 수 있게 확장된 공식문서형 reader shell이어야 한다.**

이 문장은 이후 `shared/layout`, `core/theme`, `shared/widgets`, `shared/diagrams`, `code_viewer` 설계의 기준으로 사용한다.
