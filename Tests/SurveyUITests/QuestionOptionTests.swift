import XCTest
@testable import SurveyUI

final class QuestionOptionTests: XCTestCase {
    func testCreatesRegularOption() throws {
        let option = try makeOption(id: "regular", description: "Regular option")

        XCTAssertEqual(option.id, "regular")
        XCTAssertFalse(option.allowsText)
    }

    func testCreatesTextEnabledOption() throws {
        let option = try makeOption(id: "other", description: "Other", allowsText: true)

        XCTAssertEqual(option.id, "other")
        XCTAssertTrue(option.allowsText)
    }

    func testRejectsEmptyID() {
        XCTAssertThrowsError(try QuestionOption(id: "", description: "Option")) { error in
            guard case .some(.emptyId) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyId, got \(error)")
            }
        }
    }

    func testRejectsWhitespaceOnlyID() {
        XCTAssertThrowsError(try QuestionOption(id: " \n\t ", description: "Option")) { error in
            guard case .some(.emptyId) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyId, got \(error)")
            }
        }
    }

    func testRejectsEmptyDescription() {
        XCTAssertThrowsError(try QuestionOption(id: "option", description: "")) { error in
            guard case .some(.emptyDescription) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyDescription, got \(error)")
            }
        }
    }

    func testRejectsWhitespaceOnlyDescription() {
        XCTAssertThrowsError(try QuestionOption(id: "option", description: " \n\t ")) { error in
            guard case .some(.emptyDescription) = error as? SurveyDefinitionError else {
                return XCTFail("Expected emptyDescription, got \(error)")
            }
        }
    }

    private func makeOption(id: String, description: String, allowsText: Bool = false) throws -> QuestionOption {
        try QuestionOption(id: id, description: description, allowsText: allowsText)
    }
}
