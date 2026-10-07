//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 06/10/26.
//

import Foundation

//MARK: Multiple option selection
struct MultipleSelectionStrategy: SurveyQuestionStrategy {
    private(set) var currentQuestion: Question
    
    init(currentQuestion: Question) {
        self.currentQuestion = currentQuestion
    }
    /*
    func selectOption(withId id: String) -> QuestionResult {
        return QuestionResult(questionId: currentQuestion.id, selectedId: id)
    }
    */
    func selectOption(_ id: String, currentResult: QuestionResult) -> QuestionResult {
        guard var previousSelection = currentResult.selectedOptionsId else {
            return QuestionResult(questionId: currentQuestion.id, selectedId: id)
        }
        
        var deleteComment = false
        var newResult = QuestionResult(questionId: currentQuestion.id)
        
        if previousSelection.contains(id) {
            //Check if selection allows comments
            if let allowsComments = currentQuestion.allowTextOption {
                if allowsComments.id == id {
                    deleteComment = true
                }
            }
            //Delete current id from selected ids
            previousSelection = previousSelection.filter { $0 != id }
        } else {
            //Append current id to selected id list
            previousSelection.append(id)
        }
        
        let comments = deleteComment ? nil : currentResult.comments
        newResult.setResponse(selectedOptionsId: previousSelection, comments: comments)
        return newResult
    }
    
    func validate(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOptions = response.selectedOptionsId else { return .incomplete }
        if currentQuestion.allowTextOption != nil {
            if response.comments?.isEmpty == true { return .incomplete }
        }
        return .valid
    }
}
