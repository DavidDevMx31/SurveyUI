//
//  MultipleOptionQuestionStrategy.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/05/25.
//

import Foundation

//MARK: MultipleOptionQuestionStrategy declaration
protocol MultipleOptionQuestionStrategy {
    var currentQuestion: Question { get }
    func selectOption(withId id: String) -> QuestionResult
}

extension MultipleOptionQuestionStrategy {
    
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

//MARK: Single selection
struct SingleSelectionStrategy: MultipleOptionQuestionStrategy {
    private(set) var currentQuestion: Question
    
    init(currentQuestion: Question) {
        self.currentQuestion = currentQuestion
    }
    
    func selectOption(withId id: String) -> QuestionResult {
        return QuestionResult(questionId: currentQuestion.id, selectedId: id)
    }
    
}

