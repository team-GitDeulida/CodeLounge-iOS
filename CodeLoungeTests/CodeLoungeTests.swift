import Foundation
import Testing
@testable import CodeLounge

struct CodeLoungeTests {
    @Test("User.toDTO가 명시된 값을 올바르게 변환한다")
    func userToDTOMapsExplicitValues() {
        let registerDate = ISO8601DateFormatter().date(from: "2026-04-10T00:00:00Z")!
        let birthdayDate = ISO8601DateFormatter().date(from: "2000-01-29T00:00:00Z")!
        let user = User(
            id: "user-1",
            nickname: "김동현",
            registerDate: registerDate,
            birthdayDate: birthdayDate,
            gender: .male,
            loginPlatform: .apple
        )

        let dto = user.toDTO()

        #expect(dto.id == "user-1")
        #expect(dto.nickname == "김동현")
        #expect(dto.gender == Gender.male.rawValue)
        #expect(dto.loginPlatform == LoginPlatform.apple.rawValue)
        #expect(dto.registerDate == seoulISO8601Formatter.string(from: registerDate))
        #expect(dto.birthdayDate == seoulISO8601Formatter.string(from: birthdayDate))
    }

    @Test("User.toDTO가 옵셔널 값이 없을 때 기본값으로 대체한다")
    func userToDTOFallsBackToDefaults() {
        let user = User(
            id: "user-default",
            nickname: "fallback",
            registerDate: nil,
            birthdayDate: nil,
            gender: nil,
            loginPlatform: nil
        )

        let dto = user.toDTO()

        #expect(dto.id == "user-default")
        #expect(dto.nickname == "fallback")
        #expect(dto.gender == Gender.male.rawValue)
        #expect(dto.loginPlatform == LoginPlatform.google.rawValue)
        #expect(ISO8601DateFormatter().date(from: dto.registerDate) != nil)
        #expect(ISO8601DateFormatter().date(from: dto.birthdayDate) != nil)
    }

    @Test("UserDTO.toModel이 enum과 날짜를 올바르게 변환한다")
    func userDTOToModelDecodesValues() {
        let dto = UserDTO(
            id: "user-2",
            nickname: "tester",
            registerDate: "2026-04-10T00:00:00Z",
            birthdayDate: "2001-02-03T00:00:00Z",
            gender: Gender.female.rawValue,
            loginPlatform: LoginPlatform.google.rawValue
        )

        let model = dto.toModel()

        #expect(model.id == "user-2")
        #expect(model.nickname == "tester")
        #expect(model.gender == .female)
        #expect(model.loginPlatform == .google)
        #expect(model.registerDate != nil)
        #expect(model.birthdayDate != nil)
    }

    @Test("UserDTO.toModel이 잘못된 enum과 날짜 값에 대해 기본 처리한다")
    func userDTOToModelFallsBackForInvalidValues() {
        let dto = UserDTO(
            id: "broken-user",
            nickname: "tester",
            registerDate: "not-a-date",
            birthdayDate: "also-not-a-date",
            gender: "invalid-gender",
            loginPlatform: "invalid-platform"
        )

        let before = Date()
        let model = dto.toModel()
        let after = Date()

        #expect(model.id == "broken-user")
        #expect(model.nickname == "tester")
        #expect(model.gender == nil)
        #expect(model.loginPlatform == nil)
        #expect(model.registerDate != nil)
        #expect(model.birthdayDate != nil)
        #expect(model.registerDate! >= before.addingTimeInterval(-1))
        #expect(model.registerDate! <= after.addingTimeInterval(1))
        #expect(model.birthdayDate! >= before.addingTimeInterval(-1))
        #expect(model.birthdayDate! <= after.addingTimeInterval(1))
    }

    @Test("PostDTO.toDomain이 필드를 올바르게 변환한다")
    func postDTOToDomainMapsFields() {
        let dto = PostDTO(
            id: "post-1",
            title: "Swift",
            content: "content",
            authorID: "author-1",
            createdAt: "2026-04-10T12:00:00Z"
        )

        let post = dto.toDomain()

        #expect(post.id == "post-1")
        #expect(post.title == "Swift")
        #expect(post.content == "content")
        #expect(post.authorID == "author-1")
        #expect(post.createdAt == ISO8601DateFormatter().date(from: "2026-04-10T12:00:00Z"))
    }

    @Test("PostDTO.toDomain이 잘못된 시간값에 대해 현재 날짜로 대체한다")
    func postDTOToDomainFallsBackForInvalidTimestamp() {
        let dto = PostDTO(
            id: "post-invalid-date",
            title: "Swift",
            content: "content",
            authorID: "author-1",
            createdAt: "invalid"
        )

        let before = Date()
        let post = dto.toDomain()
        let after = Date()

        #expect(post.id == "post-invalid-date")
        #expect(post.createdAt >= before.addingTimeInterval(-1))
        #expect(post.createdAt <= after.addingTimeInterval(1))
    }

    @Test("MarkdownParser가 제목 목록 문단 코드블록을 파싱한다")
    func markdownParserParsesStructuredBlocks() {
        let markdown = """
        # Title

        - **Bold**
        일반 문단
        ```swift
        let value = 1
        ```
        """

        let nodes = MarkdownParser(markdown: markdown).parseDocument()

        #expect(nodes.count == 5)
        #expect(nodes[0] == .heading(level: 1, text: "Title"))
        #expect(nodes[1] == .lineBreak)
        #expect(nodes[2] == .listItem(text: [.bold([.text("Bold")])]))
        #expect(nodes[3] == .paragraph(inlines: [.text("일반 문단")]))
        #expect(nodes[4] == .code(language: "swift", content: "let value = 1"))
    }

    @Test("InlineParser가 중첩된 볼드와 밑줄 마크업을 파싱한다")
    func inlineParserParsesNestedMarkup() {
        let nodes = InlineParser("start **bold ##under## end** done").parse()

        #expect(
            nodes == [
                .text("start "),
                .bold([
                    .text("bold "),
                    .underline([.text("under")]),
                    .text(" end")
                ]),
                .text(" done")
            ]
        )
    }
}

private let seoulISO8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
}()
