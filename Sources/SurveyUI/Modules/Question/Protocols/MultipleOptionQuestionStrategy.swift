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
    func selectId(_ id: String, currentResult: QuestionResult) -> QuestionResult
    func validationState(for response: QuestionResult) -> QuestionValidationState
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
    
    func selectId(_ id: String, currentResult: QuestionResult) -> QuestionResult {
        return QuestionResult(questionId: currentQuestion.id, selectedId: id)
    }
    
    func validationState(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOption = response.selectedOptionsId, selectedOption.count != 1 else { return .incomplete }
        return .valid
    }
}

//MARK: Multiple option selection
struct MultipleSelectionStrategy: MultipleOptionQuestionStrategy {
    private(set) var currentQuestion: Question
    
    init(currentQuestion: Question) {
        self.currentQuestion = currentQuestion
    }
    
    func selectOption(withId id: String) -> QuestionResult {
        return QuestionResult(questionId: currentQuestion.id, selectedId: id)
    }
    
    func selectId(_ id: String, currentResult: QuestionResult) -> QuestionResult {
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
    
    func validationState(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOption = response.selectedOptionsId, selectedOption.count == 0 else { return .incomplete }
        if currentQuestion.allowTextOption != nil {
            if response.comments?.isEmpty == true { return .incomplete }
        }
        return .valid
    }
}

struct CategorySelectionStrategy: MultipleOptionQuestionStrategy {
    private(set) var currentQuestion: Question
    private(set) var maxSelectableItems: Int
    
    init (currentQuestion: Question, maxSelectableItems: Int) {
        self.currentQuestion = currentQuestion
        self.maxSelectableItems = maxSelectableItems
    }
    
    func selectId(_ id: String, currentResult: QuestionResult) -> QuestionResult {
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
    
    func validateResponse(_ response: QuestionResult) -> Bool {
        guard let selectedOptions = response.selectedOptionsId else { return false }
        if selectedOptions.isEmpty { return false }
        if selectedOptions.count > maxSelectableItems { return false }
        return true
    }
    
    func validationState(for response: QuestionResult) -> QuestionValidationState {
        guard let selectedOptions = response.selectedOptionsId else { return .incomplete }
        if selectedOptions.isEmpty { return .incomplete }
        if selectedOptions.count > maxSelectableItems { return .invalid(.selectionLimitExceeded(maximum: maxSelectableItems)) }
        return .valid
    }
}

enum QuestionValidationState {
    case incomplete
    case valid
    case invalid(QuestionValidationError)

    var canAdvance: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }

    var message: String? {
        guard case let .invalid(error) = self else {
            return nil
        }

        return error.localizedDescription
    }
}

enum QuestionValidationError: LocalizedError {
    case selectionLimitExceeded(maximum: Int)

    var errorDescription: String? {
        switch self {
        case let .selectionLimitExceeded(maximum):
            "Selecciona máximo \(maximum) elementos"
        }
    }
}
