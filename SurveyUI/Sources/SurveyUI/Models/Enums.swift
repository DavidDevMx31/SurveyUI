//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

//MARK: Question types
public enum QuestionType {
    case singleSelection(options: [QuestionOption])
    case multipleSelection(options: [QuestionOption])
    case open(placeholder: String)
}

//MARK: Question errors
public enum QuestionError: LocalizedError {
    case tooManyOptionsAllowText
}

extension QuestionError {
    public var failureReason: String? {
        switch self {
        case .tooManyOptionsAllowText:
            return "Hay dos o más opciones que pueden recibir comentarios"
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .tooManyOptionsAllowText:
            return "Se asignaron dos o más preguntas que pueden recibir comentarios"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .tooManyOptionsAllowText:
            return "Ingrese máximo una pregunta que pueda recibir comentarios"
        }
    }
}

//MARK: Survey errors
enum SurveyError: LocalizedError {
    case textIsEmpty
    case noSelection
}

extension SurveyError {
    var failureReason: String? {
        switch self {
        case .textIsEmpty:
            return "El texto de comentarios está vacío"
        case .noSelection:
            return "No has seleccionado ninguna opción"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .textIsEmpty:
            return "El texto de comentarios es requerido"
        case .noSelection:
            return "Seleccionar una opción es requerido"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .textIsEmpty:
            return "Agrega tus comentarios"
        case .noSelection:
            return "Selecciona una opción"
        }
    }
}

