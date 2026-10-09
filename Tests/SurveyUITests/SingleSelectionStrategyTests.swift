import XCTest
@testable import SurveyUI

final class SingleSelectionStrategyTests: XCTestCase {
    func testNoSelectedIDIsIncomplete() throws {
        let strategy = try makeStrategy()

        guard case .incomplete = strategy.validate(for: QuestionResult(questionId: "question")) else {
            return XCTFail("Expected incomplete validation state")
        }
    }

    func testExactlyOneSelectedIDIsValid() throws {
        let strategy = try makeStrategy()

        guard case .valid = strategy.validate(for: QuestionResult(questionId: "question", selectedId: "first")) else {
            return XCTFail("Expected valid validation state")
        }
    }

    func testSelectingNewOptionReplacesPreviousSelection() throws {
        let strategy = try makeStrategy()
        let previous = QuestionResult(questionId: "question", selectedId: "first")

        let result = strategy.selectOption("second", currentResult: previous)

        XCTAssertEqual(result.selectedOptionsId, ["second"])
    }

    func testTwoSelectedIDsExceedSelectionLimit() throws {
        let strategy = try makeStrategy()
        var response = QuestionResult(questionId: "question")
        response.setResponse(selectedOptionsId: ["first", "second"], comments: nil)

        guard case let .invalid(error) = strategy.validate(for: response),
              case .selectionLimitExceeded(maximum: 1) = error else {
            return XCTFail("Expected selectionLimitExceeded(maximum: 1)")
        }
    }

    private func makeStrategy() throws -> SingleSelectionStrategy {
        let options = [
            try QuestionOption(id: "first", description: "First"),
            try QuestionOption(id: "second", description: "Second")
        ]
        let question = try XCTUnwrap(try Question(
            id: "question",
            prompt: "Choose one",
            type: .singleChoice(options: options)
        ))
        return SingleSelectionStrategy(currentQuestion: question)
    }
}
