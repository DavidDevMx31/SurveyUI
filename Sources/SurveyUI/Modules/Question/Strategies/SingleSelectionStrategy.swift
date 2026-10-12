//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 06/10/26.
//

import Foundation

//MARK: Single-selection question strategy
struct SingleSelectionStrategy: SurveyQuestionStrategy {
    private(set) var currentQuestion: Question
    
    init(currentQuestion: Question) {
        self.currentQuestion = currentQuestion
    }
    
    func selectOption(_ id: String, currentResult: QuestionResult) -> QuestionResult {
        return QuestionResult(questionId: currentQuestion.id, selectedId: id)
    }
    
    func validate(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOption = response.selectedOptionsId else { return .incomplete }
        guard selectedOption.count == 1 else { return .invalid(QuestionValidationError.selectionLimitExceeded(maximum: 1)) }
        return .valid
    }
}
