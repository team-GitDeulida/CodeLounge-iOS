//
//  MarkdownParser.swift
//  CodeLounge
//
//  Created by 김동현 on 5/10/25.
//

import Foundation
import SwiftUI

enum MarkdownNode: Equatable {
  case heading(level: Int, text: String)
  case listItem(text: [InlineNode])
  case paragraph(inlines: [InlineNode])
  case code(language: String, content: String)
  case lineBreak
}

enum InlineNode: Equatable {
  case text(String)
  case bold([InlineNode])
  case underline([InlineNode])
}

final class MarkdownParser {
  private let lines: [String]
  private var currentIndex = 0

  init(markdown: String) {
    let normalized = markdown.replacingOccurrences(of: "\\n", with: "\n")
    self.lines = normalized.components(separatedBy: .newlines)
  }

  func parseDocument() -> [MarkdownNode] {
    var nodes: [MarkdownNode] = []

    while !isAtEnd() {
      if let node = parseBlock() {
        nodes.append(node)
      } else {
        advance()
      }
    }

    return nodes
  }

  private func parseBlock() -> MarkdownNode? {
    let line = currentLine()

    if line.trimmingCharacters(in: .whitespaces).isEmpty {
      advance()
      return .lineBreak
    }

    if let heading = parseHeading() {
      return heading
    }

    if let code = parseCodeBlock() {
      return code
    }

    if let list = parseListItem() {
      return list
    }

    return parseParagraph()
  }

  private func parseHeading() -> MarkdownNode? {
    let trimmed = currentLine().trimmingCharacters(in: .whitespaces)

    if trimmed.hasPrefix("##"), trimmed.hasSuffix("##"), trimmed.count > 4 {
      return nil
    }

    guard let _ = currentLine().range(of: #"^#{1,6} "#, options: .regularExpression) else {
      return nil
    }

    let level = currentLine().prefix(while: { $0 == "#" }).count
    let text = String(currentLine().dropFirst(level + 1))
    advance()
    return .heading(level: level, text: text)
  }

  private func parseListItem() -> MarkdownNode? {
    let line = currentLine()
    guard line.hasPrefix("- ") else { return nil }

    let content = String(line.dropFirst(2))
    advance()
    return .listItem(text: InlineParser(content).parse())
  }

  private func parseParagraph() -> MarkdownNode? {
    let line = currentLine()
    guard !line.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }

    advance()
    return .paragraph(inlines: InlineParser(line).parse())
  }

  private func parseCodeBlock() -> MarkdownNode? {
    let line = currentLine()
    guard line.hasPrefix("```") else { return nil }

    let language = String(line.dropFirst(3)).trimmingCharacters(in: .whitespaces)
    advance()

    var codeLines: [String] = []
    while !isAtEnd(), !currentLine().hasPrefix("```") {
      codeLines.append(currentLine())
      advance()
    }

    if !isAtEnd() {
      advance()
    }

    return .code(
      language: language.isEmpty ? "code" : language,
      content: codeLines.joined(separator: "\n")
    )
  }

  private func currentLine() -> String {
    guard !isAtEnd() else { return "" }
    return lines[currentIndex]
  }

  private func advance() {
    currentIndex += 1
  }

  private func isAtEnd() -> Bool {
    currentIndex >= lines.count
  }
}

final class InlineParser {
  private let input: String
  private var index: String.Index

  init(_ input: String) {
    self.input = input
    self.index = input.startIndex
  }

  func parse() -> [InlineNode] {
    parseUntil(nil)
  }

  private func parseUntil(_ delimiter: String?) -> [InlineNode] {
    var result: [InlineNode] = []
    var buffer = ""

    func flush() {
      if !buffer.isEmpty {
        result.append(.text(buffer))
        buffer = ""
      }
    }

    while !isAtEnd() {
      if let delimiter, peek(delimiter) {
        advance(delimiter.count)
        flush()
        return result
      }

      if match("**") {
        flush()
        result.append(.bold(parseUntil("**")))
      } else if match("##") {
        flush()
        result.append(.underline(parseUntil("##")))
      } else {
        buffer.append(current())
        advance(1)
      }
    }

    flush()
    return result
  }

  private func current() -> Character {
    input[index]
  }

  private func peek(_ string: String) -> Bool {
    input[index...].hasPrefix(string)
  }

  private func advance(_ count: Int) {
    index = input.index(index, offsetBy: count)
  }

  private func isAtEnd() -> Bool {
    index >= input.endIndex
  }

  private func match(_ string: String) -> Bool {
    guard peek(string) else { return false }
    advance(string.count)
    return true
  }
}

struct MarkdownRenderer: View {
  let nodes: [MarkdownNode]

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(Array(nodes.enumerated()), id: \.offset) { _, node in
        MarkdownNodeView(node: node)
      }
    }
  }
}

private struct MarkdownNodeView: View {
  let node: MarkdownNode

  var body: some View {
    switch node {
    case .heading(let level, let text):
      Text(text)
        .font(.system(size: headingSize(for: level), weight: .bold))
        .foregroundStyle(Color.mainGreen)
        .padding(.top, 4)

    case .listItem(let inlines):
      HStack(alignment: .top, spacing: 8) {
        Text("•")
          .foregroundStyle(Color.mainWhite)
        MarkdownInlineText(inlines: inlines)
      }

    case .paragraph(let inlines):
      MarkdownInlineText(inlines: inlines)

    case .code(let language, let content):
      VStack(alignment: .leading, spacing: 6) {
        Text("\(language.uppercased()) CODE")
          .font(.caption)
          .foregroundStyle(.gray)

        ScrollView(.horizontal, showsIndicators: false) {
          Text(content)
            .font(.system(size: 13, design: .monospaced))
            .foregroundStyle(Color.mainWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
        }
        .background(Color.subBlack)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .padding(.vertical, 2)

    case .lineBreak:
      Color.clear
        .frame(height: 8)
    }
  }

  private func headingSize(for level: Int) -> CGFloat {
    max(18, 26 - CGFloat(level - 1) * 2)
  }
}

private struct MarkdownInlineText: View {
  let inlines: [InlineNode]
  var fontSize: CGFloat = 15
  var color: Color = .mainWhite

  var body: some View {
    renderInline(inlines)
      .font(.system(size: fontSize))
      .lineSpacing(8)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func renderInline(_ nodes: [InlineNode], fontSize: CGFloat? = nil, color: Color? = nil) -> Text {
    let resolvedFontSize = fontSize ?? self.fontSize
    let resolvedColor = color ?? self.color

    return nodes.reduce(Text("")) { partial, node in
      partial + text(for: node, fontSize: resolvedFontSize, color: resolvedColor)
    }
  }

  private func text(for node: InlineNode, fontSize: CGFloat, color: Color) -> Text {
    switch node {
    case .text(let string):
      return Text(string)
        .font(.system(size: fontSize))
        .foregroundColor(color)

    case .bold(let children):
      return renderInline(children, fontSize: 20, color: .mainGreen).bold()

    case .underline(let children):
      return renderInline(children, fontSize: fontSize, color: .mainGreen).underline()
    }
  }
}

struct MarkdownView: View {
  private let nodes: [MarkdownNode]

  init(markdown: String, hiddenTitle: String? = nil) {
    let parsedNodes = MarkdownParser(markdown: markdown).parseDocument()
    self.nodes = MarkdownView.removeLeadingDuplicateTitle(from: parsedNodes, hiddenTitle: hiddenTitle)
  }

  var body: some View {
    MarkdownRenderer(nodes: nodes)
      .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  private static func removeLeadingDuplicateTitle(
    from nodes: [MarkdownNode],
    hiddenTitle: String?
  ) -> [MarkdownNode] {
    guard let hiddenTitle = hiddenTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
          !hiddenTitle.isEmpty else {
      return nodes
    }

    guard let firstMeaningfulIndex = nodes.firstIndex(where: { node in
      switch node {
      case .lineBreak:
        return false
      default:
        return true
      }
    }) else {
      return nodes
    }

    guard case .heading(_, let text) = nodes[firstMeaningfulIndex],
          text.trimmingCharacters(in: .whitespacesAndNewlines)
            .localizedCaseInsensitiveCompare(hiddenTitle) == .orderedSame else {
      return nodes
    }

    var filteredNodes = nodes
    filteredNodes.remove(at: firstMeaningfulIndex)

    if firstMeaningfulIndex < filteredNodes.count,
       case .lineBreak = filteredNodes[firstMeaningfulIndex] {
      filteredNodes.remove(at: firstMeaningfulIndex)
    }

    return filteredNodes
  }
}
