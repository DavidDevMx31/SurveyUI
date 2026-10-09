import XCTest
@testable import SurveyUI

final class SurveyStoreTests: XCTestCase {
    @MainActor
    func testSingleChoiceResponseAndNavigationRestoreSavedSelection() throws {
        let store = try makeStore()

        guard case .incomplete = store.currentValidationState else {
            return XCTFail("Expected initial response to be incomplete")
        }
        store.nextQuestion()
        XCTAssertEqual(store.currentQuestionIndex, 0)

        store.selectOption("first-option")
        guard case .valid = store.currentValidationState else {
            return XCTFail("Expected selected response to be valid")
        }

        store.nextQuestion()
        XCTAssertEqual(store.currentQuestionIndex, 1)

        store.selectOption("second-option")
        store.previousQuestion()

        XCTAssertEqual(store.currentQuestionIndex, 0)
        XCTAssertEqual(store.currentResponse.selectedOptionsId, ["first-option"])
    }

    private func makeStore() throws -> SurveyStore {
        let firstQuestion = try makeQuestion(id: "first-question", optionID: "first-option")
        let secondQuestion = try makeQuestion(id: "second-question", optionID: "second-option")
        let survey = try Survey(
            id: "survey",
            intro: "Introduction",
            questions: [firstQuestion, secondQuestion],
            completionContent: .example
        )
        return SurveyStore(survey: survey)
    }

    private func makeQuestion(id: String, optionID: String) throws -> Question {
        let option = try QuestionOption(id: optionID, description: "Option")
        return try XCTUnwrap(try Question(
            id: id,
            prompt: "Choose one",
            type: .singleChoice(options: [option])
        ))
    }
}
