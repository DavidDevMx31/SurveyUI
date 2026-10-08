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
    let skippable: Bool
    
    init(id: String, intro: String, questions: [Question], acknowledgments: String, skippable: Bool = false) {
        self.id = id
        self.intro = AttributedString(intro)
        self.questions = questions
        self.acknowledgments = AttributedString(acknowledgments)
        self.skippable = skippable
    }
    
    init(id: String, intro: AttributedString, questions: [Question], acknowledgments: AttributedString, skippable: Bool = false) {
        self.id = id
        self.intro = intro
        self.questions = questions
        self.acknowledgments = acknowledgments
        self.skippable = skippable
    }
    
    public static func getSurveyExample() -> Survey {
        let questionOneOptions = [
            try! QuestionOption(id: "1", description: "Opción 1"),
            try! QuestionOption(id: "2", description: "Opción 2"),
            try! QuestionOption(id: "3", description: "Opción 3"),
            try! QuestionOption(id: "4", description: "Opción 4")
        ]
        
        let questionTwoOptions = [
            try! QuestionOption(id: "5", description: "Opción 5"),
            try! QuestionOption(id: "6", description: "Opción 6"),
            try! QuestionOption(id: "7", description: "Opción 7"),
            try! QuestionOption(id: "8", description: "Otro", allowsText: true)
        ]
        
        let questions = [Question(id: "1", prompt: "Aquí va el texto de la pregunta 1",
                                  type: .singleChoice(options: questionOneOptions)),
                         Question(id: "2", prompt: "Este es el texto de la pregunta 2",
                                  type: .singleChoice(options: questionTwoOptions))
        ]
        
        let markdownIntro: AttributedString = try! AttributedString(
            markdown: "**Esta es la introducción**\n\nPuedes usar texto normal o con atributos."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        let acknowledgments: AttributedString = try! AttributedString(
            markdown: "**¡Has terminado la encuesta!**\n\nPuedes usar este espacio para darle un mensaje final a tus usuarios."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        return Survey(id: UUID().uuidString, intro: markdownIntro,
                      questions: questions.compactMap({ $0 }), acknowledgments: acknowledgments)
    }
    
    public static func createSurvey(withId surveyId: String, questions: [Question],
                                    introPrompt: String = "", acknowledgments: String = "", skippable: Bool = false) -> Survey {
        guard let attributedIntro = try? AttributedString(markdown: introPrompt,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)),
              let markdownAcknowledgments: AttributedString = try? AttributedString(markdown: acknowledgments,
                  options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        else {
            return Survey(id: surveyId, intro: introPrompt, questions: questions, acknowledgments: acknowledgments, skippable: skippable)
        }

        return Survey(id: surveyId, intro: attributedIntro, questions: questions, acknowledgments: markdownAcknowledgments, skippable: skippable)
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
        case .multipleChoice(let associatedOptions),
                .singleChoice(options: let associatedOptions):
            
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
    
    public static func createQuestion(withId questionId: String, prompt: String,
                                      type: QuestionType) -> Question? {
        Question(id: questionId, prompt: prompt, type: type)
    }
}

//MARK: Question options
public struct QuestionOption: Identifiable {
    public let id: String
    let description: String
    let allowsText: Bool
    
    public init(id: String, description: String, allowsText: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyOptionDescription }
        self.id = id
        self.description = description
        self.allowsText = allowsText
    }
}
