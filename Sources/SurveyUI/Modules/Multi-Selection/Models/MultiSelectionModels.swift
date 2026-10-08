//
//  MultiSelectionModels.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/10/26.
//

import Foundation

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
