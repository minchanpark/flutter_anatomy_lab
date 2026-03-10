# Flutter Anatomy Lab PRD

- 문서 버전: v1.1
- 상태: Draft (Reviewed)
- 작성일: 2026-03-09
- 프로젝트명(가칭): **Flutter Anatomy Lab**
- 한 줄 정의: **위젯 하나를 해부하면서 Flutter의 설계 구조를 학습하는 인터랙티브 교육 플랫폼**

---

## 1. 제품 개요

Flutter Anatomy Lab은 Flutter 위젯을 “사용법”이 아니라 “구조” 중심으로 학습하게 만드는 웹 기반 교육 플랫폼이다. 첫 번째 파일럿 학습 모듈은 `ElevatedButton`이며, 이 모듈을 통해 학습자는 다음을 한 번에 연결해서 이해할 수 있어야 한다.

1. 공개 API와 생성자
2. 상속 구조 (`StatefulWidget` → `ButtonStyleButton` → `ElevatedButton`)
3. 스타일 결정 경로 (`style` / theme / defaultStyleOf)
4. 상태 변화(hover, focus, press, disabled)
5. Widget–Element–RenderObject 관점의 구조 설명
6. Semantics / 접근성 관점
7. Material 2 / Material 3 기본값 차이

Flutter 공식 문서는 앱을 UI/Data layer로 나누는 아키텍처와 Widget, Element, RenderObject의 역할 분리를 강조하고 있으며, `ElevatedButton` 문서 역시 단순 버튼 사용법을 넘어 `ButtonStyle`, theme, interactive state, semantics를 함께 읽어야 이해가 완성되는 구조를 보여준다.[P1][P2][P3][P4][P5][P6]

이 제품의 학습 목표는 단순히 API를 소비하게 하는 것이 아니라, 사용자가 lesson을 마친 뒤 자신의 말로 “왜 이렇게 동작하는지”를 설명할 수 있게 만드는 것이다. 따라서 각 lesson은 읽기용 문서가 아니라, **설명 가능한 이해(explainable understanding)** 를 만들기 위한 탐색·실험·검증 루프를 가져야 한다.

---

## 2. 문제 정의

### 2.1 현재 학습의 문제

Flutter를 공부하는 개발자는 보통 다음 네 군데를 오가며 정보를 조합해야 한다.

- 개념 문서(architecture, inside Flutter)
- API 문서(`ElevatedButton`, `ButtonStyle`, `ButtonStyleButton` 등)
- GitHub 소스 코드
- DevTools/Inspector에서 확인하는 런타임 트리

문제는 이 네 가지가 학습 관점에서 한 화면에 통합되어 있지 않다는 점이다. 예를 들어 `ElevatedButton` 하나만 보더라도, API 문서는 상속과 theme override를 설명하고, 소스 코드는 `defaultStyleOf`와 Material 2/3 기본값을 정의하며, Flutter architecture 문서는 Widget/Element/RenderObject의 역할 분리를 설명한다. 초중급 학습자는 이 조각들을 머릿속에서 직접 이어 붙여야 한다.[P2][P3][P4][P5][P6]

### 2.2 사용자가 느끼는 페인 포인트

- 위젯은 쓸 수 있지만 “왜 그렇게 동작하는지” 설명하기 어렵다.
- `style`, component theme, app theme, default style의 관계가 헷갈린다.
- DevTools의 Widget Tree와 실제 소스 구조가 연결되지 않는다.
- Flutter framework 내부의 추상화 수준(Widget vs RenderObject vs Semantics)을 체계적으로 배우기 어렵다.

---

## 3. 비전

> **“위젯 하나를 파면 프레임워크 전체 구조가 보인다.”**

이 제품은 Flutter 위젯을 단위로 삼아, **공식 문서 + 소스 + 시뮬레이션 + 구조 설명**을 하나의 학습 경험으로 묶는다. 사용자는 위젯을 “암기”하는 것이 아니라, Flutter가 어떤 철학으로 UI를 구성하고 상태/테마/레이아웃/접근성을 분리하는지를 체감하게 된다.[P1][P4][P5]

---

## 4. 타깃 사용자

### 4.1 1차 타깃

- Flutter 입문 후 1~6개월 사이의 주니어 개발자
- UI는 만들 수 있지만 framework 구조 설명이 어려운 개발자
- 포트폴리오/스터디용으로 Flutter 내부 구조까지 이해하고 싶은 학습자

### 4.2 2차 타깃

- 사내 온보딩 자료가 필요한 팀 리드/교육 담당자
- Flutter 스터디 운영자
- 컴포넌트 설계 기준을 정리하고 싶은 시니어 개발자

MVP 단계에서는 학습자 경험의 밀도를 우선하며, 일반 비개발자 대상 컴퓨팅 교육 플랫폼으로의 확장은 범위 밖으로 둔다.

---

## 5. 핵심 가치 제안

### 5.1 사용자 가치

- **개념 연결성**: 문서, 소스, 런타임 구조를 하나의 흐름으로 학습
- **실험 가능성**: 파라미터를 바꾸며 즉시 동작을 확인
- **구조 이해**: 위젯 사용법이 아니라 설계 의도를 학습
- **반복 학습**: 퀴즈/북마크/진도 저장으로 학습 루프 강화

### 5.2 제품 차별점

일반 튜토리얼은 “이 위젯을 이렇게 써라”에 머무는 반면, Flutter Anatomy Lab은 아래 4개 층을 같은 lesson 안에서 연결한다.

1. **Public API 층**
2. **Framework Source 층**
3. **Runtime Tree / Layout 층**
4. **Semantics / Accessibility 층**

---

## 6. 목표와 비목표

## 6.1 목표

1. `ElevatedButton`을 통해 Flutter 구조 학습의 대표 모듈을 만든다.
2. “문서-소스-런타임-퀴즈”가 연결된 학습 플로우를 완성한다.
3. Flutter Web 기반으로 공유 가능한 deep link 학습 페이지를 제공한다.
4. MVP에서 별도 백엔드 없이도 학습이 가능하도록 한다.
5. 이후 `TextButton`, `FilledButton`, `InkWell`, `Semantics`, `ListView`, `CustomPainter` 등으로 확장 가능한 콘텐츠 구조를 만든다.

## 6.2 비목표

1. 온라인 IDE처럼 사용자가 임의 Dart 코드를 실행하는 범용 실행 환경 제공
2. Flutter framework 전체를 한 번에 커버하는 대규모 MOOC 제작
3. 커뮤니티 게시판/실시간 협업을 MVP에 포함
4. 모바일 앱 동시 출시

---

## 7. 대표 사용자 시나리오

### 시나리오 A. 버튼이 왜 비활성화되는지 이해하고 싶다

- 사용자는 `ElevatedButton` lesson에 진입한다.
- `onPressed == null`일 때 disabled 상태가 된다는 설명과 상태 시뮬레이터를 본다.
- disabled state에서 style과 색상, elevation이 어떻게 변하는지 확인한다.[P2][P3][P6]

### 시나리오 B. style/theme/default의 우선순위를 이해하고 싶다

- 사용자는 style 탭에서 `widget.style`, `ElevatedButtonTheme`, `defaultStyleOf`의 관계를 본다.
- Playground에서 같은 속성을 각 계층에 넣어보고 어떤 값이 최종 적용되는지 확인한다.
- 소스 패널에서 비-null `style` 속성이 `themeStyleOf`와 `defaultStyleOf`를 override한다는 설명을 확인한다.[P6]

### 시나리오 C. 이 위젯이 Flutter 내부 어디까지 이어지는지 알고 싶다

- 사용자는 구조 탭에서 상속, 관련 파일, Widget Tree, Render 설명, Semantics 설명을 순서대로 본다.
- Inspector 스타일의 “구현 위젯 보기” 모드로 확장된 구조를 확인한다.[P4][P5][P7]

### 시나리오 D. 학습 결과를 누적하고 싶다

- 사용자는 lesson 중간의 체크포인트 퀴즈를 푼다.
- 완료 상태와 북마크가 저장된다.
- 나중에 같은 위젯 또는 연관 위젯(`ButtonStyleButton`, `FilledButton`)으로 이어서 학습한다.

---

## 8. MVP 기능 요구사항

### FR-01. 위젯 카탈로그

- 사용자는 위젯 목록을 category/filter로 탐색할 수 있어야 한다.
- MVP는 최소 다음 카테고리를 포함한다.
  - Button family
  - Layout basics
  - Accessibility
  - Rendering basics
- `ElevatedButton`은 featured lesson으로 노출한다.
- MVP에서는 카탈로그의 양보다 카테고리 규칙과 lesson 연결 구조의 일관성을 우선한다.

### FR-02. Lesson 상세 페이지

Lesson 페이지는 최소 아래 섹션을 제공해야 한다.

1. **Overview**: 무엇인지, 언제 쓰는지
2. **API Snapshot**: 생성자, 주요 속성, 상속 구조
3. **Anatomy Map**: 이 위젯을 구성하는 개념 노드
4. **Source Lens**: 관련 공식 문서/소스 링크와 요약
5. **Playground**: 속성 변경에 따른 결과 시뮬레이션
6. **Runtime View**: 구조/트리/레이아웃 설명
7. **Semantics View**: 접근성 관점 설명
8. **Quiz / Checkpoint**: 학습 확인

### FR-03. Anatomy Map

- 사용자는 위젯의 구조를 노드 그래프 혹은 계층형 트리로 볼 수 있어야 한다.
- `ElevatedButton`의 기본 노드는 최소 다음을 포함한다.
  - `ElevatedButton`
  - `ButtonStyleButton`
  - `ButtonStyle`
  - `ElevatedButtonTheme`
  - `ThemeData.elevatedButtonTheme`
  - `MaterialStatesController`
  - `WidgetState`
  - `Semantics`
  - `Layout / Constraints`

### FR-04. Playground

- 사용자는 `onPressed`, `style`, `icon`, padding, shape, background/foreground color, Material 2/3 모드 등을 조절할 수 있어야 한다.
- hover/focus/pressed/disabled 상태를 강제로 시뮬레이션할 수 있어야 한다.
- 결과는 즉시 Preview에 반영되어야 한다.
- MVP의 Playground는 자유 코드 편집기가 아니라, lesson에서 허용한 control schema 안에서만 조작 가능해야 한다.

### FR-05. Source Lens

- 사용자는 해당 위젯과 직접 관련된 공식 API 문서, architecture 문서, source link를 볼 수 있어야 한다.
- 긴 원문 전체 복사보다 **짧은 발췌 + 설명 + 원문 링크** 중심으로 제공한다.
- lesson 콘텐츠는 Flutter 업데이트 시 source drift를 감지할 수 있도록 버전 메타데이터를 포함한다.
- 버전 메타데이터에는 최소 `flutterVersion` 또는 참조 release, `lastReviewedAt`, `sourceRefs`가 포함되어야 한다.

### FR-06. Quiz / Checkpoint

- 각 lesson은 최소 3개 이상의 체크포인트 문제를 가져야 한다.
- 문제 유형: OX, 객관식, 순서 맞추기, 우선순위 맞추기
- 사용자는 정답 확인 후 관련 섹션으로 바로 이동할 수 있어야 한다.

### FR-07. 진도 및 북마크

- 비로그인 상태에서도 브라우저 로컬에 진도 저장이 가능해야 한다.
- lesson 단위 완료, 섹션 단위 완료, 즐겨찾기 저장을 지원한다.
- MVP 로컬 저장의 범위는 동일 브라우저 프로필 기준이며, 기기 간 동기화는 Phase 2 이후 과제로 둔다.

### FR-08. 검색

- 위젯명, 개념명(`RenderObject`, `Semantics`, `ButtonStyle`)으로 검색할 수 있어야 한다.
- 검색 결과는 “위젯”, “개념”, “학습 트랙”으로 나누어 보여준다.

### FR-09. 공유 가능한 URL

- lesson은 URL로 직접 진입 가능해야 한다.
- 섹션 anchor/deep link를 지원해야 한다.
- 웹 주소창과 동기화되는 라우팅 구조를 제공해야 한다.[P8][P9]

---

## 9. 파일럿 모듈: ElevatedButton Lesson 사양

## 9.1 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `ElevatedButton`이 `ButtonStyleButton` 기반의 `StatefulWidget`이라는 점
2. `ButtonStyle`의 속성은 기본적으로 null이며, 실제 기본값은 버튼 구현체와 theme에서 채워진다는 점
3. `ElevatedButton`의 style은 widget style, component theme, default style의 합성으로 결정된다는 점
4. interactive state(hover/focus/pressed/disabled)가 시각 표현에 영향을 준다는 점
5. Widget/Element/RenderObject/Constraints/Semantics를 분리해서 생각해야 하는 이유

이 내용은 Flutter 공식 API 및 architecture 문서가 직접 드러내는 구조와 일치한다.[P2][P3][P4][P5][P6]

## 9.2 Lesson 섹션 설계

### A. Quick Intro

- ElevatedButton의 역할
- 언제 써야 하는가
- 어떤 경우 피하는가

공식 문서는 elevated button을 “flat layout에 차원을 추가할 때” 사용하고, 이미 떠 있는 surface(예: dialog, card) 위에서는 피하라고 안내한다.[P2]

### B. Public API

- 생성자
- `.icon` 생성자
- 주요 프로퍼티 (`onPressed`, `style`, `statesController`, `tooltip`, `child`)
- 상속 구조

### C. Style Resolution

- `ButtonStyle`의 공통 속성 모델
- `style` 파라미터
- `ElevatedButtonTheme`
- `ThemeData.elevatedButtonTheme`
- `defaultStyleOf`
- 최종 적용 우선순위

### D. State Simulator

- enabled / disabled
- hovered / focused / pressed
- icon 유무
- M2 / M3 비교

공식 소스는 Material 3 기본값 예시로 `surfaceContainerLow`, `primary`, `StadiumBorder`, `Size(64, 40)` 등을 정의한다.[P3]

### E. Runtime Structure

- 구현 위젯 보기(학습용 구조도)
- constraints 흐름 설명
- size 결정 설명
- paint/interaction 지점 설명

Flutter 문서는 constraints가 아래로 내려가고 size가 위로 올라오며, RenderObject tree는 Element tree의 부분집합이라고 설명한다.[P4][P5]

### F. Accessibility

- 버튼 role
- tooltip/accessibility 연결
- custom educational diagram의 semantics 처리

Flutter 웹 접근성 문서는 semantic role이 스크린리더와 보조기기에 핵심이라고 설명하며, 표준 위젯은 대체로 semantics를 제공하지만 커스텀 UI는 역할을 명시해야 한다고 안내한다.[P10]

---

## 10. 성공 지표

### 10.1 북극성 지표

- **Lesson Completion Rate**: `ElevatedButton` lesson 진입 대비 완료 비율

### 10.2 보조 지표

- 평균 lesson 체류 시간
- Anatomy Map 클릭률
- Playground 상호작용 수
- Quiz 정답률
- 7일 내 재방문율
- `ElevatedButton` lesson 완료 후 연관 lesson 진입률
- 출시 전에는 각 지표의 목표값과 이벤트 정의서를 함께 확정해야 한다.

### 10.3 제품 가설

- 공식 문서와 소스를 분리해서 읽는 것보다, 한 화면에서 연결된 학습 경험을 제공하면 완료율과 재방문율이 높아질 것이다.
- 단순 텍스트 설명보다 playground + 구조도 + quiz 조합이 이해도를 높일 것이다.

---

## 11. 비기능 요구사항

### 11.1 성능

- 데스크톱 기준 첫 진입 경험이 빠르게 느껴져야 한다.
- lesson 콘텐츠는 지연 로딩이 가능해야 한다.
- Playground 상호작용 시 프레임 드랍이 없어야 한다.
- 초기 운영 목표치는 “첫 학습 콘텐츠가 3초 내에 보이고”, control 변경 후 preview 반영은 사용자가 즉각적이라고 느끼는 수준으로 유지하는 것이다.

### 11.2 접근성

- 키보드 탐색 가능
- 색상만으로 상태를 구분하지 않음
- 학습용 커스텀 컴포넌트에 semantic role/label 제공
- 스크린리더에 핵심 정보가 전달되어야 함

### 11.3 국제화

- 최소 한국어/영어를 염두에 둔 구조
- 추후 locale 확장이 가능한 텍스트 관리 방식 필요

Flutter는 국제화/지역화를 지원하며, 웹 접근성과 semantics도 공식 가이드에서 적극적으로 다루고 있다.[P10][P11]

### 11.4 유지보수성

- lesson은 코드 수정 없이 콘텐츠만 확장 가능해야 한다.
- Flutter 업데이트로 source가 달라질 때 lesson drift를 추적할 수 있어야 한다.
- lesson schema 자체도 버전 관리되어야 하며, 콘텐츠와 스키마의 호환 범위를 문서화해야 한다.

---

## 12. 범위 확장 전략

### 12.1 MVP 이후 확장 후보

1. **Button family track**
   - `TextButton`
   - `FilledButton`
   - `OutlinedButton`
   - `ButtonStyleButton`
2. **Input & Gestures track**
   - `InkWell`
   - `GestureDetector`
   - `Focus`
3. **Layout & Render track**
   - `Container`
   - `Row/Column`
   - `ListView`
   - `CustomPainter`
4. **Accessibility track**
   - `Semantics`
   - Focus order
   - web accessibility patterns

### 12.2 확장 원칙

- 하나의 lesson은 하나의 위젯/개념을 대표 사례로 삼는다.
- 모든 lesson은 “API → 구조 → 실험 → 체크포인트” 형태를 유지한다.
- lesson 간 링크는 개념 그래프 형태로 연결한다.

---

## 13. 리스크와 대응

### 리스크 1. 콘텐츠 제작 비용이 높다

- **대응**: lesson schema를 표준화하고 재사용 가능한 block 기반 authoring 체계를 만든다.

### 리스크 2. Flutter 업데이트로 설명이 빨리 낡는다

- **대응**: lesson 메타데이터에 참조 문서/소스 버전과 검수 날짜를 기록하고, release 주기별 검수 owner를 명확히 둔다.

### 리스크 3. 초보자에게 너무 깊을 수 있다

- **대응**: “기초 / 내부 구조 / 심화” 3단계 난이도 레이어를 둔다.

### 리스크 4. 제품이 온라인 IDE처럼 확장되며 복잡해진다

- **대응**: MVP에서는 파라미터 기반 playground만 허용하고 임의 코드 실행은 제외한다.

---

## 14. 출시 로드맵

### Phase 0. 설계 기반 구축

- 정보구조(IA)
- lesson schema 정의
- `ElevatedButton` 콘텐츠 초안 작성

### Phase 1. MVP

- Widget Catalog
- `ElevatedButton` lesson
- Playground
- Quiz
- 로컬 진도 저장
- 공유 URL

### Phase 2. 확장

- Button family track
- 계정 기반 진도 동기화
- 검색 고도화
- lesson 관계 그래프

### Phase 3. 고급 학습 기능

- 비교 보기(`ElevatedButton` vs `FilledButton`)
- 팀/스터디용 공유 컬렉션
- 코멘트/피드백 시스템

---

## 15. 오픈 이슈

1. lesson 콘텐츠를 정적 파일 중심으로 유지할지, 일정 규모 이후 CMS로 옮길지
2. 구조도 데이터를 수작업으로 관리할지, authoring tool로 반자동 생성할지
3. 퀴즈 중심 학습과 탐색 중심 학습의 비중을 어떻게 나눌지
4. Flutter release cadence에 맞춘 콘텐츠 검수 프로세스와 책임 owner를 어떻게 운영할지

---

## 참고 자료

[P1]: https://docs.flutter.dev/app-architecture/guide "Guide to app architecture"
[P2]: https://api.flutter.dev/flutter/material/ElevatedButton-class.html "ElevatedButton API"
[P3]: https://raw.githubusercontent.com/flutter/flutter/master/packages/flutter/lib/src/material/elevated_button.dart "elevated_button.dart source"
[P4]: https://docs.flutter.dev/resources/architectural-overview "Flutter architectural overview"
[P5]: https://docs.flutter.dev/resources/inside-flutter "Inside Flutter"
[P6]: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/button_style_button.dart "button_style_button.dart source"
[P7]: https://docs.flutter.dev/tools/devtools/inspector "Flutter Inspector"
[P8]: https://docs.flutter.dev/ui/navigation "Navigation and routing"
[P9]: https://pub.dev/packages/go_router "go_router package"
[P10]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"
[P11]: https://docs.flutter.dev/ui/internationalization "Internationalizing Flutter apps"

---

# PRD v1.2 추가 기획본 (Append-only)

- 문서 버전: v1.2
- 상태: Draft (Append-only Expansion)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 원문은 수정하지 않고 그대로 유지하며, 아래 내용만 추가한다.**

---

## 16. 정보구조(IA) 및 화면 계층 상세

현재 PRD는 기능 요구사항 중심으로는 충분히 탄탄하지만, 사용자가 실제로 어떤 정보 구조 안에서 학습 경험을 소비하는지에 대한 **페이지 단위 설계**는 아직 얇다. 따라서 아래 IA를 MVP 기준 기본 구조로 추가한다.

### 16.1 글로벌 화면 구조

```text
/
  홈(Home)
    - 제품 소개
    - Featured lesson
    - 추천 학습 트랙
    - 최근 본 lesson

/widgets
  카탈로그(Catalog)
    - 카테고리 필터
    - 난이도 필터
    - 학습 상태 필터
    - 검색 진입

/widgets/:widgetId
  Lesson Detail
    - Hero / lesson summary
    - section navigation
    - anatomy map
    - source lens
    - playground
    - quiz
    - related lessons

/widgets/:widgetId/anatomy/:sectionId
  Lesson Deep Link View
    - 특정 구조 섹션 바로 진입

/tracks/:trackId
  학습 트랙 상세
    - prerequisite
    - 포함 lesson
    - 추천 순서

/search
  통합 검색
    - 위젯 / 개념 / 트랙 결과

/settings
  언어 / theme / 접근성 / 실험 기능 설정
```

### 16.2 Lesson 상세 페이지 레이아웃

Lesson 상세 페이지는 아래 4개 레일/영역 개념으로 설계한다.

1. **상단 Hero 영역**
   - lesson 제목
   - 난이도
   - 예상 학습 시간
   - prerequisite
   - 관련 트랙
   - 완료 상태 / 북마크 상태
2. **좌측 또는 상단 Section Navigator**
   - Overview
   - API Snapshot
   - Anatomy Map
   - Source Lens
   - Playground
   - Runtime View
   - Semantics View
   - Quiz
3. **중앙 Main Study Canvas**
   - 현재 섹션의 본문과 실험 UI
4. **우측 Context Rail**
   - 핵심 용어 카드
   - 관련 공식 문서 링크
   - 현재 섹션 체크포인트
   - 관련 lesson 추천

### 16.3 화면 상태 설계

MVP에서도 아래 상태를 제품 레벨에서 명확히 구분한다.

- **loading**: 콘텐츠 파싱 또는 초기 로딩 중
- **ready**: 학습 가능 상태
- **empty**: 검색 결과 없음, 관련 lesson 없음
- **error**: 콘텐츠 로딩 실패, manifest 누락, 잘못된 deep link
- **unsupported**: 브라우저/renderer 정책상 일부 기능 비권장 또는 미지원

특히 Flutter 웹은 build mode, renderer, 브라우저 호환성 조건이 결과 UX에 영향을 줄 수 있으므로, lesson 자체 실패와 브라우저 제약을 사용자에게 분리해서 보여주는 정책이 필요하다.[P12][P13][P14][P15][P16][P17]

### 16.4 Deep Link와 학습 복귀 UX

- 사용자가 lesson URL만 공유해도 동일 페이지에 진입할 수 있어야 한다.
- 사용자가 섹션 단위 URL을 공유하면 해당 섹션이 자동으로 열려야 한다.
- 동일 사용자가 다시 진입할 때는 “마지막 학습 섹션으로 이어보기” 진입점을 제공한다.
- 단, 공유 URL과 개인 이어보기 상태가 충돌할 경우 **공유 URL이 우선**한다.

Router 기반 접근은 deep link 처리와 웹 주소창 동기화 측면에서 현재 Flutter 권장 구조에 부합한다.[P12][P13]

---

## 17. 학습 경험(Learning Experience) 모델 추가

현재 PRD는 “무엇을 보여줄 것인가”는 잘 정의하고 있지만, “어떤 학습 루프로 이해를 고정할 것인가”는 더 명문화할 필요가 있다. 이 제품은 일반 문서 뷰어가 아니라 교육 플랫폼이므로, lesson 하나마다 아래 학습 루프를 표준 템플릿으로 갖는다.

### 17.1 Lesson 학습 루프

1. **Orient**
   - 이 위젯/개념이 무엇인지 1분 안에 파악
2. **Inspect**
   - API, 상속, theme, state, semantics를 구조적으로 분해
3. **Experiment**
   - Playground에서 변수를 조정하며 동작 관찰
4. **Explain**
   - Runtime View와 Source Lens로 “왜 그렇게 동작하는지” 확인
5. **Verify**
   - Quiz/Checkpoint로 이해 확인
6. **Bridge**
   - 관련 lesson으로 개념 연결

### 17.2 난이도 레이어

모든 lesson은 아래 난이도 레이어를 메타데이터로 가진다.

- **기초(Basic)**: 무엇인지, 언제 쓰는지, 대표 API
- **구조(Structural)**: 상속, theme, state, runtime 구조
- **심화(Advanced)**: source-level nuance, edge case, trade-off, extension point

### 17.3 Lesson 메타데이터 추가

모든 lesson은 아래 필드를 추가로 가질 수 있어야 한다.

```yaml
estimatedMinutes: 12
prerequisites:
  - widget_tree_basics
  - material_theming_intro
learningOutcomes:
  - ElevatedButton의 style 우선순위를 설명할 수 있다.
  - Widget/Element/RenderObject의 역할 차이를 설명할 수 있다.
layerDepth: structural
recommendedNext:
  - filled_button
  - text_button
  - button_style_button
```

### 17.4 완료 정의(Definition of Completion)

lesson 완료는 단순 페이지 방문이 아니라 아래 기준으로 정의한다.

- 필수 섹션 최소 1회 열람
- Playground 최소 1회 상호작용
- Quiz 제출 완료
- 종료 시 사용자가 “완료로 표시”하거나 자동 완료 규칙 충족

북극성 지표를 Completion Rate로 잡는다면, 무엇을 완료로 볼지 먼저 엄격히 정의해야 지표가 흔들리지 않는다.[P23]

---

## 18. MVP 기능별 수용 기준(Acceptance Criteria) 상세

현재 기능 요구사항은 방향성은 좋지만, 개발/QA/콘텐츠 팀이 공통으로 판단할 수 있는 **완료 기준**이 더 필요하다. 아래 기준은 기존 FR-01 ~ FR-09를 보완하는 추가 정의다.

### 18.1 FR-01 위젯 카탈로그 추가 수용 기준

- 카테고리별 lesson 카드가 최소 제목, 난이도, 짧은 설명, 학습 상태를 노출한다.
- 사용자는 카테고리와 난이도를 조합해 필터링할 수 있다.
- Featured lesson은 홈과 카탈로그 모두에서 찾을 수 있어야 한다.
- lesson 카드 클릭 시 deep link 가능한 상세 페이지로 이동한다.

### 18.2 FR-02 Lesson 상세 페이지 추가 수용 기준

- 모든 섹션은 URL anchor 또는 섹션 단위 state로 직접 진입 가능해야 한다.
- 모바일 우선 출시가 범위 밖이라도, 브라우저 폭 축소 시 학습이 불가능해지지 않아야 한다.
- 각 섹션 상단에는 “이 섹션에서 배우는 것” 1~2줄 요약을 둔다.
- lesson 상단에는 prerequisite, 예상 시간, 관련 lesson이 표시된다.

### 18.3 FR-03 Anatomy Map 추가 수용 기준

- 그래프형 UI가 있더라도 동일 정보를 대체 표현하는 **계층형 텍스트 뷰**를 함께 제공해야 한다.
- 각 노드는 title, short summary, related source, related section을 가진다.
- 노드를 열면 우측 context rail 또는 modal이 아니라, 가능하면 동일 학습 흐름 안에서 문맥적으로 열려야 한다.
- 그래프가 복잡해질 경우 축소/확대보다 “학습 경로 강조”를 우선한다.

표준 위젯은 semantic role을 상당 부분 자동 제공하지만, Anatomy Map 같은 커스텀 UI는 별도 의미 부여가 필요하므로 텍스트 대체 뷰를 제품 요구사항으로 명시한다.[P18][P19]

### 18.4 FR-04 Playground 추가 수용 기준

- control 변경 후 preview는 즉각적이라고 느껴지는 수준으로 반영되어야 한다.
- Playground는 lesson의 학습 목표와 무관한 옵션을 과도하게 노출하지 않는다.
- 상태 시뮬레이션은 enabled/disabled/hovered/focused/pressed를 명시적으로 보여준다.
- M2/M3 비교는 단일 토글 또는 비교 모드로 제공하되, 같은 화면에서 차이를 설명하는 문장과 함께 노출한다.

### 18.5 FR-05 Source Lens 추가 수용 기준

- 각 source card는 “무슨 문서인지”, “왜 읽어야 하는지”, “lesson의 어느 개념과 연결되는지”를 짧게 보여준다.
- 공식 문서/소스 인용은 원문 전체 복사보다 **발췌 + 해설 + 원문 이동**을 원칙으로 한다.
- source drift 검토 대상에는 API 문서, 공식 개념 문서, framework source가 모두 포함된다.

### 18.6 FR-06 Quiz / Checkpoint 추가 수용 기준

- 퀴즈는 단순 암기가 아니라 구조적 이해를 확인해야 한다.
- 오답 해설은 관련 섹션 바로가기와 함께 제공한다.
- 최소 1문제는 우선순위 또는 관계 판단 문제여야 한다.

### 18.7 FR-07 진도/북마크 추가 수용 기준

- 사용자는 비로그인 상태에서도 마지막 방문 lesson과 마지막 섹션을 확인할 수 있어야 한다.
- 사용자는 북마크한 lesson 목록을 한 곳에서 확인할 수 있어야 한다.
- 브라우저 저장소를 초기화하면 진도 손실이 발생할 수 있음을 명시한다.

### 18.8 FR-08 검색 추가 수용 기준

- 검색은 widget 이름뿐 아니라 alias/개념어로도 동작해야 한다.
- 검색 결과에는 어떤 타입의 결과인지(위젯/개념/트랙)를 표시한다.
- 결과 카드에는 왜 이 결과가 나왔는지 짧은 문맥(snippet)을 제공한다.
- 결과가 없을 경우 대체 검색어와 추천 카테고리를 제안한다.

### 18.9 FR-09 공유 URL 추가 수용 기준

- URL 복사 버튼을 lesson과 section 모두에 제공한다.
- 잘못된 section URL로 접근하면 lesson 루트로 graceful fallback 하되, 사용자에게 섹션을 찾지 못했다는 안내를 보여준다.
- path URL strategy 사용 시 hosting rewrite 정책이 운영 환경에 반영되어야 한다.[P13][P14]

---

## 19. 검색 경험과 개념 발견(Discovery) 전략

현재 PRD는 검색을 기능으로는 포함하지만, 학습 플랫폼에서 검색이 어떤 역할을 하는지는 더 구체화할 수 있다.

### 19.1 검색의 역할 정의

검색은 단순 제목 찾기가 아니라 다음 3가지 목적을 수행한다.

1. **즉시 탐색**: 알고 있는 위젯을 바로 찾기
2. **개념 발견**: `Semantics`, `RenderObject`, `WidgetState`처럼 개념으로 접근하기
3. **관계 탐색**: `ElevatedButton`에서 `FilledButton`, `ButtonStyle`, `ThemeData` 등으로 연결 이동하기

### 19.2 검색 랭킹 기본 원칙

- 제목 일치 > alias 일치 > 본문 일치 순으로 가중치
- widget 결과 > concept 결과 > track 결과 순 기본 우선
- 단, 사용자가 개념어를 입력하면 concept 결과를 상단에 우선 노출
- 난이도, 최근 열람, 북마크 여부는 개인화 보조 신호로만 사용

### 19.3 검색 metadata 설계

각 searchable document는 아래 메타데이터를 가진다.

```yaml
docType: widget
id: elevated_button
title: ElevatedButton
aliases:
  - Material elevated button
  - raised style button
concepts:
  - ButtonStyle
  - ThemeData.elevatedButtonTheme
  - WidgetState
summary: Material filled button with elevation semantics
prerequisites:
  - material_buttons_intro
```

### 19.4 검색 UX 보조 장치

- 자동완성
- 최근 검색어
- 추천 검색어
- 연관 개념 제안
- “이 개념은 어느 lesson에서 가장 잘 설명되는가” 카드

---

## 20. 콘텐츠 거버넌스 및 편집 워크플로우

현재 PRD는 source drift 문제를 정확히 인지하고 있으나, 운영 규칙이 아직 열려 있다. 실제 교육 제품으로 운영하려면 콘텐츠 제작과 검수의 역할을 분리해야 한다.

### 20.1 권장 역할 분리

- **Author**: lesson 초안 작성
- **Reviewer**: 기술 정확성 검토
- **Editor**: 학습 흐름/표현/난이도 검수
- **Release Owner**: 배포 승인 및 버전 태깅

### 20.2 콘텐츠 상태 모델

```text
draft -> in_review -> approved -> published -> needs_revalidation -> archived
```

### 20.3 검수 체크리스트

- 공식 API/문서/source와 충돌 없음
- playground 제어 항목이 lesson 목표와 일치
- quiz가 구조적 이해를 검증
- 관련 lesson 연결이 적절함
- sourceRefs, lastReviewedAt, flutterVersion 메타데이터가 채워짐

### 20.4 재검수 정책

Flutter breaking changes 문서는 특정 release 시점 기준으로 정확하며 시간이 지나면 내용이 부정확해질 수 있다고 경고한다. 따라서 본 제품은 **Flutter stable release 단위 재검수 정책**을 기본으로 둔다.[P24]

### 20.5 Source Drift 운영 기준

아래 조건에 하나라도 해당하면 `needs_revalidation` 상태로 이동한다.

- 참조 API의 시그니처 변경
- theme/state/semantics 설명에 직접 영향이 있는 release note 확인
- lesson에서 참조한 framework source의 핵심 로직 변경
- Material 3 default 값 변경

---

## 21. 접근성 제품 요구사항 상세

현재 PRD에도 접근성 요구가 있으나, Anatomy Map과 Playground 같은 커스텀 학습 UI까지 고려한 제품 수준 정의가 더 필요하다.

### 21.1 공통 접근성 요구

- 키보드만으로 핵심 학습 흐름 조작 가능
- 시각적 상태 정보에 텍스트 또는 shape 차이 병행 제공
- focus indicator가 명확히 보임
- 주요 인터랙션에는 적절한 semantic label/role 제공

### 21.2 커스텀 교육 UI 요구

- Anatomy Map에는 접근 가능한 대체 트리/리스트 뷰 제공
- 코드 비교 뷰에는 line highlight 외에 텍스트 설명 제공
- Playground control은 label과 현재 값을 스크린리더가 읽을 수 있어야 함
- Quiz 보기/선택/정답 피드백 흐름이 스크린리더로 이해 가능해야 함

Flutter 공식 문서는 표준 위젯을 가능한 한 우선 사용하고, 커스텀 컴포넌트에는 `Semantics`를 통해 role을 명시하라고 안내한다. 또한 접근성 테스트에서는 target label, target size, contrast 같은 항목을 검증할 수 있다고 설명한다.[P18][P19]

### 21.3 접근성 완료 기준

- 핵심 UI는 semantic tree에서 역할이 식별 가능
- contrast와 label 누락이 없어야 함
- 그래프/도식이 스크린리더 전용 대체 설명 없이 단독 정보원 역할을 하지 않아야 함

---

## 22. 브라우저 지원 및 릴리즈 정책

현재 문서는 Flutter Web 우선이라는 방향은 명확하지만, 실제 운영에서 어떤 브라우저를 기준선으로 삼을지 정책이 필요하다.

### 22.1 지원 정책

- **운영 기본선**: Flutter 공식 지원 범위에 포함되는 최신 주요 브라우저를 기준으로 릴리즈
- **MVP 기본 빌드 기준**: JavaScript default build를 기준선으로 사용
- **Wasm / skwasm**: 실험 또는 선택적 최적화 경로로 취급

Flutter 문서는 현재 웹 플랫폼별 지원 범위를 별도로 제공하고 있으며, Wasm은 iOS 계열 브라우저에서 실행되지 않고 Firefox/Safari 계열에도 제약이 있음을 안내한다.[P15][P16][P17]

### 22.2 사용자 커뮤니케이션 정책

- 브라우저 제약으로 특정 renderer 기능이 제한되면 제품 전체를 막지 말고, 해당 기능만 degrade 시킨다.
- lesson 읽기 자체는 가능한 범위에서 최대한 유지한다.
- 실험 기능은 Settings에서 opt-in 배지와 함께 노출한다.

### 22.3 브라우저 QA 기준

MVP QA는 최소 아래 조합을 커버한다.

- Chrome 최신
- Edge 최신
- Safari 지원 범위 내 최신
- Firefox 지원 범위 내 최신

---

## 23. 관측 지표 상세와 실험 설계

현재 PRD는 성공 지표를 제시하지만, 이벤트 정의와 가설 검증 계획이 분리되어 있다. 제품 운영 단계에서는 아래와 같이 구조화한다.

### 23.1 이벤트 분류

- **Acquisition**: catalog_open, search_open, lesson_open
- **Engagement**: anatomy_node_open, source_lens_open, playground_control_change
- **Learning**: checkpoint_view, quiz_submit, quiz_pass
- **Retention**: resume_lesson, bookmark_toggle, related_lesson_open
- **Completion**: lesson_complete

Firebase Analytics는 custom event와 user property를 통해 이런 제품 이벤트를 측정할 수 있으며, DebugView로 구현 검증이 가능하다.[P23][P25]

### 23.2 핵심 사용자 속성

- preferredLocale
- currentTrack
- experienceLevel (자가 선택)
- useMaterial3Preference
- accessibilityModeEnabled

### 23.3 초기 제품 가설 실험 예시

- **실험 A**: Playground를 Overview 바로 아래 배치 vs Source Lens 뒤에 배치
- **실험 B**: Anatomy Map 기본 열림 vs Runtime View 기본 열림
- **실험 C**: Quiz를 섹션 중간 삽입 vs lesson 마지막 배치

이후 실험 기능은 Remote Config 또는 feature flag 계층으로 확장할 수 있다.[P26]

---

## 24. 출처 표기 및 라이선스 정책

이 제품은 공식 문서와 framework source를 기반으로 학습 경험을 만들기 때문에, 콘텐츠 재사용 정책을 PRD 차원에서도 명시할 필요가 있다.

### 24.1 원칙

- 공식 문서/소스 전체 복제형 제품이 되지 않는다.
- lesson은 **요약·해설·연결·시뮬레이션**에 가치를 둔다.
- 원문은 링크로 이동 가능하게 하고, 발췌는 최소 범위만 사용한다.

### 24.2 표기 정책

- 각 lesson은 `sourceRefs`를 가진다.
- Source Lens 카드마다 문서 종류(API / concept / source)와 출처를 표기한다.
- 발췌가 있는 경우 원문 링크와 검토 일자를 함께 둔다.

Flutter 문서 사이트는 문서 본문에 대해 CC BY 4.0, 코드 샘플에 대해 3-Clause BSD License를 명시하고 있다.[P27]

---

## 25. MVP 출시 게이트(Launch Gates)

MVP 출시 여부는 단순 기능 구현이 아니라 아래 게이트를 모두 통과해야 한다.

### 25.1 콘텐츠 게이트

- `ElevatedButton` lesson 완성
- 최소 1개의 related lesson stub 또는 preview 공개
- quiz 3문항 이상
- sourceRefs 및 검수 메타데이터 채움

### 25.2 품질 게이트

- 핵심 라우트 deep link 동작
- 에러/empty/loading 상태 UX 정의 완료
- 주요 브라우저 smoke QA 완료
- 접근성 smoke QA 완료

### 25.3 운영 게이트

- 핵심 analytics 이벤트 검증 완료
- 버전 태깅 및 검수 owner 지정
- 콘텐츠 릴리즈 절차 문서화

### 25.4 성과 판단 기간

MVP 성공 여부는 출시 직후 하루 수치가 아니라, 최소 2~4주 운영 데이터를 기준으로 판단한다.

---

## 추가 참고 자료

[P12]: https://docs.flutter.dev/app-architecture/recommendations "Architecture recommendations and resources"
[P13]: https://docs.flutter.dev/ui/navigation "Navigation and routing"
[P14]: https://docs.flutter.dev/ui/navigation/url-strategies "Configuring the URL strategy on the web"
[P15]: https://docs.flutter.dev/platform-integration/web/faq "Web FAQ"
[P16]: https://docs.flutter.dev/platform-integration/web/wasm "Support for WebAssembly (Wasm)"
[P17]: https://docs.flutter.dev/reference/supported-platforms "Supported deployment platforms"
[P18]: https://docs.flutter.dev/ui/accessibility/web-accessibility "Web accessibility"
[P19]: https://docs.flutter.dev/ui/accessibility/accessibility-testing "Accessibility testing"
[P20]: https://docs.flutter.dev/tools/widget-previewer "Flutter Widget Previewer"
[P21]: https://docs.flutter.dev/release/breaking-changes "Breaking changes and migration guides"
[P22]: https://docs.flutter.dev/ "Flutter documentation"
[P23]: https://firebase.google.com/docs/analytics/flutter/get-started "Get started with Google Analytics for Flutter"
[P24]: https://docs.flutter.dev/release/breaking-changes "Breaking changes and migration guides"
[P25]: https://firebase.google.com/docs/analytics/debugview "Debug events"
[P26]: https://firebase.google.com/docs/remote-config/rollouts "Remote Config rollouts"
[P27]: https://docs.flutter.dev/ "Flutter documentation"

# PRD v1.3 범위 수정본 (Append-only: Phase 1 Scope Revision)

- 문서 버전: v1.3
- 상태: Draft (Append-only Scope Revision)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 / v1.2 원문은 수정하지 않고 그대로 유지하며, 아래 내용은 Phase 1 범위와 우선순위만 재정의한다.**
- 우선순위 규칙: **Phase 1 범위, MVP 핵심 콘텐츠, 출시 게이트, 성공 지표, 로드맵과 관련해 기존 문장과 아래 문장이 충돌하면 v1.3 범위 수정본이 우선한다.**

---

## 26. Phase 1 범위 재정의: Single Widget Pilot → Core 5 Widget Foundation Track

지금까지의 문서는 `ElevatedButton` 하나를 기준으로 제품 문제와 학습 경험을 정교하게 설계해 왔다. 이 접근은 구조 학습 제품의 핵심 가치를 검증하는 데 매우 유용한 출발점이었다. 다만 실제 Phase 1 개발 범위로 들어가면, 단일 위젯을 깊게 파는 방식은 다음 한계를 가진다.

1. 제품의 첫인상이 **Button/Material 스타일링 학습 도구**로 좁게 인식될 수 있다.
2. Flutter의 핵심 설계 축인 **text / constraints / flex layout / input / scrolling**을 고르게 보여주기 어렵다.
3. 사용자는 “버튼은 알겠는데, Flutter 전체 구조가 왜 이런지”를 일반화하기 어려울 수 있다.
4. 검색, 카탈로그, 추천, 진도 저장, 관련 lesson 이동 같은 플랫폼 기능이 단일 lesson 중심으로 과도하게 최적화된다.

따라서 Phase 1은 더 이상 `ElevatedButton` 단일 lesson을 제품 중심축으로 삼지 않는다. 대신, **Flutter를 이해하기 위한 최소 공통 기반을 보여주는 5개의 기본 위젯 세트**를 하나의 학습 트랙으로 출시한다.

이 변경은 범위를 넓히는 것이 아니라, Phase 1의 성격을 **“단일 사례의 깊이 검증”에서 “기본 구조 지형도의 구축”으로 전환**하는 것이다.

---

## 26.1 기존 문서의 어떤 부분을 어떻게 해석할 것인가

아래 기존 내용은 삭제되지 않으며, v1.3 이후에는 다음처럼 해석한다.

### A. `ElevatedButton` 중심 문장

기존의 아래 표현은 더 이상 Phase 1의 출시 범위를 직접 뜻하지 않는다.

- “첫 번째 파일럿 학습 모듈은 `ElevatedButton`”
- “`ElevatedButton`을 통해 Flutter 구조 학습의 대표 모듈을 만든다”
- “`ElevatedButton`은 featured lesson으로 노출한다”
- “Phase 1. MVP = `ElevatedButton` lesson 중심”
- “MVP 출시 게이트 = `ElevatedButton` lesson 완성”
- “북극성 지표 = `ElevatedButton` lesson completion rate”

이 문장들은 이제 **기존 설계 seed** 또는 **Phase 2 Button Family Track의 선행 설계 자산**으로 취급한다.

### B. 그대로 유지되는 부분

반대로 아래 내용은 거의 그대로 유효하다.

- 문서-소스-런타임-퀴즈를 연결하는 학습 철학
- Flutter Web 우선 전략
- deep link 가능한 lesson 구조
- Playground는 자유 코드 실행이 아니라 제어 가능한 schema 기반 실험 환경이라는 원칙
- Source Lens, Anatomy Map, Runtime View, Semantics View의 제품 개념
- 로컬 진도 저장 및 선택적 Firebase 확장 전략
- 콘텐츠 버전 관리, source drift 대응, 접근성, 검색, 운영 지표 설계

즉, **제품 엔진은 유지**하고 **Phase 1에 태우는 lesson portfolio만 재정의**하는 것이다.

---

## 26.2 새 Phase 1 제품 정의

Phase 1의 정식 범위는 아래와 같다.

> **Flutter의 기본 설계 축을 이해하게 하는 5개 핵심 위젯 학습 트랙을 Flutter Web으로 출시한다.**

이 트랙의 목적은 사용자가 Phase 1 종료 시점에 아래를 설명할 수 있도록 만드는 것이다.

1. 텍스트는 어떻게 표현/스타일/의미(Semantics)로 나뉘는가
2. 박스 기반 위젯은 constraints, padding, alignment, decoration을 어떻게 합성하는가
3. Flex 계열 레이아웃은 공간을 어떻게 분배하는가
4. 입력은 hit testing과 gesture 인식 관점에서 어떻게 해석되는가
5. 스크롤 가능한 목록은 viewport와 child 생성 전략을 통해 어떻게 동작하는가
6. Widget / Element / RenderObject / Semantics를 lesson마다 다른 관점으로 연결해 볼 수 있는가

즉, 기존 `ElevatedButton` lesson이 보여주던 “구조를 파고드는 경험”은 유지하되, 이를 **5개 기초 위젯에 분산 배치**하여 Flutter의 설계 구조를 더 넓고 일반화 가능한 형태로 학습하게 한다.

---

## 26.3 Phase 1 위젯 선정 원칙

Phase 1에 포함할 기본 위젯은 아래 기준을 모두 충족해야 한다.

1. **초중급 Flutter 학습자의 실제 사용 빈도가 높을 것**
2. **서로 다른 설계 축을 대표할 것**
3. **Playground에서 안전하고 명확하게 실험 가능할 것**
4. **공식 문서, API, source, runtime 구조를 연결했을 때 교육 가치가 높을 것**
5. **Material 전용 개념에 과하게 잠기지 않고 Flutter 전반의 사고방식을 보여줄 것**

이 원칙에 따라 선정된 Phase 1 핵심 위젯은 `Text`, `Container`, `Row`, `GestureDetector`, `ListView`다. 각 위젯은 공식 API 문서만 봐도 서로 다른 역할을 명확히 드러낸다. 예를 들어 `Container`는 공통 painting/positioning/sizing 조합을 담당하는 convenience widget이고, `Row`는 가로 배열 레이아웃, `GestureDetector`는 제스처 인식, `ListView`는 가장 널리 쓰이는 scrolling widget, `Text`는 텍스트 표현과 interactivity의 출발점 역할을 한다.[P28][P29][P30][P31][P32]

---

## 26.4 Phase 1 핵심 위젯 5종 선정안

| 위젯 | 대표 학습 축 | 선정 이유 | 핵심 구조 포인트 | Phase 1 내 연결 lesson |
|---|---|---|---|---|
| `Text` | text / typography / semantics | 모든 앱의 기본 표현 단위이며 style inheritance와 의미 전달의 출발점이 된다 | `TextStyle`, `DefaultTextStyle`, overflow, line breaking, semantics label | `GestureDetector`, `Container` |
| `Container` | box / constraints / paint | sizing, padding, alignment, decoration을 한 번에 보여주는 대표 convenience widget이다 | constraints, padding vs margin, alignment, decoration, clip | `Row`, `ListView` |
| `Row` | flex layout | 공간 분배와 overflow를 가장 직관적으로 보여주는 레이아웃 위젯이다 | main/cross axis, `Expanded`, `Flexible`, overflow, text direction | `Container`, `ListView` |
| `GestureDetector` | input / hit testing / semantics 연결 | UI 입력이 어떻게 구조화되는지 보여주는 기본 위젯이다 | tap/long press, behavior, hit test 영역, semantics 연동 | `Text`, `ListView` |
| `ListView` | scrolling / viewport / lazy child creation | 앱 구조를 “정적인 배치”에서 “스크롤 가능한 구조”로 확장하는 핵심 위젯이다 | viewport, child 생성 방식, `itemExtent`, `shrinkWrap`, controller basics | `Row`, `GestureDetector` |

### 왜 `ElevatedButton`이 Phase 1의 중심이 아니게 되었는가

`ElevatedButton`은 여전히 교육 가치가 매우 높다. 하지만 이 위젯은 다음 개념을 한 번에 포함한다.

- Material design semantics
- `ButtonStyle`
- component theme / app theme / default style resolution
- state-aware visual properties
- interactive state controller
- Material 2 / Material 3 차이

이 주제들은 매우 훌륭하지만, Phase 1에서는 오히려 **“기본 구조를 일반화하는 데 필요한 최소 공통 기반”** 보다 한 단계 위의 조합형 주제다. 따라서 `ElevatedButton`은 폐기 대상이 아니라, **Phase 2의 Button Family Track으로 승격**시키는 편이 더 적절하다.

---

## 26.5 Phase 1 학습 트랙 구조

### 26.5.1 트랙 명칭

- 가칭: **Core 5 Widgets Foundation Track**
- 트랙 ID: `core_widgets_foundation`

### 26.5.2 추천 학습 순서

1. `Text`
2. `Container`
3. `Row`
4. `GestureDetector`
5. `ListView`

이 순서는 다음 학습 흐름을 의도한다.

- **Text**로 표현의 기본 단위를 익힌다.
- **Container**로 박스 모델과 constraints/decoration 감각을 만든다.
- **Row**로 공간 분배와 layout 오류를 이해한다.
- **GestureDetector**로 입력과 hit testing을 이해한다.
- **ListView**로 scrolling/viewport/lazy child 생성 개념으로 확장한다.

### 26.5.3 트랙 완료 정의

Track 완료는 단순히 5개 lesson을 열어본 상태가 아니다. 아래 기준을 모두 만족해야 한다.

- 5개 lesson 중 모든 lesson을 최소 1회 진입
- 5개 lesson 각각에서 필수 섹션 최소 1회 열람
- 5개 lesson 각각에서 Playground 최소 1회 조작
- 5개 lesson 각각의 Quiz 제출 완료
- 사용자가 track 완료 또는 자동 완료 기준 충족

---

## 26.6 Phase 1 공통 Lesson 템플릿

기존 Lesson 상세 페이지 템플릿은 유지하되, Phase 1의 5개 위젯에 대해 아래 공통 구조를 **의무**로 둔다.

1. **Overview**
2. **API Snapshot**
3. **Anatomy Map**
4. **Source Lens**
5. **Playground**
6. **Runtime View**
7. **Semantics View**
8. **Quiz / Checkpoint**
9. **Related Lessons**
10. **Track Progress**

즉, 기존 `ElevatedButton` lesson에만 정교하게 붙어 있던 구조를 이제 **5개 위젯 모두가 동일 수준으로 가지도록 표준화**한다.

---

## 26.7 5개 위젯별 상세 Lesson 사양

## 26.7.1 `Text` Lesson

### 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `Text`가 화면 표현에서 어떤 기본 역할을 하는가
2. style이 직접 지정된 값과 상위 텍스트 스타일 문맥 사이에서 어떻게 해석되는가
3. `maxLines`, `overflow`, `softWrap` 같은 속성이 어떤 표시 결과를 만드는가
4. 화면에 보이는 텍스트와 보조기기에 전달되는 의미가 어떻게 달라질 수 있는가
5. 텍스트 interactivity가 필요할 때 어떤 구조적 선택지가 있는가

### 필수 Anatomy Node

- `Text`
- `TextStyle`
- `DefaultTextStyle`
- `overflow`
- `maxLines`
- `semantics`

### 필수 Playground Control

- text preset
- font size
- font weight
- text align
- max lines
- overflow mode
- soft wrap
- semantics label on/off

### 필수 Quiz 주제

- style inheritance
- overflow/maxLines 관계
- semantics label 필요 상황
- 텍스트를 interactive 하게 만들 때의 구조적 선택

---

## 26.7.2 `Container` Lesson

### 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `Container`가 단일 기능 위젯이 아니라 여러 box 관련 개념을 합친 convenience widget이라는 점
2. `padding`, `margin`, `alignment`, `constraints`, `decoration`이 각각 어느 층위의 역할인지
3. `width`/`height`를 주는 것과 constraints를 주는 것의 사고방식 차이
4. child가 있을 때와 없을 때 레이아웃 감각이 어떻게 달라지는지
5. 박스 위젯의 시각 표현과 레이아웃 책임을 어떻게 나누어 생각해야 하는지

### 필수 Anatomy Node

- `Container`
- `constraints`
- `padding`
- `alignment`
- `decoration`
- `clip`

### 필수 Playground Control

- width / height
- padding
- margin
- alignment
- color
- border radius
- decoration preset
- clip behavior
- constrained preset

### 필수 Quiz 주제

- padding vs margin
- decoration과 size의 관계
- alignment가 child 배치에 미치는 영향
- constraints가 없는 경우와 있는 경우의 차이

---

## 26.7.3 `Row` Lesson

### 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `Row`가 horizontal `Flex` 배치의 대표 사례라는 점
2. main axis / cross axis가 무엇인지
3. `Expanded`, `Flexible`, fixed-size child가 공간을 어떻게 나눠 가지는지
4. overflow가 왜 발생하는지
5. 스크롤해야 할 상황과 flex로 해결해야 할 상황을 구분하는 기준

### 필수 Anatomy Node

- `Row`
- `Flex`
- `Expanded`
- `Flexible`
- `mainAxisAlignment`
- `crossAxisAlignment`
- `overflow`

### 필수 Playground Control

- child count
- child width preset
- `mainAxisAlignment`
- `crossAxisAlignment`
- `mainAxisSize`
- `Expanded` toggle
- `Flexible` toggle
- text direction

### 필수 Quiz 주제

- main axis / cross axis 판별
- `Expanded`의 효과
- overflow 원인 분석
- `Row` 대신 scroll 구조를 써야 하는 경우

---

## 26.7.4 `GestureDetector` Lesson

### 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `GestureDetector`가 화면의 “보이는 스타일”이 아니라 “입력 해석”을 담당하는 위젯이라는 점
2. tap / double tap / long press가 callback 수준에서 어떻게 모델링되는지
3. child의 시각적 영역과 실제 입력 영역을 어떻게 구분해야 하는지
4. `behavior`가 입력 처리에 어떤 차이를 만드는지
5. semantics와 hit testing 사이에 어떤 제품 설계 고려가 필요한지

### 필수 Anatomy Node

- `GestureDetector`
- pointer input
- hit test
- gesture callbacks
- `behavior`
- semantics

### 필수 Playground Control

- onTap on/off
- onDoubleTap on/off
- onLongPress on/off
- behavior mode
- touch area size
- child visibility preset
- excludeFromSemantics on/off
- event log reset

### 필수 Quiz 주제

- callback 종류 구분
- hit test area와 visual area 관계
- behavior 차이
- semantics 제외 시 영향

---

## 26.7.5 `ListView` Lesson

### 학습 목표

사용자는 lesson 완료 후 아래를 설명할 수 있어야 한다.

1. `ListView`가 scrollable linear layout이라는 점
2. children 방식과 builder 방식의 차이
3. viewport라는 개념이 왜 필요한지
4. `itemExtent`, `shrinkWrap`, scroll direction이 성능/레이아웃에 어떤 차이를 만드는지
5. 단순 나열 레이아웃과 스크롤 구조의 차이를 설명할 수 있는지

### 필수 Anatomy Node

- `ListView`
- `ScrollView`
- viewport
- `SliverList`
- `ScrollController`
- `itemExtent`
- `shrinkWrap`

### 필수 Playground Control

- item count
- children vs builder mode
- item extent on/off
- shrinkWrap on/off
- scroll direction
- padding
- reset scroll
- initial position preset

### 필수 Quiz 주제

- children vs builder 선택 기준
- viewport 개념
- `itemExtent`의 의미
- `shrinkWrap` 사용 판단
- 스크롤 구조와 일반 레이아웃 구조의 차이

---

## 26.8 MVP 기능 요구사항 보정(Phase 1 기준)

기존 FR-01 ~ FR-09는 유지하되, 아래 보정 규칙을 추가한다.

### 26.8.1 카탈로그

- 홈과 카탈로그의 featured 영역은 더 이상 단일 `ElevatedButton` lesson이 아니다.
- 홈 featured는 **Core 5 Widgets Foundation Track**을 대표 카드로 노출한다.
- 카탈로그 상단에는 신규 사용자에게 `Text → Container → Row → GestureDetector → ListView`의 권장 순서를 안내한다.

### 26.8.2 Lesson 상세

- 5개 핵심 위젯 모두가 공통 lesson 템플릿을 가져야 한다.
- 특정 lesson만 Playground나 Runtime View가 정교하고, 다른 lesson은 축약형인 상태로는 Phase 1 출시 불가다.
- 최소 품질 기준은 **5개 lesson 간 균일성**이다.

### 26.8.3 Anatomy Map

- 각 lesson은 최소 5개 이상의 핵심 node를 가져야 한다.
- node 간 관계는 해당 lesson 내부 관계뿐 아니라 다른 Phase 1 lesson으로도 연결되어야 한다.
- 예: `Row`에서 overflow 관련 node를 열면 `ListView`로의 연결을 제안할 수 있어야 한다.

### 26.8.4 Playground

- 각 lesson의 Playground는 해당 위젯의 핵심 구조 포인트만 노출해야 한다.
- 단일 lesson에 옵션을 과도하게 몰아넣지 않는다.
- Playground는 “API 전체를 다 건드리는 도구”가 아니라 “개념을 드러내는 실험 장치”여야 한다.

### 26.8.5 검색

- 검색은 5개 위젯명뿐 아니라 관련 개념어로도 동작해야 한다.
- 예:
  - `flex`, `expanded` → `Row`
  - `overflow`, `maxLines` → `Text`
  - `tap`, `long press`, `hit test` → `GestureDetector`
  - `scroll`, `viewport`, `lazy list` → `ListView`
  - `padding`, `constraints`, `decoration` → `Container`

### 26.8.6 공유 가능한 URL

- 모든 Phase 1 lesson은 direct URL 진입 가능해야 한다.
- 최소 2개 이상의 section/deep link anchor를 각 lesson에 제공한다.
- Track 페이지와 lesson 페이지 사이를 오갈 때도 주소창이 일관되게 유지되어야 한다.

---

## 26.9 정보구조(IA)와 UX 변경 사항

### 26.9.1 홈

홈의 핵심 진입점은 아래 순서로 바뀐다.

1. Featured Track: Core 5 Widgets Foundation Track
2. 추천 시작 lesson: `Text`
3. 최근 본 lesson
4. 진행 중 트랙
5. 향후 심화 트랙 preview (`Button Family`, `Accessibility`, `Rendering Basics` 등)

### 26.9.2 Track 상세 페이지

기존 `/tracks/:trackId`를 Phase 1부터 본격 사용한다.

필수 정보:

- 트랙 설명
- 포함 lesson 5개
- 추천 순서
- prerequisites
- 현재 진도(예: 2/5 완료)
- 이어보기 CTA
- “이 트랙을 마치면 이해하게 되는 것” 요약

### 26.9.3 Lesson 간 이어보기 UX

각 lesson 하단에는 아래가 필요하다.

- 이전 lesson
- 다음 lesson
- 이 lesson과 가장 밀접한 개념 lesson 2개
- 현재까지의 track progress bar

Phase 1이 단일 lesson이 아니라 5개 lesson이 되는 순간, “lesson 자체의 깊이”만큼이나 **lesson 간 전이 설계**가 중요해진다.

---

## 26.10 성공 지표 재정의

기존 `ElevatedButton` 단일 lesson completion rate 중심 지표는 Phase 1의 성공을 충분히 설명하지 못한다. 따라서 아래처럼 재정의한다.

### 26.10.1 북극성 지표

- **Core 5 Foundation Track Completion Rate**
  - 정의: Track 진입 사용자 중 5개 lesson 완료 기준을 충족한 비율

### 26.10.2 보조 지표

- 1번 lesson → 2번 lesson 이동률
- lesson 간 전환율 (`Text` → `Container`, `Container` → `Row` 등)
- lesson별 completion rate
- track resume rate
- Playground interaction density
- related lesson click-through rate
- search-to-lesson conversion
- quiz pass rate by lesson
- 7일 / 14일 내 재방문율

### 26.10.3 제품 가설 보정

- 단일 심화 lesson보다, 상호 연결된 5개 기초 lesson 트랙이 더 높은 재방문과 탐색 전환을 만들 것이다.
- 기초 위젯 5개를 먼저 이해한 사용자가 이후 `ElevatedButton` 같은 조합형 위젯을 더 잘 이해할 것이다.
- Track progress가 단일 lesson progress보다 학습 지속성을 더 잘 만든다.

---

## 26.11 로드맵 재정의

## 26.11.1 Phase 0. 설계 기반 구축

- 정보구조(IA)
- lesson schema 정의
- Track schema 정의
- Core 5 위젯 lesson blueprint 초안 작성
- 공통 Anatomy Map / Source Lens / Playground / Quiz 템플릿 설계

## 26.11.2 Phase 1. MVP (변경 후)

- Core 5 Widgets Foundation Track
- `Text` lesson
- `Container` lesson
- `Row` lesson
- `GestureDetector` lesson
- `ListView` lesson
- Track progress
- 검색
- 로컬 진도 저장
- 공유 URL

## 26.11.3 Phase 2. 확장

- Button Family Track
  - `ElevatedButton`
  - `FilledButton`
  - `TextButton`
  - `OutlinedButton`
  - `ButtonStyleButton`
- 계정 기반 진도 동기화
- 검색 고도화
- lesson 관계 그래프 고도화

## 26.11.4 Phase 3. 고급 학습 기능

- 비교 보기 (`Row` vs `ListView`, `GestureDetector` vs `InkWell`, `ElevatedButton` vs `FilledButton`)
- 스터디/팀 기능
- 학습 코멘트/피드백
- 내부 구조/소스 diff 기반 심화 뷰

---

## 26.12 MVP 출시 게이트 재정의

기존 출시 게이트에 아래 규칙을 추가한다.

### 26.12.1 콘텐츠 게이트

- Core 5 위젯 lesson 5개 완성
- 각 lesson에 quiz 3문항 이상
- 각 lesson에 sourceRefs 및 검수 메타데이터 존재
- 각 lesson에 related lesson 2개 이상 연결
- Track 설명, 순서, prerequisites, completion 정의 작성 완료

### 26.12.2 품질 게이트

- 5개 lesson 모두 deep link 동작
- 5개 lesson 모두 loading/error/empty/fallback 상태 정의 완료
- 5개 lesson 모두 접근성 smoke QA 통과
- 5개 lesson 모두 Playground 즉시 반응 UX 확인
- lesson 간 이전/다음/관련 이동 동선 확인

### 26.12.3 운영 게이트

- lesson_open / lesson_complete / track_open / track_complete 이벤트 검증
- 검색과 related lesson 추천 이벤트 검증
- 버전 태깅 및 검수 owner 지정
- 콘텐츠 재검수 프로세스 문서화

---

## 26.13 콘텐츠 제작 및 운영 계획 상세

Phase 1이 5개 lesson으로 확장되면, 가장 먼저 필요한 것은 lesson 수를 늘리는 것이 아니라 **공통 제작 템플릿**을 먼저 고정하는 것이다.

### 26.13.1 제작 순서 권장안

#### Wave 1: 구조 기반 lesson
- `Text`
- `Container`
- `Row`

이 3개는 공통 UI와 lesson 템플릿을 안정화하는 데 가장 유리하다.

#### Wave 2: 상호작용 / scrolling lesson
- `GestureDetector`
- `ListView`

이 2개는 event log, viewport shell, scroll reset 같은 추가 UI가 필요하므로 2차 wave가 적절하다.

### 26.13.2 공통 저작 블록

모든 lesson author가 재사용해야 하는 block은 아래와 같다.

- overview summary block
- API snapshot card
- anatomy node card
- source reference card
- playground control group
- runtime explanation block
- semantics warning / note block
- checkpoint quiz block
- related lesson recommendation block

### 26.13.3 운영상 이점

이 구조를 사용하면 Phase 2에서 `ElevatedButton`을 추가할 때도 **새 lesson 하나를 만드는 것이 아니라, 이미 검증된 lesson 템플릿에 고급 사례를 꽂는 방식**으로 확장할 수 있다.

---

## 26.14 리스크 및 대응 업데이트

### 리스크 1. 콘텐츠 범위가 단일 lesson보다 넓어져 제작 비용이 상승한다

- **대응**: 5개 lesson을 동시에 깊게 만들기보다, 공통 템플릿과 공통 컴포넌트를 먼저 고정하고 Wave 방식으로 제작한다.

### 리스크 2. 5개 lesson의 품질 편차가 생길 수 있다

- **대응**: lesson마다 같은 섹션 구조, node 수 최소 기준, Playground 최소 기준, quiz 최소 기준을 강제한다.

### 리스크 3. `ElevatedButton`을 기대한 사용자에게 방향 전환처럼 보일 수 있다

- **대응**: 홈과 로드맵에서 `Button Family Track (Coming Next)`를 명시해 기존 설계 자산이 사라진 것이 아니라 뒤로 이동했음을 분명히 보여준다.

### 리스크 4. 기본 위젯 중심 구성이라 제품이 너무 얕게 느껴질 수 있다

- **대응**: 기초 lesson이라도 내부 구조, constraints, runtime, semantics까지 반드시 연결해 “쉽지만 얕지 않은” 경험을 유지한다.

---

## 26.15 Phase 1 이후 `ElevatedButton`의 재배치 전략

`ElevatedButton`은 더 이상 Phase 1의 제품 아이덴티티를 대표하지 않지만, 여전히 다음 이유로 매우 중요한 lesson이다.

1. Material component theming의 대표 사례다.
2. state-aware styling을 배울 수 있다.
3. `ButtonStyleButton` 계층을 이해하는 좋은 관문이다.
4. Phase 1의 5개 기초 lesson에서 배운 text / box / layout / input / semantics가 한 곳에 조합된다.

따라서 `ElevatedButton`은 Phase 2에서 아래 중 하나의 역할로 재도입한다.

- **Button Family Track의 첫 lesson**
- **“기초를 조합해 만든 실제 component” 시리즈의 대표 lesson**
- **Phase 1 완료자를 위한 bridge lesson**

즉, 지금의 변경은 `ElevatedButton`의 가치 하락이 아니라 **도입 시점의 재배치**다.

---

## 추가 참고 자료

[P28]: https://api.flutter.dev/flutter/widgets/Text-class.html "Text class"
[P29]: https://api.flutter.dev/flutter/widgets/Container-class.html "Container class"
[P30]: https://api.flutter.dev/flutter/widgets/Row-class.html "Row class"
[P31]: https://api.flutter.dev/flutter/widgets/ListView-class.html "ListView class"
[P32]: https://api.flutter.dev/flutter/widgets/GestureDetector-class.html "GestureDetector class"
[P33]: https://api.flutter.dev/flutter/widgets/Semantics-class.html "Semantics class"
[P34]: https://docs.flutter.dev/resources/architectural-overview "Flutter architectural overview"



# PRD v1.4 로드맵 확장본 (Append-only: Phase 1~5 Ladder + Beyond)

- 문서 버전: v1.4
- 상태: Draft (Reviewed, Append-only Roadmap Expansion)
- 작성일: 2026-03-09
- 원칙: **위의 v1.1 / v1.2 / v1.3 원문은 수정하지 않고 그대로 유지한다.**
- 우선순위 규칙: **Phase 2~5의 공식 범위, 난이도 상승 규칙, phase별 core widget set, satellite lesson, compare lab, capstone lab, 이후 확장 방향과 관련해 기존 문장과 아래 문장이 충돌하면 v1.4 확장본이 우선한다.**
- 해석 원칙: **기존의 `ElevatedButton` 중심 설계와 Button Family 설계는 폐기하지 않는다. 다만 그것을 전체 로드맵 속 적절한 난이도 단계에 다시 배치한다.**

---

## 27. 현재 문서 구조 분석과 v1.4 확장이 해결해야 할 문제

v1.3까지의 문서는 **Phase 1** 정의가 매우 좋다. 특히 Core 5 Widget Foundation Track(`Text`, `Container`, `Row`, `GestureDetector`, `ListView`)은 Flutter의 기본 구조를 배우기 위한 첫 단계로 타당하며, lesson template, Anatomy Map, Playground, Quiz, related lesson, track progress까지 제품과 기술의 중심축이 잘 잡혀 있다.[P28][P29][P30][P31][P32][P34]

반면 Phase 2 이후는 아직 다음 한계를 가진다.

1. **Phase 이름은 있으나 phase portfolio가 약하다.**  
   “Button Family Track”, “고급 학습 기능”처럼 방향은 있으나, 각 단계에서 실제로 어떤 위젯 5개를 핵심 축으로 삼을지, 사용자가 무엇을 설명 가능해져야 하는지, 이전 phase와 무엇이 달라지는지가 문서상 충분히 분리되어 있지 않다.

2. **난이도 상승의 논리가 명시적이지 않다.**  
   지금 구조만으로는 “왜 이 위젯이 다음 phase인가?”를 판단하기 어렵다. 교육 제품은 기능 목록보다 **학습 곡선의 설계**가 더 중요하므로, 각 phase가 한 단계씩 어떤 추상화 점프를 일으키는지 명확해야 한다.

3. **기존 설계 자산의 재배치 규칙이 더 필요하다.**  
   `ElevatedButton`과 Button Family 관련 설계는 이미 밀도가 높다. 그러나 현재 문서는 그것을 “Phase 2 확장” 정도로만 설명하고 있어, 어떤 범위는 core lesson으로 들어오고 어떤 범위는 satellite lesson으로 남는지 정교하지 않다.

4. **Phase 5 이전에 어디까지를 제품의 주력 코어로 볼지 정의가 필요하다.**  
   교육 플랫폼의 초기 정체성은 “Flutter의 구조를 단계적으로 해부하는 도구”다. 그렇다면 최소한 Phase 5까지는 **기초 → 조합형 컴포넌트 → 반응형 상태/비동기 → 고급 레이아웃/스크롤/페인트 → 프레임워크 내부 조정 메커니즘**이 하나의 명확한 사다리로 보여야 한다.

5. **Phase 5 이후 확장 방향이 아직 정리되지 않았다.**  
   현재 문서는 Phase 3 이후의 상상력은 보이지만, 실제로 어떤 콘텐츠 패밀리·제품 기능·운영 체계로 확장할지가 roadmap 수준에서 구조화되어 있지 않다.

따라서 v1.4는 roadmap의 기본 단위를 “막연한 확장”이 아니라 **명확한 학습 층위(learning ladder)** 로 재설계한다. 각 phase는 다음을 가져야 한다.

- **Core 5 widget lessons**
- **2~4개의 satellite/compare lessons**
- **1개의 capstone lab**
- **명시적인 선행 개념**
- **phase 종료 시점의 설명 가능 학습 목표**
- **phase별 출시 게이트**

이렇게 재정의하면 기존 Core 5 Foundation Track을 유지하면서도, Phase 2~5가 단순 backlog가 아니라 **점점 더 깊은 Flutter mental model**로 이어지는 구조가 된다.

---

## 27.1 v1.4 다단계 로드맵 설계 원칙

1. **각 phase는 5개의 core widget lesson을 가진다.**
   - core 5는 해당 phase의 정체성을 결정한다.
   - 사용자가 “이 phase를 마쳤다”고 말할 수 있으려면 core 5를 기준으로 판단한다.

2. **각 phase는 하나의 지배적인 추상화 점프를 가진다.**
   - Phase 1: concrete visual primitives
   - Phase 2: composed material interaction
   - Phase 3: reactive binding / async / validation
   - Phase 4: viewport / sliver / paint / advanced layout
   - Phase 5: inherited dependency / bubbling / focus / overlay / navigation

3. **phase가 올라갈수록 위젯의 시각적 복잡도뿐 아니라 설명해야 할 내부 시스템이 늘어난다.**
   - 예: `Text`는 “표현” 중심이지만,
   - `TextField`는 controller / focus / input / semantics,
   - `FutureBuilder`는 async snapshot lifecycle,
   - `CustomScrollView`는 sliver protocol,
   - `Navigator`는 route stack과 overlay 관계까지 설명해야 한다.

4. **satellite lesson은 core 5를 보강하되 phase identity를 흐리지 않아야 한다.**
   - 예: Phase 2의 `FilledButton`, `OutlinedButton`, `TextButton`, `ButtonStyleButton`은 `ElevatedButton`을 보강하는 satellite로 적합하다.
   - 하지만 core 5 자체를 전부 button family로 채우면 phase의 교육 축이 지나치게 좁아질 수 있다.

5. **capstone lab은 이전 phase 지식을 실제 조합으로 재사용하게 만들어야 한다.**
   - capstone은 “또 다른 widget lesson”이 아니라, phase에서 배운 mental model을 합치는 평가형/탐색형 경험이다.

6. **사용자는 어떤 phase든 직접 들어갈 수 있지만, 추천 경로는 선행 개념을 반영한다.**
   - 고급 사용자를 위해 open browse는 허용한다.
   - 다만 recommended order, prerequisite badge, readiness check를 명확히 둔다.

7. **Phase 5까지를 ‘제품의 첫 번째 완성형 커리큘럼’으로 정의한다.**
   - 즉, Phase 1~5가 완성되면 Flutter Anatomy Lab은 단순 실험 프로젝트가 아니라, “Flutter 구조 학습 플랫폼 1차 완성본”으로 간주한다.

---

## 27.2 공식 Phase Ladder 요약

| Phase | 트랙명 | 난이도 | 핵심 질문 | Core 5 Widgets | phase 종료 시 학습자가 설명할 수 있어야 하는 것 |
|---|---|---:|---|---|---|
| 1 | Foundation Track | 1 | Flutter UI의 가장 기본적인 구성 단위는 무엇인가? | `Text`, `Container`, `Row`, `GestureDetector`, `ListView` | text/box/layout/input/scroll의 가장 기초 mental model |
| 2 | Composition & Material Interaction Track | 2 | 기초 위젯이 실제 앱 화면과 상호작용 컴포넌트로 어떻게 조합되는가? | `Stack`, `Scaffold`, `InkWell`, `TextField`, `ElevatedButton` | app shell, overlay order, material interaction, focus/controller, style/theme/state |
| 3 | Reactive State, Form & Async Track | 3 | 화면은 비동기 데이터와 listenable 상태에 어떻게 반응하는가? | `Form`, `ValueListenableBuilder`, `FutureBuilder`, `StreamBuilder`, `AnimatedBuilder` | validation, local reactive binding, one-shot async, continuous async, listenable rebuild |
| 4 | Advanced Layout, Scroll & Paint Track | 4 | Flutter는 고급 스크롤/슬리버/커스텀 페인트를 어떻게 구성하는가? | `LayoutBuilder`, `CustomScrollView`, `SliverList`, `SliverAppBar`, `CustomPaint` | constraints-based branching, viewport/sliver 관계, scroll composition, paint 책임 |
| 5 | Framework Internals & App Infrastructure Track | 5 | 프레임워크 내부의 의존성 전달·이벤트 버블링·포커스·오버레이·내비게이션은 어떻게 동작하는가? | `InheritedWidget`, `NotificationListener`, `Focus`, `Overlay`, `Navigator` | tree-wide dependency, bubbling, focus tree, floating layers, route stack mental model |

위 phase 구성은 Flutter API의 역할 분리와도 잘 맞는다. 예를 들어 `Stack`은 children을 box의 edge 기준으로 배치하는 overlay layout이고, `Scaffold`는 Material app shell의 기본 구조를 제공한다. `TextField`와 `ElevatedButton`은 실제 앱에서 가장 자주 쓰이는 interactive material component이며, `FutureBuilder`와 `StreamBuilder`는 비동기 상태를 화면 빌드에 연결하는 대표 패턴이다. 더 나아가 `CustomScrollView`/`SliverList`는 sliver 기반 viewport 개념을, `InheritedWidget`/`Navigator`는 framework-level coordination을 보여준다.[P35][P36][P38][P39][P42][P43][P46][P47][P50][P54]

---

## 27.3 Phase 진행 규칙과 사용자 경험 정책

### 27.3.1 접근 정책

- 모든 phase와 lesson은 direct URL로 진입 가능하다.
- 다만 현재 사용자의 진도에 비해 두 단계 이상 높은 phase에 진입할 경우, “advanced lesson” 배지를 표시한다.
- 검색 결과에도 `difficulty`, `phase`, `prerequisites`를 함께 노출한다.

### 27.3.2 추천 경로 정책

- phase의 core 5는 추천 순서대로 정렬된다.
- 같은 phase의 satellite lesson은 기본적으로 3개 이상의 core lesson을 완료한 뒤 추천한다.
- capstone lab은 core 5 중 최소 4개 lesson 완료 후 적극적으로 노출한다.
- 다음 phase 추천은 현재 phase의 capstone 완료 또는 readiness check 통과 시 강화한다.

### 27.3.3 평가 정책

- 각 core lesson은 최소 3문항 이상 quiz를 유지한다.
- 각 phase는 phase-level readiness check를 가진다.
- capstone은 pass/fail보다 “설명 가능한 이해를 얼마나 조합했는가”를 확인하는 체크리스트 중심으로 설계한다.

### 27.3.4 누적 포트폴리오 정책

Phase 1~5를 모두 core 기준으로 합치면 **25개의 대표 위젯 lesson**이 생긴다. satellite와 capstone까지 포함하면 첫 번째 완성형 커리큘럼은 대략 아래 규모가 된다.

- core lessons: 25
- satellite / compare lessons: 10~20
- capstone labs: 5
- phase overview / readiness checks / track landing pages: 10개 내외

즉, v1.4 이후의 목표는 “lesson 몇 개 더 추가”가 아니라, **학습 사다리 전체를 제품의 공식 구조로 고정**하는 것이다.

---

## 27.4 Phase 1은 유지, Phase 2부터 새 공식 체계 적용

Phase 1의 공식 정의는 **v1.3의 26장 전체**를 유지한다. 즉, `Text`, `Container`, `Row`, `GestureDetector`, `ListView`를 중심으로 하는 Core 5 Foundation Track은 그대로 Phase 1이다.[P28][P29][P30][P31][P32]

v1.4의 핵심 변화는 **Phase 2~5를 동일한 해상도로 끌어올리는 것**이다. 이제부터 Phase 2 이후는 단순 확장 후보가 아니라, 제품의 공식 curriculum ladder로 취급한다.

---

## 27.5 Phase 2. Composition & Material Interaction Track

### 27.5.1 Phase 정체성

Phase 2는 “기초 위젯”에서 “실제 앱 화면과 상호작용 컴포넌트”로 넘어가는 구간이다. 여기서 학습자는 단순 box/layout/input을 넘어서 다음을 만나게 된다.

- **app shell**
- **overlay/paint order**
- **material interaction feedback**
- **text input lifecycle**
- **button style/theme/state resolution**

이 phase는 특히 `GestureDetector` 이후 `InkWell`을 배우고, `Text` 이후 `TextField`를 배우며, Phase 1에서 쌓은 감각을 실제 product UI 조합으로 끌어올리는 역할을 한다. `Stack`은 child를 box edge 기준으로 배치하며 paint order까지 드러내고, `Scaffold`는 기본 Material visual layout structure를 제공한다. `TextField`는 text input을 받고, `ElevatedButton`은 대표적인 Material button으로서 state-aware style과 theme override를 보여준다.[P35][P36][P37][P38][P39]

### 27.5.2 Core 5 Widgets

| 위젯 | 핵심 학습 질문 | Anatomy 핵심 노드 | Playground 핵심 컨트롤 | 선정 이유 |
|---|---|---|---|---|
| `Stack` | 겹침과 paint order는 어떻게 설명되는가? | `Stack`, `Positioned`, `alignment`, `clipBehavior`, paint order | child 수, 위치, alignment, clipping, z-order preset | `Row` 이후 overlay composition으로 자연스럽게 확장 |
| `Scaffold` | 앱 화면의 기본 shell은 어떤 slot 구조를 가지는가? | `Scaffold`, `AppBar`, `body`, `drawer`, `bottomSheet`, `SnackBar` | appBar on/off, FAB, drawer, snackbar, bottom sheet preset | 실제 앱 화면 구조를 배우는 첫 관문 |
| `InkWell` | Gesture가 Material feedback와 결합되면 무엇이 달라지는가? | `InkWell`, `Material`, splash, highlight, borderRadius, semantics | splash enable, radius, containedInkWell, shape, tap target | `GestureDetector`와 대비되는 material interaction 학습 |
| `TextField` | 입력 위젯은 controller/focus/decoration/validation 전초를 어떻게 갖는가? | `TextField`, `TextEditingController`, `FocusNode`, `InputDecoration`, semantics | text 값, placeholder, error, enabled, obscure, focus, maxLines | 실제 사용자 입력의 핵심이며 Phase 3 Form으로 이어짐 |
| `ElevatedButton` | style/theme/default/state가 버튼 표현을 어떻게 결정하는가? | `ElevatedButton`, `ButtonStyle`, `ButtonStyleButton`, `Theme`, `WidgetState`, semantics | enabled, icon, M2/M3, foreground/background, elevation, shape, state preset | 기존 설계 자산을 phase 맥락에 맞게 재도입 |

### 27.5.3 Satellite / Compare Lessons

Phase 2는 기존 Button Family 설계 자산을 보존하기 위해 아래 lesson을 satellite로 둔다.

- `FilledButton`
- `OutlinedButton`
- `TextButton`
- `ButtonStyleButton`
- compare: `GestureDetector` vs `InkWell`
- compare: `Text` vs `TextField`
- compare: `ElevatedButton` vs `FilledButton`

이렇게 하면 `ElevatedButton`이 다시 중요 lesson으로 올라오되, Phase 전체가 button family로 과도하게 수렴하지 않는다.

### 27.5.4 Capstone Lab

**Capstone: “검색 + CTA 화면 해부하기”**

학습자는 아래 요소가 들어간 단일 화면을 해부한다.

- `Scaffold` 기반 shell
- 상단 layer badge 또는 header overlay (`Stack`)
- 검색 입력 (`TextField`)
- material tap surface (`InkWell`)
- 주요 CTA (`ElevatedButton`)

capstone의 목적은 단순 구현이 아니라, “이 화면에서 왜 `GestureDetector` 대신 `InkWell`이 더 적합한지”, “왜 shell은 `Scaffold`로 해석되는지”, “button style은 어디서 오는지”를 설명하게 만드는 것이다.

### 27.5.5 Phase 2 완료 기준

사용자는 Phase 2를 마친 뒤 아래를 설명할 수 있어야 한다.

1. `Row`/`Container` 중심의 단순 배치와 `Stack`의 overlay composition 차이
2. `Scaffold`가 app shell로서 왜 중요한지
3. `GestureDetector`와 `InkWell`의 차이
4. `TextField`의 controller / focus / decoration / semantics 기초
5. `ElevatedButton`의 style/theme/default/state 관계

---

## 27.6 Phase 3. Reactive State, Form & Async Track

### 27.6.1 Phase 정체성

Phase 3는 “컴포넌트를 본다”에서 “상태 변화가 UI에 반영되는 원리”로 넘어가는 구간이다. 여기서부터 사용자는 widget 자체보다 **binding 방식**을 설명해야 한다.

`Form`은 여러 form field를 하나의 검증 컨텍스트로 묶고, `ValueListenableBuilder`는 `ValueListenable`과 동기화된 UI를 제공한다. `FutureBuilder`와 `StreamBuilder`는 비동기 source를 builder UI에 연결하는 대표 패턴이고, `AnimatedBuilder`는 `Listenable` 기반으로 rebuild를 일으키는 성능 친화적 패턴을 보여준다.[P40][P41][P42][P43][P44]

### 27.6.2 Core 5 Widgets

| 위젯 | 핵심 학습 질문 | Anatomy 핵심 노드 | Playground / Lab 핵심 컨트롤 | 선정 이유 |
|---|---|---|---|---|
| `Form` | 여러 입력과 validation은 어떻게 묶이는가? | `Form`, `FormState`, validator, save/reset, autovalidate | field states, validator mode, save/reset, submit attempts | `TextField`의 다음 단계로서 입력 흐름을 구조화 |
| `ValueListenableBuilder` | 작은 local state를 전체 rebuild 없이 어떻게 동기화하는가? | `ValueListenable`, builder, child optimization | notifier value, child caching on/off, rebuild counter | 간단하지만 강력한 reactive binding의 출발점 |
| `FutureBuilder` | one-shot async 결과는 어떤 상태 전이를 거쳐 화면에 반영되는가? | `Future`, `AsyncSnapshot`, `ConnectionState` | idle/loading/success/error/refresh preset, latency slider | 비동기 UI의 가장 대표적 패턴 |
| `StreamBuilder` | 지속적으로 들어오는 이벤트는 UI와 어떻게 연결되는가? | `Stream`, `AsyncSnapshot`, active/done, subscription lifecycle | event stream script, pause/resume, error injection | Future와 다른 “continuous async” 학습 |
| `AnimatedBuilder` | listenable 기반의 성능 친화적 rebuild는 어떻게 설계되는가? | `Listenable`, `Animation`, builder, child subtree caching | ticker start/stop, speed, child memoization, rebuild heatmap | reactive + animation의 교차점 |

### 27.6.3 Satellite / Compare Lessons

- `TextFormField`
- `TweenAnimationBuilder`
- `AnimatedSwitcher`
- compare: `FutureBuilder` vs `StreamBuilder`
- compare: `ValueListenableBuilder` vs `AnimatedBuilder`

### 27.6.4 Capstone Lab

**Capstone: “실시간 필터링 + 상태 변화 대시보드”**

예시 시나리오:

- 상단 filter form (`Form`)
- local filter chip state (`ValueListenableBuilder`)
- initial fetch (`FutureBuilder`)
- live update panel (`StreamBuilder`)
- loading/progress animation (`AnimatedBuilder`)

이 capstone은 “state source가 무엇이냐에 따라 builder와 업데이트 전략이 달라진다”는 사실을 체감하게 만드는 것이 목적이다.

### 27.6.5 Phase 3 완료 기준

사용자는 Phase 3를 마친 뒤 아래를 설명할 수 있어야 한다.

1. local reactive state와 async source의 차이
2. `FutureBuilder`와 `StreamBuilder`의 선택 기준
3. `Form`이 field set을 어떻게 조직하는지
4. builder widget에서 child subtree optimization이 왜 중요한지
5. UI rebuild가 데이터 source의 lifecycle과 어떻게 연결되는지

---

## 27.7 Phase 4. Advanced Layout, Scroll & Paint Track

### 27.7.1 Phase 정체성

Phase 4는 사용자가 처음으로 Flutter의 고급 layout/scroll/paint 개념을 정면으로 다루는 구간이다. 여기서부터 lesson은 단일 widget 설명을 넘어 **viewport**, **sliver**, **constraints-driven branching**, **paint phase** 같은 시스템 언어를 적극적으로 사용한다.

`LayoutBuilder`는 parent constraints에 따라 widget subtree를 구성하는 패턴을 보여주고, `CustomScrollView`는 sliver들로 custom scroll effect를 만들 수 있게 한다. `SliverList`와 `SliverAppBar`는 실제 sliver composition의 대표 사례이며, `CustomPaint`는 layout이 아니라 paint 단계에서 그림을 그리는 방식을 드러낸다.[P45][P46][P47][P48][P49]

### 27.7.2 Core 5 Widgets

| 위젯 | 핵심 학습 질문 | Anatomy 핵심 노드 | Playground / Lab 핵심 컨트롤 | 선정 이유 |
|---|---|---|---|---|
| `LayoutBuilder` | parent constraints에 따라 subtree를 바꾸는 기준은 무엇인가? | `LayoutBuilder`, constraints, breakpoint logic, rebuild timing | width preset, breakpoint rules, branch preview | responsive/adaptive branching의 핵심 관문 |
| `CustomScrollView` | 여러 sliver를 하나의 viewport에서 어떻게 조합하는가? | `Viewport`, sliver list, scroll controller, physics | sliver order, scroll position, physics preset | `ListView` 다음 단계의 scroll mental model |
| `SliverList` | sliver 기반 lazy linear list는 어떻게 동작하는가? | `SliverList`, delegate, viewport, child creation | item count, lazy window, keepAlive hints | `ListView`와 sliver의 연결 고리 |
| `SliverAppBar` | app bar가 scroll과 결합될 때 어떤 상태가 생기는가? | pinned, floating, snap, flexible space | pinned/floating/snap, expandedHeight, collapse progress | scrolling + material shell의 고급 사례 |
| `CustomPaint` | layout과 paint는 왜 분리되어야 하는가? | `CustomPaint`, `CustomPainter`, repaint, semantics fallback | painter mode, repaint signal, hit test note, semantics label | render/painter mental model의 직접 체험 |

### 27.7.3 Satellite / Compare Lessons

- `GridView`
- `SliverGrid`
- `NestedScrollView`
- `CustomMultiChildLayout`
- compare: `ListView` vs `CustomScrollView + SliverList`
- compare: `Container` decoration vs `CustomPaint`

### 27.7.4 Capstone Lab

**Capstone: “슬리버 기반 지식 탐색기”**

예시 시나리오:

- 상단 확장/축소 header (`SliverAppBar`)
- long-form concept feed (`SliverList`)
- phase progress나 scroll depth를 표현하는 custom indicator (`CustomPaint`)
- breakpoint에 따라 보조 패널 on/off (`LayoutBuilder`)
- 전체 화면은 `CustomScrollView`로 조합

이 capstone의 목적은 사용자가 “scroll view를 단지 리스트라고 이해하는 수준”을 넘어, viewport/sliver/paint를 별개 시스템으로 설명하게 만드는 것이다.

### 27.7.5 Phase 4 완료 기준

사용자는 Phase 4를 마친 뒤 아래를 설명할 수 있어야 한다.

1. `ListView`와 `CustomScrollView`의 개념적 차이
2. sliver composition이 왜 필요한지
3. constraints에 따라 subtree를 분기하는 원리
4. layout과 paint의 책임 분리
5. 고급 scrolling UI가 실제로 어떤 조각들의 결합인지

---

## 27.8 Phase 5. Framework Internals & App Infrastructure Track

### 27.8.1 Phase 정체성

Phase 5는 Flutter UI를 “화면에 보이는 위젯”의 집합이 아니라, **트리 전체에 걸친 조정 메커니즘**으로 이해하게 만드는 구간이다. 여기서부터 핵심은 다음이다.

- dependency propagation
- notification bubbling
- focus tree
- overlay layer
- navigation stack

`InheritedWidget`은 tree 아래로 정보를 효율적으로 전달하는 방식의 기본형이고, `NotificationListener`는 descendant에서 올라오는 notification을 잡는다. `Focus`는 keyboard focus 관리의 기본 단위이며, `Overlay`는 floating visual element를 관리한다. `Navigator`는 route stack을 관리하는 핵심 infrastructure widget이다.[P50][P51][P52][P53][P54]

### 27.8.2 Core 5 Widgets

| 위젯 | 핵심 학습 질문 | Anatomy 핵심 노드 | Playground / Lab 핵심 컨트롤 | 선정 이유 |
|---|---|---|---|---|
| `InheritedWidget` | 트리 아래로 데이터를 효율적으로 전달하는 기본 구조는 무엇인가? | `InheritedWidget`, `dependOnInheritedWidgetOfExactType`, rebuild scope | provider value changes, dependent count, rebuild graph | framework-level dependency 전달의 기초 |
| `NotificationListener` | descendant에서 올라오는 이벤트는 어떻게 bubble되는가? | `Notification`, bubbling, listener boundary, stop propagation | scroll/tap/custom notification scripts, stopPropagation | callback 외의 tree-wide communication 학습 |
| `Focus` | keyboard focus는 별도의 트리로 어떻게 관리되는가? | `Focus`, `FocusNode`, focus traversal, keyboard events | focus order, request/unfocus, key events | desktop/web 접근성·입력 모델 이해에 필수 |
| `Overlay` | 떠 있는 요소는 왜 일반 layout flow 밖에서 관리되는가? | `Overlay`, `OverlayEntry`, insertion/removal, z-order | entry insert/remove, anchor preset, barrier | tooltip/menu/dialog mental model의 핵심 |
| `Navigator` | 화면 전환은 route stack과 overlay를 통해 어떻게 설명되는가? | `Navigator`, `Route`, push/pop, stack, transition note | push/pop/replace, nested stack preset, back behavior | app infrastructure를 이해하는 핵심 capstone lesson |

### 27.8.3 Satellite / Compare Lessons

- `Router` (개념 note 또는 advanced lesson)
- `Shortcuts`
- `Actions`
- `FocusTraversalGroup`
- `InheritedNotifier`
- compare: `InheritedWidget` vs prop drilling
- compare: `NotificationListener` vs direct callbacks
- compare: `Navigator` vs Router/go_router conceptual note

### 27.8.4 Capstone Lab

**Capstone: “미니 앱 셸 내부구조 보기”**

예시 시나리오:

- app-wide inherited config
- keyboard focus 이동 가능한 메뉴
- tooltip / context menu overlay
- notification bubble log
- route stack viewer가 있는 mini navigation shell

이 capstone의 목표는 학습자가 “앱이 화면 하나를 그리는 것”을 넘어서, **트리 전반의 상태 전달과 조정 시스템**을 설명하게 만드는 것이다.

### 27.8.5 Phase 5 완료 기준

사용자는 Phase 5를 마친 뒤 아래를 설명할 수 있어야 한다.

1. `InheritedWidget`이 왜 framework 전반에서 중요한 기초 패턴인지
2. notification bubbling이 언제 direct callback보다 적합한지
3. focus tree가 semantics 및 keyboard UX와 어떻게 연결되는지
4. overlay가 일반 layout flow와 다른 이유
5. `Navigator`가 route stack과 화면 전환의 기반이 되는 방식

---

## 27.9 Phase별 공식 출시 게이트

| Phase | core lesson 수 | satellite / compare 최소 기준 | capstone | 제품/콘텐츠 게이트 |
|---|---:|---:|---:|---|
| 1 | 5 | 2 | 1 | Foundation Track 완성, search/progress/deep link 안정화 |
| 2 | 5 | 3 | 1 | Material interaction lab, theme sandbox, input/focus 설명, button family satellite 공개 |
| 3 | 5 | 2 | 1 | async scenario runner, validation flow, builder timeline, rebuild heatmap 도입 |
| 4 | 5 | 2 | 1 | viewport/sliver visualizer, scroll metrics HUD, custom paint semantics 설명 도입 |
| 5 | 5 | 2 | 1 | dependency graph explorer, notification tracer, focus tree, overlay/nav stack lab 도입 |

추가 공통 게이트:

- 모든 phase는 phase landing page를 가진다.
- 모든 phase는 readiness check와 capstone unlock rule을 가진다.
- 모든 phase는 최소 2개의 이전 phase lesson과 명시적으로 연결된다.
- 모든 phase는 “왜 이 phase가 이전보다 어려운가”를 첫 화면에서 설명해야 한다.

---

## 27.10 `ElevatedButton` 및 Button Family의 최종 재배치 규칙

v1.3에서 `ElevatedButton`은 “Phase 2로 이동” 정도로만 재정의되었다. v1.4에서는 이를 더 구체화한다.

### 27.10.1 공식 위치

- `ElevatedButton`은 **Phase 2 core 5**의 정식 lesson이다.
- `FilledButton`, `OutlinedButton`, `TextButton`, `ButtonStyleButton`은 **Phase 2 satellite lesson**이다.

### 27.10.2 이유

- `ElevatedButton` 하나만 보아도 state-aware style, theme override, M2/M3, semantics를 함께 설명해야 하므로, Phase 1보다 한 단계 높은 “composed material interaction”에 더 적합하다.[P39]
- 반면 `ButtonStyleButton` 같은 추상 기반 클래스는 일반 학습자에게 바로 core lesson으로 제시하기보다, `ElevatedButton` 이해를 깊게 만들기 위한 satellite로 배치하는 편이 더 자연스럽다.

### 27.10.3 운영 이점

이 재배치는 기존 설계 자산을 버리지 않으면서도, 제품 전체 커리큘럼을 더 균형 있게 만든다. 즉, `ElevatedButton`은 다시 중요해지지만 “Phase 전체를 대표하는 유일한 시작점”은 아니게 된다.

---

## 27.11 Phase 5 이후 확장 방향

Phase 1~5가 첫 번째 완성형 커리큘럼이라면, 그 이후는 “정식 Phase 6을 바로 고정”하기보다 **확장 방향(expansion directions)** 으로 관리하는 편이 맞다. 아래는 우선순위가 높은 확장 후보들이다.

### 27.11.1 콘텐츠 확장 방향 A — Animation & Motion Track

후보 위젯/주제:

- `AnimatedContainer`
- `AnimatedSwitcher`
- `TweenAnimationBuilder`
- `Hero`
- `AnimatedList`

확장 이유:

- 현재 Phase 3의 `AnimatedBuilder`는 “listenable 기반 rebuild”에 가깝다.
- 이후에는 실제 motion design, transition mental model, implicit/explicit animation 차이를 별도 트랙으로 다룰 수 있다.

### 27.11.2 콘텐츠 확장 방향 B — Rendering Internals & Custom Layout Track

후보 위젯/주제:

- `CustomSingleChildLayout`
- `CustomMultiChildLayout`
- `LeafRenderObjectWidget`
- `SingleChildRenderObjectWidget`
- `SliverPersistentHeader`

확장 이유:

- Phase 4의 `CustomPaint`가 paint로 들어가는 관문이라면,
- 그 이후에는 layout delegate, custom render object, sliver internals를 별도 고급 트랙으로 분리할 수 있다.

### 27.11.3 콘텐츠 확장 방향 C — Adaptive / Desktop / Web Input Track

후보 위젯/주제:

- `MouseRegion`
- `Shortcuts`
- `Actions`
- `Draggable`
- `ScrollConfiguration`

확장 이유:

- Phase 5에서 `Focus`를 다루면 keyboard UX까지 열린다.
- 그 다음에는 desktop/web interaction model, pointer와 keyboard, drag/drop, shortcut system을 독립 트랙으로 확장할 수 있다.

### 27.11.4 콘텐츠 확장 방향 D — Package Anatomy Track

후보 대상:

- `go_router`
- Riverpod
- Firebase UI
- animations package
- community package design case studies

확장 이유:

- 현재 제품의 정체성은 core Flutter widget anatomy다.
- 그러나 커리큘럼이 안정되면 “Flutter ecosystem anatomy”로 확장해 실제 실무 패키지를 같은 방식으로 해부할 수 있다.

### 27.11.5 제품 확장 방향 E — Team / Cohort / Authoring

후보 기능:

- cohort별 진도 대시보드
- 팀 과제 / lesson assignment
- 검수 승인 흐름이 있는 authoring console
- 버전별 source drift 경고
- lesson 품질 리포트

확장 이유:

- 현재 문서는 학습자 중심이다.
- 이후에는 교육 담당자, 팀 리드, 콘텐츠 제작자까지 사용자군을 넓힐 수 있다.

### 27.11.6 제품 확장 방향 F — 플랫폼 확장

후보 방향:

- Flutter mobile shell
- downloadable offline lesson packs
- 다국어 콘텐츠 번역
- large-screen optimized layout
- 학습 이력 cross-device sync 강화

확장 이유:

- 현재는 Flutter Web 우선이 맞다.
- 하지만 Phase 1~5가 검증되면 모바일/태블릿/오프라인/국제화 요구가 자연스럽게 뒤따를 가능성이 높다.

---

## 27.12 업데이트된 전체 로드맵

### Phase 0. 설계 기반 구축
- IA / schema / authoring template / capability taxonomy 설계

### Phase 1. Foundation Track
- `Text`
- `Container`
- `Row`
- `GestureDetector`
- `ListView`

### Phase 2. Composition & Material Interaction Track
- `Stack`
- `Scaffold`
- `InkWell`
- `TextField`
- `ElevatedButton`
- satellite: Button Family pack

### Phase 3. Reactive State, Form & Async Track
- `Form`
- `ValueListenableBuilder`
- `FutureBuilder`
- `StreamBuilder`
- `AnimatedBuilder`

### Phase 4. Advanced Layout, Scroll & Paint Track
- `LayoutBuilder`
- `CustomScrollView`
- `SliverList`
- `SliverAppBar`
- `CustomPaint`

### Phase 5. Framework Internals & App Infrastructure Track
- `InheritedWidget`
- `NotificationListener`
- `Focus`
- `Overlay`
- `Navigator`

### 이후 확장 방향
- Animation & Motion
- Rendering Internals & Custom Layout
- Adaptive / Desktop / Web Input
- Package Anatomy
- Team / Cohort / Authoring
- 플랫폼 확장

이로써 Flutter Anatomy Lab의 로드맵은 더 이상 “몇 개의 위젯 lesson을 더 만들지”가 아니라, **Flutter를 이해하는 5단계 구조 사다리**가 된다.

---

## 추가 참고 자료

[P35]: https://api.flutter.dev/flutter/widgets/Stack-class.html "Stack class"
[P36]: https://api.flutter.dev/flutter/material/Scaffold-class.html "Scaffold class"
[P37]: https://api.flutter.dev/flutter/material/InkWell-class.html "InkWell class"
[P38]: https://api.flutter.dev/flutter/material/TextField-class.html "TextField class"
[P39]: https://api.flutter.dev/flutter/material/ElevatedButton-class.html "ElevatedButton class"
[P40]: https://api.flutter.dev/flutter/widgets/Form-class.html "Form class"
[P41]: https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html "ValueListenableBuilder class"
[P42]: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html "FutureBuilder class"
[P43]: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html "StreamBuilder class"
[P44]: https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html "AnimatedBuilder class"
[P45]: https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html "LayoutBuilder class"
[P46]: https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html "CustomScrollView class"
[P47]: https://api.flutter.dev/flutter/widgets/SliverList-class.html "SliverList class"
[P48]: https://api.flutter.dev/flutter/material/SliverAppBar-class.html "SliverAppBar class"
[P49]: https://api.flutter.dev/flutter/widgets/CustomPaint-class.html "CustomPaint class"
[P50]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html "InheritedWidget class"
[P51]: https://api.flutter.dev/flutter/widgets/NotificationListener-class.html "NotificationListener class"
[P52]: https://api.flutter.dev/flutter/widgets/Focus-class.html "Focus class"
[P53]: https://api.flutter.dev/flutter/widgets/Overlay-class.html "Overlay class"
[P54]: https://api.flutter.dev/flutter/widgets/Navigator-class.html "Navigator class"

# PRD v1.5 실행 설계 확장본 (Append-only: Curriculum Packaging + Deliverable Blueprint)

- append 작성일: 2026-03-10
- 원칙: **위의 v1.1 ~ v1.4 원문은 수정하지 않고 그대로 유지하며, 아래 내용은 Phase 1~5 커리큘럼을 실제 구현 가능한 제품 패키지 단위로 구체화하는 실행 설계 확장본이다.**
- 우선순위 규칙: **Phase별 산출물 묶음, 콘텐츠 패키징 단위, 학습자 진행 규칙, 출시 준비물, 이후 확장 방향과 관련해 기존 문장과 아래 내용이 충돌하면 v1.5 실행 설계 확장본이 우선한다.**

---

## 28. 왜 v1.5가 필요한가

v1.4까지의 문서는 Flutter Anatomy Lab을 “Phase 1~5로 상승하는 구조 학습 플랫폼”으로 정의하는 데 성공했다. 이제 부족한 것은 철학이나 로드맵이 아니라, **실제 제품 패키지로서 무엇을 몇 개 만들어야 하고, 그 묶음을 어떤 기준으로 출시하며, Phase가 끝날 때마다 어떤 단위로 운영/측정/확장할 것인가**를 더 명확히 하는 일이다.

즉 v1.5의 목적은 다음 세 가지다.

1. **Phase를 roadmap가 아니라 출시 가능한 학습 패키지로 재정의한다.**
2. **각 Phase에 필요한 산출물을 lesson 단위가 아닌 묶음 단위로 정의한다.**
3. **Phase 5 이후 확장을 “다음에 더 만들자”가 아니라, 어떤 제품 라인으로 커질지까지 연결한다.**

---

## 29. 공식 제품 패키징 단위 재정의

이제부터 Flutter Anatomy Lab의 커리큘럼은 “lesson의 집합”이 아니라 다음 계층을 가진다.

### 29.1 제품 계층

1. **Phase**
   - 난이도가 한 단계 상승하는 가장 큰 커리큘럼 단위
2. **Track**
   - 하나의 학습 관점을 묶는 중간 단위
   - 예: Foundation / Composition / Async / Sliver / Infrastructure
3. **Lesson**
   - 특정 widget 또는 framework concept를 해부하는 단위
4. **Lab**
   - lesson 간 비교/실험/응용 문제를 해결하는 단위
5. **Assessment Pack**
   - Phase 종료 시 구조 이해를 검증하는 체크포인트 묶음

### 29.2 Phase 패키지의 최소 구성

이제부터 어떤 Phase든 “출시 가능”하다고 부르려면 최소 아래 묶음을 가져야 한다.

1. **Phase Landing Page** 1개
2. **Core Lesson** 5개
3. **Satellite Lesson** 최소 2개
4. **Compare Lab** 최소 1개
5. **Capstone Lab** 최소 1개
6. **Assessment Pack** 최소 1개
7. **Glossary Pack** 1개
8. **Cross-link Map** 1개

이 원칙을 적용하면, Phase는 단순히 위젯 다섯 개를 추가하는 일이 아니라 **입구-핵심-보강-비교-종합-평가까지 완성된 하나의 제품 팩**이 된다.

---

## 30. Phase 1~5 공식 패키지 인벤토리

### 30.1 한눈에 보는 인벤토리

| Phase | 정식 트랙명 | Core 5 | Satellite 최소 수 | Compare Lab | Capstone Lab | Assessment Pack | 학습 난이도 상승 포인트 |
|---|---|---:|---:|---:|---:|---:|---|
| 1 | Foundation Track | 5 | 3 | 1 | 1 | 1 | box / layout / text / input / scroll의 기본 mental model 형성 |
| 2 | Composition & Material Interaction | 5 | 4 | 1 | 1 | 1 | 조합형 위젯, 상태 기반 style, Material shell 이해 |
| 3 | Reactive State, Form & Async | 5 | 4 | 1 | 1 | 1 | 값 바인딩, 검증, async snapshot, rebuild reasoning |
| 4 | Advanced Layout, Scroll & Paint | 5 | 4 | 1 | 1 | 1 | viewport / sliver / constraints / paint separation |
| 5 | Framework Internals & App Infrastructure | 5 | 4 | 1 | 1 | 1 | dependency propagation, focus, overlay, navigation, bubbling |

### 30.2 예상 전체 콘텐츠 규모

Phase 1~5를 첫 번째 완성형 커리큘럼으로 볼 때, 권장 최소 콘텐츠 규모는 아래와 같다.

- Phase Landing Page: 5
- Core Lesson: 25
- Satellite Lesson: 최소 19
- Compare Lab: 5
- Capstone Lab: 5
- Assessment Pack: 5
- Glossary Pack: 5
- Cross-phase Bridge Lesson: 최소 4

즉, v1.5 기준 첫 번째 완성형 제품은 **최소 68개 수준의 콘텐츠 자산**을 가진다. 여기서 자산은 단순 문서 수가 아니라, 사용자에게 실제 가치로 노출되는 학습 단위 전체를 뜻한다.

---

## 31. Phase별 상세 패키지 설계

## 31.1 Phase 1. Foundation Track

### Core 5
- `Text`
- `Container`
- `Row`
- `GestureDetector`
- `ListView`

### 추천 Satellite Lesson
- `Padding`
- `Column`
- `Expanded`
- `SingleChildScrollView`

### Compare Lab
- **Row vs Column vs Wrap 사고 실험**
  - 같은 children 수, 같은 constraints, 다른 배치 규칙

### Capstone Lab
- **Simple Feed Card Anatomy Lab**
  - `Container + Row + Text + GestureDetector + ListView`를 조합해 작은 피드 UI를 만들고, 각 구조가 어떤 역할을 하는지 되짚는다.

### Assessment Pack의 핵심 질문
- 텍스트는 왜 `Text`와 style/theme로 분리되는가?
- box decoration과 layout은 왜 한 widget에서 함께 보일 수 있지만 mental model상 분리해야 하는가?
- flex layout은 constraints와 남는 공간 분배를 어떻게 다루는가?
- gesture는 visual 자체가 아니라 interaction recognition에 가깝다는 점을 설명할 수 있는가?
- scroll container가 viewport와 child list를 어떻게 생각하게 만드는가?

### Phase 1 종료 시 사용자 상태
- Flutter UI를 “눈에 보이는 화면”이 아니라 **text / box / flex / gesture / viewport**의 합성으로 설명할 수 있어야 한다.

---

## 31.2 Phase 2. Composition & Material Interaction Track

### Core 5
- `Stack`
- `Scaffold`
- `InkWell`
- `TextField`
- `ElevatedButton`

### 추천 Satellite Lesson
- `TextButton`
- `OutlinedButton`
- `FilledButton`
- `AppBar`
- `SnackBar`

### Compare Lab
- **GestureDetector vs InkWell 비교 실험**
  - input recognition과 Material reaction의 차이
  - semantics, ripple, clipping, hit testing 체감

### Capstone Lab
- **Feedback Form Screen Anatomy Lab**
  - `Scaffold + AppBar + TextField + ElevatedButton + SnackBar`로 실제 화면을 구성하고, Material shell / focus / validation / feedback 관계를 설명한다.

### Assessment Pack의 핵심 질문
- Scaffold가 왜 앱 화면 골격의 시작점이 되는가?
- InkWell과 GestureDetector의 차이를 interaction contract 관점에서 설명할 수 있는가?
- TextField가 controller / focus / decoration / semantics를 왜 동시에 끌어오는가?
- ElevatedButton의 style resolution은 왜 theme / default / widget override로 분리되는가?

### Phase 2 종료 시 사용자 상태
- 단일 위젯 해부를 넘어, **실제 앱 화면을 이루는 Material composition**을 구조적으로 설명할 수 있어야 한다.

---

## 31.3 Phase 3. Reactive State, Form & Async Track

### Core 5
- `Form`
- `ValueListenableBuilder`
- `FutureBuilder`
- `StreamBuilder`
- `AnimatedBuilder`

### 추천 Satellite Lesson
- `TextFormField`
- `ListenableBuilder`
- `ValueNotifier`
- `AnimationController`

### Compare Lab
- **FutureBuilder vs StreamBuilder vs ValueListenableBuilder**
  - snapshot의 의미
  - rebuild 조건
  - state ownership 위치

### Capstone Lab
- **Signup / Loading / Result Flow Lab**
  - 입력 → 검증 → 로딩 → 성공/실패 상태를 한 번에 설명하게 만드는 종합 실험

### Assessment Pack의 핵심 질문
- reactive binding이 imperative update와 어떻게 다른가?
- Future와 Stream은 UI의 어떤 다른 시간 축을 반영하는가?
- builder 기반 위젯은 왜 데이터를 만드는 곳보다 데이터를 반영하는 곳으로 설계되어야 하는가?
- animation builder는 rebuild cost와 시각 변화의 타협을 어떻게 드러내는가?

### Phase 3 종료 시 사용자 상태
- 사용자는 “위젯이 다시 그려진다”를 막연히 말하는 대신, **어떤 입력원이 어떤 builder를 통해 어떤 순간에 UI를 바꾸는가**를 설명할 수 있어야 한다.

---

## 31.4 Phase 4. Advanced Layout, Scroll & Paint Track

### Core 5
- `LayoutBuilder`
- `CustomScrollView`
- `SliverList`
- `SliverAppBar`
- `CustomPaint`

### 추천 Satellite Lesson
- `SliverGrid`
- `SliverToBoxAdapter`
- `RepaintBoundary`
- `DecoratedBox`

### Compare Lab
- **ListView vs CustomScrollView 비교 실험**
  - 일반적인 scrolling abstraction과 sliver 조합형 scrolling의 차이

### Capstone Lab
- **Scrollable Dashboard Anatomy Lab**
  - pinned header, mixed sliver sections, custom paint indicator를 섞어 viewport·paint·layout의 관계를 추적한다.

### Assessment Pack의 핵심 질문
- LayoutBuilder는 constraints를 어떤 시점에 읽는가?
- 왜 sliver는 일반 box child와 mental model이 다른가?
- CustomPaint는 widget tree 안에서 paint 책임을 어떻게 끌어오는가?
- scroll과 paint 최적화는 어떤 기준에서 생각해야 하는가?

### Phase 4 종료 시 사용자 상태
- 사용자는 “복잡한 스크롤 화면”을 더 이상 black box로 보지 않고, **viewport / sliver / paint / constraints**의 조합으로 설명할 수 있어야 한다.

---

## 31.5 Phase 5. Framework Internals & App Infrastructure Track

### Core 5
- `InheritedWidget`
- `NotificationListener`
- `Focus`
- `Overlay`
- `Navigator`

### 추천 Satellite Lesson
- `InheritedNotifier`
- `FocusScope`
- `OverlayEntry`
- `ModalRoute`
- `Hero`

### Compare Lab
- **InheritedWidget vs NotificationListener vs Provider/Riverpod mental model bridge**
  - dependency propagation, event bubbling, external state container의 차이

### Capstone Lab
- **Mini App Shell Anatomy Lab**
  - overlay tooltip, focus traversal, in-app navigation, shared dependency 전달을 포함한 작은 앱 셸을 해부한다.

### Assessment Pack의 핵심 질문
- dependency lookup은 왜 subtree 방향으로 전파되는가?
- notification bubbling은 왜 dependency injection과 다르게 생각해야 하는가?
- focus tree는 왜 일반 widget hierarchy와 완전히 같지 않은가?
- overlay와 navigator는 화면 위에 띄우는 것 이상으로 어떤 구조 책임을 가지는가?

### Phase 5 종료 시 사용자 상태
- 사용자는 Flutter를 단순 widget catalog가 아니라, **dependency / event / focus / overlay / route orchestration**을 가진 UI framework로 설명할 수 있어야 한다.

---

## 32. Phase 공통 산출물 계약

각 Phase는 아래 문서를 반드시 포함해야 한다.

### 32.1 Phase Landing 문서

필수 포함 항목:
- 이 Phase가 필요한 이유
- 이전 Phase와의 연결점
- Core 5 개요
- Satellite Lesson 역할
- Compare Lab / Capstone 소개
- 추천 학습 순서
- 완료 기준

### 32.2 Lesson Manifest

필수 포함 항목:
- lesson id / title / phase / difficulty
- primary widget or concept
- prerequisite lesson ids
- learning outcomes
- anatomy nodes
- playground capabilities
- source refs
- reviewed version info

### 32.3 Lab Brief

필수 포함 항목:
- 학습 목표
- 비교 또는 응용 대상
- 관찰해야 할 구조 포인트
- 성공 조건
- reflection 질문

### 32.4 Assessment Pack

필수 포함 항목:
- 개념 연결형 문제
- 우선순위/원인 추적 문제
- 오해 유도형 문제
- phase bridge 문제

### 32.5 Glossary Pack

필수 포함 항목:
- phase 내 핵심 용어 정의
- lesson 간 동일 용어의 다른 맥락
- 잘 헷갈리는 용어 묶음

### 32.6 Cross-link Map

필수 포함 항목:
- 같은 phase 내부 연결
- 이전/다음 phase 연결
- bridge lesson 후보
- prerequisite가 아닌 추천 연쇄 링크

---

## 33. 학습자 진행 규칙과 잠금 해제 정책

### 33.1 기본 원칙

Flutter Anatomy Lab은 MOOC처럼 모든 콘텐츠를 한 번에 풀어놓기보다, **이해 가능한 난이도 곡선**을 유지하는 구조를 우선한다.

### 33.2 권장 정책

1. 각 Phase의 Landing Page는 항상 공개
2. Core Lesson 1개는 맛보기로 공개 가능
3. 나머지 Core Lesson은 선행 lesson 완료 또는 최소 체크포인트 통과 후 권장 해제
4. Compare Lab은 해당 Phase의 Core Lesson 3개 이상 완료 시 노출
5. Capstone Lab은 Core 5 완료 후 노출
6. 다음 Phase Landing은 이전 Phase Capstone 완료 시 적극 추천

### 33.3 학습 흐름 설계 이유

이 정책은 사용자를 가두기 위해서가 아니라, 구조 학습의 핵심인 **개념 연결성**을 보장하기 위한 것이다. 예를 들어 `CustomScrollView`를 `ListView` 이전에 보여주는 것은 가능하지만, 제품 경험상 이해 밀도가 급격히 떨어질 가능성이 높다.

---

## 34. 출시 게이트 재정의

v1.5부터는 lesson 몇 개가 준비되었는가보다 **Phase 패키지가 완결성을 갖추었는가**를 출시 기준으로 본다.

### 34.1 Soft Launch 게이트

- Phase Landing 완료
- Core Lesson 5개 중 5개 완료
- Satellite 최소 2개 완료
- Compare Lab 1개 완료
- Assessment Pack 1개 완료
- 기본 검색/진도/북마크/깊은 링크 작동

### 34.2 Public Beta 게이트

- Capstone Lab 완료
- Satellite 최소 권장 수 충족
- Glossary Pack 완료
- Cross-link Map 완료
- accessibility self-check 완료
- 모바일/태블릿 반응형 검토 완료

### 34.3 Stable Phase 게이트

- 학습 지표 안정화
- 대표 FAQ 반영
- source drift 검토 완료
- lesson 간 broken link 0건
- 주요 브라우저 smoke test 통과

---

## 35. 제품 지표 재정의

기존의 lesson completion만으로는 더 이상 제품 성공을 설명할 수 없다. v1.5부터는 아래 지표를 Phase 단위로 본다.

### 35.1 핵심 지표

- Phase Landing → Core Lesson 1 진입률
- Core 5 완료율
- Compare Lab 진입률
- Capstone 완료율
- Assessment 정답률
- 다음 Phase 이동률
- glossary / search / source lens 재방문률

### 35.2 건강성 지표

- lesson 간 평균 이동 수
- deep link 진입 후 이탈률
- 구조 설명형 퀴즈 정답률
- repeated attempt 후 개선률
- 모바일/데스크톱 completion gap

### 35.3 해석 원칙

- completion 자체보다 **phase transition quality**를 본다.
- 퀴즈 점수 자체보다 **오해가 어디서 반복되는가**를 본다.
- 단일 위젯 인기보다 **core lesson과 capstone의 연결성**을 더 중요하게 본다.

---

## 36. 운영 관점에서의 콘텐츠 제작 순서

v1.5부터는 위젯을 떠오르는 순서대로 만드는 것이 아니라, 아래 패턴으로 생산한다.

### 36.1 권장 제작 묶음

1. Phase Landing 초안
2. Core 5 중 가장 쉬운 2개 lesson
3. 나머지 Core 3개
4. Compare Lab
5. Satellite Lesson
6. Assessment Pack
7. Capstone Lab
8. Glossary / Cross-link 정리

### 36.2 이유

- 처음부터 capstone을 만들면 phase 정체성이 흔들릴 수 있다.
- 반대로 core lesson만 만들고 lab/assessment를 늦추면, 결국 설명 없는 카탈로그가 될 위험이 있다.
- 따라서 각 Phase는 **핵심 lesson과 종합 장치가 균형 있게 자라야 한다.**

---

## 37. 이후 확장 방향의 공식 제품 라인화

v1.4에서 제안한 이후 확장 방향을 이제 제품 라인 기준으로 재정의한다.

### 37.1 Expansion Line A. Motion & Animation Anatomy

대상:
- implicit / explicit animation
- `AnimatedContainer`, `TweenAnimationBuilder`, `AnimationController`, `Hero`

목적:
- 움직임이 있는 UI를 구조적으로 설명하는 별도 라인 구축

### 37.2 Expansion Line B. Rendering Internals Lab

대상:
- `RenderObjectWidget`
- `SingleChildRenderObjectWidget`
- custom layout / paint internals

목적:
- Core curriculum과 분리된 고난도 실험실 운영

### 37.3 Expansion Line C. Adaptive & Multi-Platform Anatomy

대상:
- responsive/adaptive layout
- keyboard/mouse/desktop/web input 차이
- platform idiom 비교

목적:
- 웹 우선 제품에서 플랫폼 확장형 학습 라인으로 성장

### 37.4 Expansion Line D. Package Anatomy

대상:
- `go_router`, `riverpod`, `intl`, `firebase_*` 등 대표 패키지

목적:
- Flutter core widget에서 실전 ecosystem anatomy로 확장

### 37.5 Expansion Line E. Instructor / Cohort / Team Product

대상:
- 팀 학습 운영 도구
- cohort assignment
- 진도 대시보드
- review workflow

목적:
- 개인 학습 제품에서 교육 운영 제품으로 확장

### 37.6 Expansion Line F. Enterprise / Onboarding Edition

대상:
- 사내 Flutter onboarding
- design system / component guideline education
- team-specific lesson pack

목적:
- B2B2C 또는 기업용 학습 솔루션 가능성 검증

---

## 38. 실제 구현 직전 산출물 체크리스트

이제부터 Flutter Anatomy Lab을 “개발 시작 가능” 상태로 보려면 아래 문서/자산이 존재해야 한다.

### 38.1 제품 문서
- 최신 PRD
- 최신 TDD
- release plan
- content production board
- glossary policy
- source review policy

### 38.2 콘텐츠 문서
- Phase manifest 5개
- Track manifest 5개
- Lesson manifest 25개 이상의 초안
- Compare/Capstone brief
- assessment bank

### 38.3 디자인/UX 문서
- IA map
- navigation flow
- phase landing wireframe
- lesson detail wireframe
- lab wireframe
- progress dashboard wireframe

### 38.4 운영 문서
- QA checklist
- browser support matrix
- accessibility review checklist
- source drift review cadence
- content naming convention

---

## 39. v1.5 이후의 최종 그림

v1.5 기준 Flutter Anatomy Lab은 더 이상 Flutter 위젯을 흥미롭게 설명하는 웹사이트가 아니다. 제품의 정체성은 아래처럼 정리된다.

> **Flutter Anatomy Lab은 Flutter를 단계별 구조 사다리로 학습하게 만드는 phase-based interactive curriculum platform이다.**

이 정의에서 중요한 것은 세 가지다.

1. **phase-based**: 난이도 곡선이 존재한다.
2. **interactive**: 읽기만 하는 문서가 아니다.
3. **curriculum platform**: lesson이 아니라 학습 체계 전체를 설계한다.

즉, 이제부터의 추가 개발은 위젯 하나 더 넣기가 아니라, **커리큘럼 밀도를 유지하면서 제품 라인을 확장하는 일**로 이해해야 한다.

---

# PRD v1.6 문서형 UI/비주얼 가이드 (Append-only: Official Docs Visual Direction)

- 문서 버전: v1.6
- 상태: Draft (Append-only Visual Direction)
- 작성일: 2026-03-10
- 원칙: **위의 v1.1 ~ v1.5 원문은 수정하지 않고 그대로 유지하며, 아래 내용은 Phase 1의 시각 톤, 문서형 IA, 와이어프레임, 디자인 언어를 명확히 한다.**
- 우선순위 규칙: **Phase 1의 화면 밀도, 정보 배치, 시각 톤, 컴포넌트 외형, wireframe 해석과 관련해 기존 문장과 아래 문장이 충돌하면 v1.6 시각 가이드가 우선한다.**

---

## 40. 공식문서형 UX 방향 정의

Flutter Anatomy Lab은 마케팅 랜딩 페이지처럼 보여서는 안 된다. Phase 1의 제품 경험은 **공식 문서, 레퍼런스 사이트, 기술 매뉴얼**에 가까운 신뢰감과 정돈감을 가져야 한다.

핵심 방향은 아래와 같다.

1. **Content-first**: 장식보다 본문, 구조, 표, 코드, 도식이 먼저 보여야 한다.
2. **Reference-grade clarity**: 사용자는 “예쁘다”보다 “빨리 찾힌다”, “구조가 읽힌다”를 먼저 느껴야 한다.
3. **Structural calm**: 강한 브랜드 장식, 과한 그림자, 대형 gradient hero보다 절제된 레이아웃과 선명한 위계를 우선한다.
4. **Inspectability**: 모든 시각 요소는 학습을 돕는 구조 설명 장치여야 한다.

### 40.1 비주얼 톤 키워드

- 밝고 조용한 화면
- 얇은 경계선과 명확한 간격
- 과장되지 않은 accent color
- 카드보다 문서 section 중심 구성
- 한 화면에 “읽기”, “탐색”, “실험”이 공존하되 서로 경쟁하지 않는 밀도

### 40.2 하지 말아야 할 시각 방향

- product marketing hero 중심 레이아웃
- 과도한 glassmorphism
- dark mode를 기본처럼 가정한 과포화 색 사용
- 배경 전체를 덮는 장식성 gradient
- 카드가 겹겹이 쌓인 dashboard 스타일
- 큰 일러스트가 본문보다 먼저 시선을 가져가는 구조

---

## 41. 공식문서형 레이아웃 원칙

### 41.1 기본 쉘

데스크톱 기준 lesson 상세는 아래 3열 구조를 기본으로 한다.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│ Top bar: logo | phases | widgets | search | settings                      │
├──────────────────┬──────────────────────────────────────┬──────────────────┤
│ Left nav         │ Main document column                 │ Context rail     │
│ track / sections │ overview / api / anatomy / source   │ outline / refs   │
│ lesson progress  │ playground / runtime / semantics    │ next / glossary  │
│ related lessons  │ quiz                                 │ status           │
└──────────────────┴──────────────────────────────────────┴──────────────────┘
```

의도는 명확하다.

- 좌측은 **현재 어디를 읽고 있는지**
- 중앙은 **무엇을 이해해야 하는지**
- 우측은 **지금 문맥에서 무엇을 다시 참조해야 하는지**

즉, 문서 읽기 흐름과 도구형 탐색 흐름을 한 화면에서 분리해 준다.

### 41.2 레이아웃 밀도

- 메인 본문은 “너무 넓지 않게” 유지한다.
- section 제목, 요약, 도표, 실험 패널은 수직 리듬이 일정해야 한다.
- 카드형 surface는 최소화하고, 문서 구획을 나누는 얇은 divider와 spacing을 우선 사용한다.
- Playground와 Anatomy는 “화려한 데모 박스”가 아니라 문서 본문 안의 실험 패널처럼 보여야 한다.

### 41.3 반응형 해석

```text
Desktop   : 좌측 nav + 본문 + 우측 context rail
Tablet    : 좌측 nav 유지, 우측 rail은 접히거나 본문 하단으로 이동
Mobile    : 단일 column, section nav는 상단 sticky summary 또는 bottom sheet 진입
```

모바일에서도 문서형 철학은 유지되어야 하므로, 작은 화면이라고 해서 카드형 홈피나 과장된 carousel 구조로 바뀌어서는 안 된다.

---

## 42. 시각 시스템 가이드

### 42.1 컬러 방향

색은 “브랜딩”보다 “가독성과 상태 구분”을 위해 사용한다.

| 역할 | 방향 | 설명 |
|---|---|---|
| Page background | warm-neutral 또는 cool-neutral의 아주 옅은 톤 | 종이 같은 안정감 |
| Primary surface | 거의 흰색에 가까운 단색 | 본문 집중 |
| Border / divider | 저채도 중립 회색 | section 구분 |
| Accent | 차분한 blue 계열 | link, active nav, key emphasis |
| Success / caution / danger | 채도 낮은 보조색 | 퀴즈 피드백, source drift, warning |

색 운용 규칙:

- accent는 항상 제한적으로 사용한다.
- hover, active, selected 상태는 채도보다 **명도 대비와 경계선**으로 보여준다.
- Anatomy graph에서 여러 색을 남발하지 않고, active path나 현재 노드만 accent로 드러낸다.

### 42.2 타이포그래피 방향

- 제목은 compact하고 명확해야 한다.
- 본문은 기술 문서처럼 안정적인 line height를 가진다.
- 코드, API 이름, route, JSON key는 일관된 mono 스타일을 사용한다.
- 한국어와 영문 API가 섞여도 어색하지 않은 문서용 서체 조합을 사용한다.

권장 위계:

- Page title
- Section title
- Subsection title
- Body
- Caption / metadata / chip
- Mono / code / schema key

### 42.3 표와 callout

공식문서 스타일을 만들기 위해 아래 패턴을 적극 사용한다.

- 비교 표
- 정의 표
- 요약 bullet
- Info / Note / Caution callout
- “Why this matters” 블록
- source link와 review metadata가 붙은 compact reference card

이 구조는 많은 설명을 카드로 부풀리기보다, 작은 정보 단위를 빠르게 스캔하게 한다.

---

## 43. 핵심 화면 와이어프레임

### 43.1 홈 / Track landing

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ Header                                                                   │
├──────────────────────────────────────────────────────────────────────────┤
│ Track intro                                                              │
│ "Understand Flutter as text / box / flex / gesture / viewport"          │
│ short summary + start track + continue                                   │
├──────────────────────────────┬───────────────────────────────────────────┤
│ Lesson progression rail      │ Track overview / outcomes / lesson list   │
│ 1 Text                       │ why this track exists                      │
│ 2 Container                  │ lesson cards kept compact and list-like    │
│ 3 Row                        │                                            │
│ 4 GestureDetector            │                                            │
│ 5 ListView                   │                                            │
└──────────────────────────────┴───────────────────────────────────────────┘
```

핵심은 hero 이미지를 크게 두는 것이 아니라, “이 트랙이 무엇을 가르치는가”와 “어디서 시작해야 하는가”를 빠르게 보여주는 것이다.

### 43.2 Lesson detail

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ Breadcrumb / widget id / track badge / last reviewed                     │
│ Title + one-line thesis                                                  │
├───────────────┬────────────────────────────────────────┬─────────────────┤
│ Section nav   │ Overview                               │ Outline         │
│               │ API Snapshot                           │ Source refs     │
│               │ Anatomy map                            │ Related lessons │
│               │ Playground                             │ Next section    │
│               │ Runtime                                │                 │
│               │ Semantics                              │                 │
│               │ Quiz                                   │                 │
└───────────────┴────────────────────────────────────────┴─────────────────┘
```

### 43.3 Playground block

```text
┌──────────────────────────────────────────────────────────────────────┐
│ Playground                                                          │
├───────────────────────────────┬──────────────────────────────────────┤
│ Curated controls              │ Live preview                         │
│ - only lesson-specific knobs  │ deterministic shell                  │
│ - short helper text           │ state badge / size / semantics note  │
└───────────────────────────────┴──────────────────────────────────────┘
```

Playground는 “IDE”처럼 보여서는 안 된다. 문서 본문을 읽다가 바로 실험할 수 있는 **embedded lab**처럼 보여야 한다.

### 43.4 Anatomy map

```text
┌──────────────────────────────────────────────────────────────────────┐
│ Anatomy                                                             │
├───────────────────────────────┬──────────────────────────────────────┤
│ Graph / tree view             │ Selected node details               │
│ light canvas                  │ summary                             │
│ one active path emphasis      │ related section / source / links    │
└───────────────────────────────┴──────────────────────────────────────┘
```

---

## 44. 문서형 컴포넌트 원칙

### 44.1 권장 컴포넌트

- breadcrumb
- section anchor nav
- sticky outline rail
- lesson metadata row
- status chip
- callout box
- compact source reference card
- spec table
- anatomy graph frame
- playground frame
- runtime inspector frame

### 44.2 컴포넌트 외형 규칙

- radius는 과하지 않게 사용한다.
- 그림자는 아주 약하게 쓰거나 생략한다.
- 카드 배경색 차이보다 border와 spacing으로 구획을 만든다.
- 버튼보다 text link와 inline action을 더 자주 사용한다.
- section 전환은 탭보다 문서 스크롤을 우선으로 설계한다.

### 44.3 문서형 상호작용 규칙

- 현재 section은 좌측 nav와 우측 outline에서 동시에 강조된다.
- deep link가 들어오면 해당 section heading과 문맥이 즉시 드러나야 한다.
- code/source 참조는 modal보다 inline expansion 또는 adjacent panel을 우선한다.
- motion은 120~180ms 정도의 짧고 조용한 전환만 허용한다.

---

## 45. 접근성 및 읽기 경험

- line length는 장문 읽기에 무리가 없도록 제한한다.
- heading hierarchy는 screen reader와 시각 위계가 일치해야 한다.
- callout, chip, graph, preview는 색만으로 상태를 구분하지 않는다.
- keyboard만으로 left nav, main content, context rail, playground controls에 접근 가능해야 한다.
- graph형 UI가 있더라도 동일 정보를 계층형 텍스트 뷰로 대체 가능해야 한다.

이 제품은 “읽는 제품”이므로, 시각 디자인보다 **읽기 피로를 낮추는 설계**가 우선이다.

---

## 46. Phase 1 공식 비주얼 해석 문장

Phase 1의 공식 디자인 방향은 아래 한 문장으로 정리한다.

> **Flutter Anatomy Lab Phase 1은 학습용 대시보드가 아니라, 실험 가능한 공식문서형 레퍼런스 제품처럼 보여야 한다.**

이 정의는 이후 wireframe, component spec, app shell, theme token, responsive layout, landing page 구성의 기준으로 사용한다.
