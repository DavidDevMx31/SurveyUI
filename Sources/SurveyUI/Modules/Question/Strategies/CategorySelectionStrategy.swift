//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 06/10/26.
//

import Foundation

struct CategorySelectionStrategy: SurveyQuestionStrategy {
    private(set) var currentQuestion: Question
    private(set) var maxSelectableItems: Int
    
    init (currentQuestion: Question, maxSelectableItems: Int) {
        self.currentQuestion = currentQuestion
        self.maxSelectableItems = maxSelectableItems
    }
    
    func selectOption(_ id: String, currentResult: QuestionResult) -> QuestionResult {
        guard var previousSelection = currentResult.selectedOptionsId else {
            return QuestionResult(questionId: currentQuestion.id, selectedId: id)
        }
        
        //Vemos si esta seleccionada previamente
        if previousSelection.contains(id) {
            previousSelection.removeAll(where: {$0 == id })
        } else {
            previousSelection.append(id)
        }
        var result = QuestionResult(questionId: id)
        result.setResponse(selectedOptionsId: previousSelection, comments: nil)
        return result
    }
    
    func validate(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOptions = response.selectedOptionsId else { return .incomplete }
        if selectedOptions.isEmpty { return .incomplete }
        if selectedOptions.count > maxSelectableItems { return .invalid(.selectionLimitExceeded(maximum: maxSelectableItems)) }
        return .valid
    }
}
