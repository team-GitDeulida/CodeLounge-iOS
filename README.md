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
1. 마크다운 기반 Q&A 뷰어 📘
2. Block·Inline 문법을 직접 파싱해 렌더링 🧩
3. 질문/카테고리별 필터링 🔎

<br/><br/>

# 2. 기술 스택
|library|description|
|:---:|:---:|
|**SwiftUI**| 전체 UI 렌더링 및 레이아웃 |
|**Combine**| 문서 업데이트·데이터 흐름 관리 |
|**Fastlane**| 배포 자동화 |
|**Firebase**| 문서 관리·실시간 데이터 |
|**Custom Markdown Parser**| Block/Inline 문법 직접 파싱 |

</br><br/>

# 3. 핵심 성과
### **1. Markdown 문법을 직접 정의하고 커스텀 파서 구축**

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
[Node Tree] — MarkdownNode / InlineNode 트리 구조 생성
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

## 2. Top‑Down + 재귀 하강 기반 Block/Inline 파싱 구조 설계

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
- 🔸 Markdown의 **큰 구조 → 작은 구조** 흐름을 코드로 완전히 반영  
- 🔸 중첩 Bold/Underline도 정확하게 파싱  
- 🔸 Block·Inline이 분리되어 확장성 뛰어남  

---
