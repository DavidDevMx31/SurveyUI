//
//  MultipleOptionQuestionStrategy.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/05/25.
//

import Foundation

//MARK: Validation state
enum QuestionValidationState {
    case incomplete // Question result is not ready to submit yet
    case valid      // Question result is valid
    case invalid(QuestionValidationError)   //Question result is not valid and should trigger an error

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

//MARK: Validation error
enum QuestionValidationError: LocalizedError {
    case selectionLimitExceeded(maximum: Int)

    var errorDescription: String? {
        switch self {
        case let .selectionLimitExceeded(maximum):
            return "Selecciona máximo \(maximum) elementos"
        }
    }
}
