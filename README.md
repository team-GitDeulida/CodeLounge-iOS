<div align=center>

# CodeLounge
개발자 지식 아카이브 서비스  
CS / iOS / Android / 알고리즘 면접 질문을  
읽기 쉬운 Markdown UI로 제공하는 개발자 학습 플랫폼입니다.

</div>

<br/><br/>

<!--### MVVM + Clean Architecture-->
<!--<img width="907" alt="스크린샷 2025-01-05 오후 9 12 47" src="https://github.com/user-attachments/assets/d90366e0-7203-4f1c-be88-1d6c657ca518" />-->

# UI Prototype
<img src="https://github.com/user-attachments/assets/eb08099b-e2b1-4cf6-9d6a-376e73cc88b0" alt="Simulator Screen Recording - iPhone 15 Pro Max - 2024-07-12 at 20 07 43" style="width: 200px;"> | <img alt="스크린샷 2025-01-30 오전 12 23 24" src="https://github.com/user-attachments/assets/19a34174-ef06-4fb8-946a-0811d8be1392" style="width: 200px;"> | <img alt="스크린샷 2025-01-30 오전 12 23 40" src="https://github.com/user-attachments/assets/51a9434c-fce5-4e0e-bd6c-997946877298" style="width: 200px;"> | <img width="293" alt="스크린샷 2025-01-30 오전 12 38 14" src="https://github.com/user-attachments/assets/ca92078f-8615-45ac-a05c-1a446816aa4c" style="width: 200px;"/>
|:--------------:|:--------------:|:--------------:|:--------------:|
| **1. 온보딩 화면** | **2. 메인 화면** | **3. 상세 화면** | **4. 검색 기능** |

# 1. 기능 소개
1. CS / iOS / Android 카테고리별 개발 지식 Q&A 제공 📘
2. Block·Inline 문법을 직접 파싱해 SwiftUI로 Markdown 렌더링 🧩
3. 질문/카테고리별 검색 및 필터링 🔎
4. Google / Apple 로그인 기반 사용자 인증
5. 프로필 조회·수정, 닉네임 중복 확인, 생년월일·성별 관리
6. TurboNavigator 기반 Auth / Main 탭 / 상세 화면 라우팅

<br/><br/>

# 2. 기술 스택
|library|description|
|:---:|:---:|
|**SwiftUI**| 앱 전반의 UI 렌더링 및 화면 구성 |
|**UIKit**| UINavigationBar / UITabBar appearance 및 일부 시스템 UI 제어 |
|**Combine**| Firebase 데이터 흐름, 검색 debounce, 비동기 결과 처리 |
|**TurboNavigator**| 직접 제작한 Swift Package 기반 타입 세이프 라우팅, Navigation / Tab 컨테이너 구성 |
|**Firebase Auth**| Google / Apple 로그인 인증 처리 |
|**Firebase Realtime Database**| 사용자 정보 및 게시글 데이터 저장·조회 |
|**GoogleSignIn**| Google 로그인 연동 |
|**Google Mobile Ads**| 게시글 상세 화면 배너 광고 |
|**Swift Testing**| DTO 변환, Markdown Parser 등 유닛 테스트 |
|**Fastlane**| 앱 배포 자동화 |
|**Custom Markdown Parser**| Block / Inline 문법 직접 파싱 및 SwiftUI 렌더링 |

</br><br/>

# 3. 핵심 성과
### **1. TurboNavigator 기반 라우팅 구조 적용**

> **문제**  
> SwiftUI 기본 NavigationStack만으로 Auth Flow, Main Tab, 상세 화면, 프로필 수정 화면을 일관된 방식으로 관리하기 어려웠음.
>
> **해결**  
> 직접 제작한 **TurboNavigator** 라이브러리를 Swift Package로 적용하고,  
> Route enum과 RouteRegistry 기반으로 화면 생성을 중앙화.
>
> 현재 라우팅 구조
> - AuthRoute: Intro, Login, Register
> - MainRoute: CS, iOS, AOS, Profile, ProfileSettings, PostDetail
> - NavigationContainer: 인증 플로우
> - TabNavigationContainer: 메인 탭 플로우

```swift
enum MainRoute: Hashable {
    case cs
    case ios
    case aos
    case profile
    case profileSettings(RootViewModel)
    case postDetail(Post)
}
```

> **성과**  
> 🔸 화면 전환을 문자열이 아닌 타입 기반 route로 관리  
> 🔸 탭 화면과 push 상세 화면의 생성 로직을 AppRouter로 분리  
> 🔸 PreviewDependencies를 통해 SwiftUI Preview에서도 navigator 사용 가능  

---

### **2. Markdown 문법을 직접 정의하고 커스텀 파서 구축**

> **문제**  
> SwiftUI 기본 Markdown은 Bold/Underline 커스텀 문법 적용, Inline 중첩 구조 표현이 어려웠음.
>
> **해결**  
> Markdown 문법을 **EBNF**로 선언형으로 정의했고,  
> 이를 기반으로 **Top-Down + 재귀 하강 파서**를 직접 구현.  
>
> Block → Inline 2단계 파싱 구조
> - Block: Heading, ListItem, Paragraph
> - Inline: Bold, Underline, PlainText

```ebnf
Document    ::= Block { Block }
Block       ::= Heading | ListItem | Paragraph
Heading     ::= '#' TextLine
ListItem    ::= '- ' TextLine
Paragraph   ::= TextLine

Inline      ::= Bold | Underline | Text
Bold        ::= '**' Inline '**'
Underline   ::= '##' Inline '##'
```

```text
// 전체 파싱 흐름
Markdown 원본
   ↓
[Block Parser] — 줄 단위로 Heading, ListItem, Paragraph 분류
   ↓
[Inline Parser] — **굵게**, ##밑줄##, 텍스트 등 문장 구조 분석
   ↓
[Node Tree] — BlockNode / InlineNode 트리 구조 생성
   ↓
[Renderer] — SwiftUI View로 변환
   ↓
UI 출력
```

> **성과**  
> 🔸 Bold / Underline / 중첩 Inline 지원  
> 🔸 문서가 트리 형태로 유지되어 ForEach 순회로 SwiftUI 렌더링 성능 최적화  
> 🔸 문법 추가 시 확장성 높음  

---

## 3. Top‑Down + 재귀 하강 기반 Block/Inline 파싱 구조 설계

> **문제**  
> Heading, List, Paragraph, CodeBlock 같은 **Block 문법**과  
> Bold/Underline이 섞인 **Inline 문법**이 뒤엉켜  
> 파싱 구조가 복잡해질 위험이 있었음.
> 
> **해결**  
> - Block 단계는 **Top‑Down**  
> - Inline 단계는 **재귀 하강(Recursive‑Descent)**로 분리해 파싱 구조를 안정적으로 설계.

> 핵심 아이디어:  
> ➡️ **“한 줄(Block)을 먼저 결정 → 내부에서 Inline을 재귀로 해석”**

> ### Top‑Down Block 파싱
```swift
func parseBlock() -> MarkdownNode? {
    if let heading = parseHeading() { return heading }
    else if let code = parseCodeBlock() { return code }
    else if let list = parseListItem() { return list }
    else if let paragraph = parseParagraph() { return paragraph }
    return nil
}
```

> ### 재귀 하강 Inline 파싱
```swift
private func parseUntil(_ delimiter: String?) -> [InlineNode] {
    var result: [InlineNode] = []
    var buffer = ""

    while !isAtEnd() {
        if let d = delimiter, peek(d) {
            advance(d.count)
            if !buffer.isEmpty { result.append(.text(buffer)); buffer = "" }
            return result
        }

        if match("**") {
            if !buffer.isEmpty { result.append(.text(buffer)); buffer = "" }
            let inner = parseUntil("**")
            result.append(.bold(inner))

        } else if match("##") {
            if !buffer.isEmpty { result.append(.text(buffer)); buffer = "" }
            let inner = parseUntil("##")
            result.append(.underline(inner))

        } else {
            buffer.append(current())
            advance(1)
        }
    }

    if !buffer.isEmpty { result.append(.text(buffer)) }
    return result
}
```

> **성과**  
> - 🔸 Markdown의 **큰 구조 → 작은 구조** 흐름을 코드로 완전히 반영  
> - 🔸 중첩 Bold/Underline도 정확하게 파싱  
> - 🔸 Block·Inline이 분리되어 확장성 뛰어남  

---

## 4. 테스트 타깃 구성 및 핵심 로직 검증

> **문제**  
> DTO 변환, Markdown 파싱처럼 앱 동작의 기반이 되는 로직은 UI 없이 빠르게 검증할 수 있어야 함.
>
> **해결**  
> `CodeLoungeTests` 유닛 테스트 타깃을 추가하고 Swift Testing 기반 테스트 작성.
>
> 테스트 범위
> - User ↔ UserDTO 변환
> - PostDTO → Post 변환
> - 잘못된 날짜·enum 값에 대한 fallback 처리
> - MarkdownParser / InlineParser 파싱 결과

```swift
@Test("MarkdownParser가 제목 목록 문단 코드블록을 파싱한다")
func markdownParserParsesStructuredBlocks() {
    let nodes = MarkdownParser(markdown: markdown).parseDocument()

    #expect(nodes[0] == .heading(level: 1, text: "Title"))
}
```

> **성과**  
> 🔸 Firebase나 UI 실행 없이 순수 변환·파싱 로직을 빠르게 검증  
> 🔸 Markdown 파서 리팩토링 시 회귀 버그를 테스트로 방지  
