//
//  MarkdownParser.swift
//  CodeLounge
//
//  Created by 김동현 on 5/10/25.
//

/*
 
 [Top-down Tree]
 parseDocument()
 │
 ├── parseBlock()                 ← 한 줄을 해석하는 중심 함수
 │   ├── parseHeading()           ← #으로 시작하면 제목으로 인식 (Top-down)
 │   ├── parseCodeBlock()         ← ``` 으로 시작하면 코드 블록
 │   ├── parseListItem()          ← - 으로 시작하면 리스트 항목 (Inline 포함)
 │   └── parseParagraph()         ← 나머지는 문단 → parseInline() 호출 (Inline 재귀 하강)
 │
 └── advance()                    ← 다음 줄로 이동
 
 [EBNF 기호 정리]
 기호         의미                     예시                           설명
 ────────────┼────────────────────────┼──────────────────────────────┼──────────────────────────────────────────────
 ::=         ~로 정의됨               Heading ::= '#' Text           Heading은 '#'와 텍스트로 구성됨
 { }         0개 이상 반복            { Block }                      Block이 여러 개 나올 수 있음
 |           또는 (OR)                Block ::= Heading | ListItem   Block은 Heading이거나 ListItem 중 하나
 [ ]         옵션 (0개 또는 1개)      [Space]                        공백이 있어도 되고 없어도 됨
 ' '         문자 그대로              '#'                            '#' 문자 자체를 의미함
 Character   문법 구성 요소 이름       { Character }                  텍스트를 이루는 글자 하나하나를 의미
 
 
 
 [EBNF 문법]
  ※ Heading, ListItem 등 Block 구조는 Top-down 파싱
  ※ Bold 등 Inline 구조는 재귀 하강 파싱으로 처리
 
  Document        ::= Block { Block }             // 문서는 Block으로 구성
  Block           ::= Heading | ListItem | Paragraph
  Heading         ::= HeadingMarker Space TextLine
  HeadingMarker   ::= '#' { '#' }                 // 하나 이상 연속된 #
  ListItem        ::= '- ' TextLine
  Paragraph       ::= TextLine
  CodeBlock       ::= '```' [Language] LineBreak { TextLine } '```'
  LineBreak       ::= '\n'                        //  줄바꿈 블록
  TextLine        ::= { Inline } LineBreak        // 텍스트 줄은 인라인 조각들의 집합
  Inline          ::= Bold | Underline | Text
  Bold            ::= '**' Inline+ '**'           // 굵은 텍스트 (중첩 가능)
  Underline       ::= '##' Inline+ '##'
  Text            ::= { Character but not '**' }  // 일반 문자 (별표 제외)
  Space           ::= ' '
 */

import Foundation
import SwiftUI

// MARK: - 마크다운 문서의 한 줄을 의미하는 구조
enum MarkdownNode {
    case heading(level: Int, text: String)  // # 제목
    case listItem(text: [InlineNode])       // - 리스트 항목
    case paragraph(inlines: [InlineNode])   // 일반 문단 텍스트
    case code(language: String, content: String)
    case lineBreak
}

enum InlineNode {
    case text(String)                       // 일반 텍스트
    case bold([InlineNode])                 // **굵은** 텍스트(중첩 가능)
    case underline([InlineNode])            // ##밑줄##
}

// MARK: - 마크다운 텍스트를 Block 단위로 파싱하여 MarkdownNode 배열로 변환하는 파서
final class MarkdownParser {
    private var lines: [String]             // 줄 단위로 나눈 마크다운 텍스트
    private var currentIndex: Int = 0       // 현재 읽고 있는 줄 인덱스
    
    /// 마크다운 문자열을 줄 단위로 나눈배열로 초기화
    init(markdown: String) {
        self.lines = markdown.components(separatedBy: .newlines)
    }
    
    /// 현재 줄 가져오기
    private func currentLine() -> String {
        guard !isAtEnd() else { return "" }
        return lines[currentIndex]
    }
    
    /// 다음 줄로 이동
    private func advance() {
        currentIndex += 1
    }
    
    /// 줄의 끝에 도달했는지 확인
    private func isAtEnd() -> Bool {
        currentIndex >= lines.count
    }
}

// MARK: - Block 단위 (한 줄) 파싱 (Top-down 방식)
extension MarkdownParser {
    
    /// 전체 문서를 파싱하여 노드 배열 반환
    /// EBNF: Document ::= Block { Block }
    func parseDocument() -> [MarkdownNode] {
        var nodes: [MarkdownNode] = []
        
        while !isAtEnd() {
            if let node = parseBlock() {
                nodes.append(node) // 한 줄 해석 결과를 추가
            } else {
                advance()
            }
        }
        return nodes
    }
    
    /// 현재 줄이 어떤 블록(heading, list, 문단) 인지 판별
    /// EBNF: Block ::= Heading | ListItem | Paragraph
    private func parseBlock() -> MarkdownNode? {
        
        let line = currentLine()
           
        if line.trimmingCharacters(in: .whitespaces).isEmpty {
            advance()
            return .lineBreak // ← 공백 줄은 줄바꿈 처리
        }
        
        if let heading = parseHeading() {
            return heading
        } else if let code = parseCodeBlock() {
            return code
        } else if let list = parseListItem() {
            return list
        } else if let paragraph = parseParagraph() {
            return paragraph
        }
        return nil
    }
    
    /// Heading 문법: # 또는 ## 등으로 시작하는 줄
    /// EBNF: Heading ::= HeadingMarker Space TextLine
    private func parseHeading() -> MarkdownNode? {
        let line = currentLine()
        
        // 반드시 '# ' 또는 '## ' 같은 패턴만 허용
        guard let _ = line.range(of: #"^#{1,6} "#, options: .regularExpression) else {
            return nil
        }

        // # 갯수 계산
        let level = line.prefix(while: { $0 == "#" }).count
        let text = line.dropFirst(level + 1) // # + 공백 제거
        advance()
        return .heading(level: level, text: String(text))
    }

    
    /// 리스트 문법: - 으로 시작하는 줄
    /// EBNF: ListItem ::= '- ' TextLine
    /// 입력: - **강조됨** 텍스트
    /*
     .listItem(text: [
       .bold([.text("강조됨")]),
       .text(" 텍스트")
     ])
     */
    private func parseListItem() -> MarkdownNode? {
        let line = currentLine()
        guard line.hasPrefix("- ") else { return nil}
        
        let content = line.dropFirst(2)
        advance()
        return .listItem(text: InlineParser(String(content)).parse())
    }
    
    /// 일반 문단 파싱 → 내부 인라인은 재귀 하강
    /// EBNF: Paragraph ::= TextLine
    /// 입력: 이건 **강조**된 문장입니다
    /*
     .paragraph(inlines: [
       .text("이건 "),
       .bold([.text("강조")]),
       .text("된 문장입니다")
     ])
     */
    private func parseParagraph() -> MarkdownNode? {
        let line = currentLine()
        
        // 줄의 앞뒤 공백을 제거하고 내용이 비어있으면 nil 반환
        guard !line.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        
        advance()
        let inlines = InlineParser(line).parse()
        return .paragraph(inlines: inlines)
    }
    
    private func parseCodeBlock() -> MarkdownNode? {
        let line = currentLine()
        guard line.hasPrefix("```") else { return nil }
        
        let language = line.dropFirst(3).trimmingCharacters(in: .whitespaces)
        advance()
        
        var codeLines: [String] = []
        
        while !isAtEnd(), !currentLine().hasPrefix("```") {
            codeLines.append(currentLine())
            advance()
        }
        
        advance() // 닫는 ``` 넘기기
        
        return .code(language: language.isEmpty ? "code" : language, content: codeLines.joined(separator: "\n"))
    }
}


// MARK: - 재귀 하강 인라인 파서
final class InlineParser {
    private let input: String               // 전체 줄 문자열 (예: "문장 **굵게**")
    private var index: String.Index         // 현재 분석 중인 문자 위치
    
    init(_ input: String) {
        self.input = input
        self.index = input.startIndex       // 맨 처음 문자부터 시작
    }
}

extension InlineParser {
    /// 전체 문자열을 인라인 토큰 배열로 파싱
    /// 내부적으로 parseUntil(nil) 호출
    /// 입력: 안녕하세요 **강조** 텍스트입니다.
    /*
     [
       .text("안녕하세요 "),
       .bold([.text("강조")]),
       .text(" 텍스트입니다.")
     ]
     */
    func parse() -> [InlineNode] {
        return parseUntil(nil)
    }
    
    /// 특정 종료 기호(delimiter)가 나올 때까지 재귀적으로 인라인을 파싱
    /// delimiter: "**"이면 '**'가 닫힐 때까지 내부를 다시 파싱 (중첩 지원)
    private func parseUntil(_ delimiter: String?) -> [InlineNode] {
        var result: [InlineNode] = []   // 결과로 리턴한 노드 리스트
        var buffer = ""                 // 일반 텍스트를 모아두는 버퍼
        
        // 버퍼에 모인 일반 텍스트를 노드로 바꿔 추가
        func flush() {
            if !buffer.isEmpty {
                result.append(.text(buffer))
                buffer = ""
            }
        }
        
        /// 본격적인 루프 시작
        while !isAtEnd() {
            /// 종료 기호가 왔다면 종료
            if let delimiter = delimiter, peek(delimiter) {
                advance(delimiter.count)        // 닫는 기호 consume
                flush()
                return result                       // 현재 계층의 노드 목록 반환
            }
            
            /// ** 가 등장하면 bold 시작
            if match("**") {
                flush()                             // 기존 텍스트 반영
                let children = parseUntil("**")     // '**' 안쪽 재귀 파싱
                result.append(.bold(children))      // Bold 노드 추가
            } else if match("##") {
                flush()
                let children = parseUntil("##")
                result.append(.underline(children))
            } else {
                buffer.append(current())            // 일반 문자 누락
                advance(1)
            }
        }
        
        flush()
        return result
    }
    
    /// 현재 문자 반환
    private func current() -> Character {
        input[index]
    }

    /// 주어진 문자열 s가 현재 위치에서 시작되는지 확인
    private func peek(_ s: String) -> Bool {
        input[index...].hasPrefix(s)
    }
    
    /// 인덱스를 n글자 만큼 앞으로 이동하고 소비한 문자를 반환
    private func advance(_ n: Int) {
        index = input.index(index, offsetBy: n)
    }
    
    /// 입력 끝까지 도달했는지 확인
    private func isAtEnd() -> Bool {
        index >= input.endIndex
    }
    
    /// 주어진 문자열 s가 현재 위치에 있다면 consume하고 true, 아니면 false
    private func match(_ s: String) -> Bool {
        if peek(s) {
            advance(s.count)
            return true
        }
        return false
    }
}


// MARK: - 파싱된 MarkdownNode 배열을 SwiftUI View로 변환하는 역할
struct MarkdownRenderer {
    @MainActor
    func render(nodes: [MarkdownNode]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 각 노드를 순회하며 View로 렌더링
            ForEach(Array(nodes.enumerated()), id: \.offset) { _, node in
                switch node {
                case .heading(let level, let text):
                    let fontSize = (28 - level * 2).scaled
                    Text(text)
                        .font(.system(size: CGFloat(fontSize), weight: .bold))
                case .listItem(let inlines):
                    HStack(alignment: .top) {
                        Text("•")
                        renderInline(inlines)
                    }
                case .paragraph(let inlines):
                    renderInline(inlines)
                case .code(language: let language, content: let content):
                    VStack(alignment: .leading, spacing: 6.scaled) {
                        Text("\(language.uppercased()) CODE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(content)
                            .font(.system(size: 13.scaled, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                case .lineBreak:
                    Spacer(minLength: 8)
                }
            }
        }
    }
    
    func renderInline(_ inlines: [InlineNode], fontSize: CGFloat = 15, color: Color = .primary) -> Text {
        let pieces: [Text] = inlines.map { node in
            switch node {
            case .text(let str):
                return Text(str)
                    .font(.system(size: fontSize))
                    .foregroundColor(color)

            case .bold(let children):
                return renderInline(children, fontSize: 20, color: .mainGreen)
                    .bold()

            case .underline(let children):
                return renderInline(children, fontSize: fontSize, color: .mainGreen)
                    .underline()
            }
        }

        // reduce로 병합 (컴파일러 부담 줄임)
        return pieces.reduce(Text(""), +)
    }
}


// MARK: - 마크다운 텍스트를 입력받아 SwiftUI View로 렌더링
struct MarkdownView: View {
    let markdown: String
    
    var body: some View {
        let nodes = MarkdownParser(markdown: markdown).parseDocument()
        ScrollView {
            MarkdownRenderer().render(nodes: nodes)
                .frame(maxWidth: .infinity, alignment: .topLeading) // 좌측 상단 정렬
        }
    }
}

