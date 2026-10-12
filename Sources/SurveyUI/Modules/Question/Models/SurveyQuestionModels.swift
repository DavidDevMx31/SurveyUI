//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 08/10/26.
//

import Foundation

//MARK: Survey question model
public struct Question: Identifiable {
    public let id: String
    let prompt: String
    let options: [QuestionOption]
    var type: QuestionType
    
    public init(id: String, prompt: String, type: QuestionType) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        guard prompt.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        
        switch type {
        case .multipleChoice(let associatedOptions),
                .singleChoice(options: let associatedOptions):
            
            guard !associatedOptions.isEmpty else { throw SurveyDefinitionError.emptyOptions }
            guard Question.validateOnlyOneOptionAllowsText(associatedOptions) else { throw SurveyDefinitionError.manyOptionsAllowText }
            guard Question.validateUniqueOptionIds(associatedOptions) else { throw SurveyDefinitionError.nonUniqueIds }
            self.options = associatedOptions
        case .categorySelection(options: let options, maxSelectableItems: let maxSelectableItems):
            guard !options.isEmpty else { throw SurveyDefinitionError.emptyOptions }
            if maxSelectableItems > options.count { throw SurveyDefinitionError.invalidMaximumSelection }
            guard Question.validateUniqueCategoryIds(options) else { throw SurveyDefinitionError.nonUniqueIds }
            self.options = []
        default:
            self.options = []
        }
        
        self.id = id
        self.prompt = prompt
        self.type = type
    }
    
    private static func validateOnlyOneOptionAllowsText(_ options: [QuestionOption]) -> Bool {
        let allowsTextOptions = options.filter { $0.allowsText == true }
        if allowsTextOptions.count > 1 { return false }
        return true
    }
    
    private static func validateUniqueOptionIds(_ options: [QuestionOption]) -> Bool {
        let ids = Set(options.map(\.id))
        if options.count != ids.count { return false }
        return true
    }
    
    private static func validateUniqueCategoryIds(_ options: [CategoryOption]) -> Bool {
        let ids = Set(options.map(\.id))
        if options.count != ids.count { return false }
        return true
    }
    
    var allowTextOption: QuestionOption? {
        options.first(where: { $0.allowsText == true })
    }
}

//MARK: Question option model
public struct QuestionOption: Identifiable {
    public let id: String
    let description: String
    let allowsText: Bool
    
    public init(id: String, description: String, allowsText: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        self.id = id
        self.description = description
        self.allowsText = allowsText
    }
}

//MARK: Category option model
public struct CategoryOption: Identifiable {
    public let id: String
    let description: String
    let emoji: String?
    
    public init(id: String, description: String, emoji: String?) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        self.id = id
        self.description = description
        self.emoji = emoji
    }
}
