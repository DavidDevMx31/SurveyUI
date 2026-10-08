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
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyOptionDescription }
        self.id = id
        self.description = description
        self.emoji = emoji
    }
}

struct MultiSelectionQuestion: Identifiable {
    let id: String
    let prompt: String
    var options: [CategoryOption]
    let maxSelectableItems: Int
}
