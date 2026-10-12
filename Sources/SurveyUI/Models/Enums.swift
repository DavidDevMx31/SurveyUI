//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

//MARK: Question types
public enum QuestionType {
    case singleChoice(options: [QuestionOption])
    case multipleChoice(options: [QuestionOption])
    case open(placeholder: String)
    case categorySelection(options: [CategoryOption], maxSelectableItems: Int)
}

//MARK: Survey errors
enum SurveyError: LocalizedError {
    case textIsEmpty
    case noSelection
    case noCommentsAllowed
}

extension SurveyError {
    var failureReason: String? {
        switch self {
        case .textIsEmpty:
            return "The comment is empty"
        case .noSelection:
            return "No option is selected"
        case .noCommentsAllowed:
            return "This option does not allow comments"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .textIsEmpty:
            return "A comment is required"
        case .noSelection:
            return "An option must be selected"
        case .noCommentsAllowed:
            return "Comments are not allowed for this option"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .textIsEmpty:
            return "Add a comment"
        case .noSelection:
            return "Select an option"
        case .noCommentsAllowed:
            return "Remove the comment for this option"
        }
    }
}

//MARK: Survey definition errors
public enum SurveyDefinitionError: LocalizedError {
    case emptyId
    case emptyDescription
    case emptyOptions
    case manyOptionsAllowText
    case invalidMaximumSelection
    case nonUniqueIds
}
