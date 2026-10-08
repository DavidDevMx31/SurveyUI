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
    /*
     To-do 001: handle errors form questions in this enum, discard old SurveyError
     //case textIsEmpty
     //case noCommentsAllowed
     //case noSelection
     */
    

    var errorDescription: String? {
        switch self {
        case let .selectionLimitExceeded(maximum):
            return "Selecciona máximo \(maximum) elementos"
            /*
        To-do 001
        case .textIsEmpty:
            return "El texto de comentarios es requerido"
        case .noCommentsAllowed:
            return "Esta opción no permite agregar comentarios"
        case .noSelection:
            return "Seleccionar una opción es requerido"
             */
        }
    }
}
