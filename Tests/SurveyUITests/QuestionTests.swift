import XCTest
@testable import SurveyUI

final class QuestionTests: XCTestCase {
    func testRejectsEmptyID() throws {
        XCTAssertThrowsError(try makeQuestion(id: "", prompt: "Prompt")) { error in
            guard case .some(.emptyId) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyId, got \(error)")
            }
        }
    }

    func testRejectsWhitespaceOnlyID() throws {
        XCTAssertThrowsError(try makeQuestion(id: " \n\t ", prompt: "Prompt")) { error in
            guard case .some(.emptyId) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyId, got \(error)")
            }
        }
    }

    func testRejectsEmptyPrompt() throws {
        XCTAssertThrowsError(try makeQuestion(id: "question", prompt: "")) { error in
            guard case .some(.emptyDescription) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyDescription, got \(error)")
            }
        }
    }

    func testRejectsWhitespaceOnlyPrompt() throws {
        XCTAssertThrowsError(try makeQuestion(id: "question", prompt: " \n\t ")) { error in
            guard case .some(.emptyDescription) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyDescription, got \(error)")
            }
        }
    }

    func testConstructsValidSingleChoiceQuestion() throws {
        let question = try XCTUnwrap(try makeQuestion(id: "question", prompt: "Choose one"))

        XCTAssertEqual(question.id, "question")
    }

    private func makeQuestion(id: String, prompt: String) throws -> Question? {
        let option = try QuestionOption(id: "option", description: "Option")
        return try Question(id: id, prompt: prompt, type: .singleChoice(options: [option]))
    }
}
