//
//  SurveyQuestionProtocol.swift
//  SurveyUI
//
//  Created by David Mendoza on 06/10/26.
//

import Foundation

protocol SurveyQuestionStrategy {
    //MARK: Properties
    var currentQuestion: Question { get }
    //MARK: Functions
    func selectOption(_ id: String, currentResult: QuestionResult) -> QuestionResult
    func validate(for response: QuestionResult) -> QuestionValidationState
}

extension SurveyQuestionStrategy {
    
    func limitComment(_ comment: String, maxChars: Int = 100) -> String {
        String(comment.trimmingCharacters(in: .whitespacesAndNewlines).prefix(100))
    }
    
    func appendComment(_ comment: String, withOptionIds selectedIds: [String]?) -> Result<QuestionResult, SurveyError> {
        guard let allowsTextOption = currentQuestion.allowTextOption else {
            //Opcion no permite agregar texto
            return .failure(SurveyError.noCommentsAllowed)
        }
        
        let userComment = limitComment(comment)
        guard !userComment.isEmpty else {
            return .failure(SurveyError.textIsEmpty)
        }

        var newResponse = QuestionResult(questionId: currentQuestion.id)
        if let selectedOptions = selectedIds {
            if selectedOptions.contains(allowsTextOption.id) {
                newResponse.setResponse(selectedOptionsId: selectedOptions, comments: userComment)
                return .success(newResponse)
            }
        }
        return .failure(SurveyError.noSelection)
    }
}
