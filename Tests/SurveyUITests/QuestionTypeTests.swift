import XCTest
@testable import SurveyUI

final class QuestionTypeTests: XCTestCase {
    func testSingleChoiceAcceptsUniqueOptionsWithoutTextOption() throws {
        let options = [
            try QuestionOption(id: "first", description: "First"),
            try QuestionOption(id: "second", description: "Second")
        ]

        let question = try XCTUnwrap(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        ))

        XCTAssertEqual(question.id, "question")
    }

    func testSingleChoiceAcceptsExactlyOneTextOption() throws {
        let options = [
            try QuestionOption(id: "first", description: "First"),
            try QuestionOption(id: "other", description: "Other", allowsText: true)
        ]

        let question = try XCTUnwrap(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        ))

        XCTAssertEqual(question.id, "question")
    }

    func testSingleChoiceAcceptsOneRegularOption() throws {
        let options = [try QuestionOption(id: "only", description: "Only option")]

        let question = try XCTUnwrap(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        ))

        XCTAssertEqual(question.id, "question")
    }

    func testSingleChoiceRejectsEmptyOptions() throws {
        XCTAssertThrowsError(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: [])
        )) { error in
            guard case .some(.emptyOptions) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyOptions, got \(error)")
            }
        }
    }

    func testSingleChoiceRejectsRepeatedOptionIDs() throws {
        let options = [
            try QuestionOption(id: "duplicate", description: "First"),
            try QuestionOption(id: "duplicate", description: "Second")
        ]

        XCTAssertThrowsError(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        )) { error in
            guard case .some(.nonUniqueIds) = error as? SurveyDefinitionError else {
                return XCTFail("Expected nonUniqueIds, got \(error)")
            }
        }
    }

    func testSingleChoiceRejectsMultipleTextOptions() throws {
        let options = [
            try QuestionOption(id: "other-1", description: "Other one", allowsText: true),
            try QuestionOption(id: "other-2", description: "Other two", allowsText: true)
        ]

        XCTAssertThrowsError(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        )) { error in
            guard case .some(.manyOptionsAllowText) = error as? SurveyDefinitionError else {
                return XCTFail("Expected manyOptionsAllowText, got \(error)")
            }
        }
    }
}
