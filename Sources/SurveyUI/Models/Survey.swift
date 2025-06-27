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
    
    public static func getSurveyExample() -> Survey {
        let questionOneOptions = [
            QuestionOption(id: "1", description: "Opción 1"),
            QuestionOption(id: "2", description: "Opción 2"),
            QuestionOption(id: "3", description: "Opción 3"),
            QuestionOption(id: "4", description: "Opción 4")
        ]
        
        let questionTwoOptions = [
            QuestionOption(id: "5", description: "Opción 5"),
            QuestionOption(id: "6", description: "Opción 6"),
            QuestionOption(id: "7", description: "Opción 7"),
            QuestionOption(id: "8", description: "Otro", allowsText: true)
        ]
        
        let questions = [Question(id: "1", prompt: "Aquí va el texto de la pregunta 1",
                                  type: .singleSelection(options: questionOneOptions)),
                         Question(id: "2", prompt: "Este es el texto de la pregunta 2",
                                                   type: .singleSelection(options: questionTwoOptions))
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
                                    introPrompt: String = "", acknowledgments: String = "") -> Survey {
        guard let attributedIntro = try? AttributedString(markdown: introPrompt,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)),
              let markdownAcknowledgments: AttributedString = try? AttributedString(markdown: acknowledgments,
                  options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        else {
            return Survey(id: surveyId, intro: introPrompt, questions: questions, acknowledgments: acknowledgments)
        }

        return Survey(id: surveyId, intro: attributedIntro, questions: questions, acknowledgments: markdownAcknowledgments)
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
    
    public init(id: String, description: String, allowsText: Bool = false) {
        self.id = id
        self.description = description
        self.allowsText = allowsText
    }
}
