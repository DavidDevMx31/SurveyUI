//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

//MARK: Survey
public struct Survey: Identifiable {
    public var id: String
    var intro: AttributedString
    var acknowledgments: AttributedString
    var questions: [Question]
    
    init(id: String, intro: String, questions: [Question], acknowledgments: String) {
        self.id = id
        self.intro = AttributedString(intro)
        self.questions = questions
        self.acknowledgments = AttributedString(acknowledgments)
    }
    
    init(id: String, intro: AttributedString, questions: [Question], acknowledgments: AttributedString) {
        self.id = id
        self.intro = intro
        self.questions = questions
        self.acknowledgments = acknowledgments
    }
}

//MARK: Survey questions
public struct Question: Identifiable {
    public let id: String
    let prompt: String
    let options: [QuestionOption]
    var type: QuestionType
    
    init?(id: ID, prompt: String, type: QuestionType) {
        self.id = id
        self.prompt = prompt
        self.type = type
        
        switch type {
        case .multipleSelection(let associatedOptions),
                .singleSelection(options: let associatedOptions):
            
            let allowsTextOptions = associatedOptions.filter { $0.allowsText == true }
            if allowsTextOptions.count > 1 { return nil }
            
            self.options = associatedOptions
        default:
            self.options = []
        }
    }
    
    var allowTextOption: QuestionOption? {
        options.first(where: { $0.allowsText == true })
    }
}

//MARK: Question options
public struct QuestionOption: Identifiable {
    public let id: String
    let description: String
    let allowsText: Bool
    
    public init(id: String, description: String, allowsText: Bool = false) {
        self.id = id
        self.description = description
        self.allowsText = allowsText
    }
}
