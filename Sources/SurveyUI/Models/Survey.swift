//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

//MARK: Survey model
public struct Survey: Identifiable {
    public var id: String
    var intro: AttributedString
    var questions: [Question]
    var completionContent: SurveyCompletionContent
    let skippable: Bool
    
    public init(id: String, intro: String, questions: [Question],
                completionContent: SurveyCompletionContent, skippable: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        
        guard let markdownIntro = try? AttributedString(markdown: intro, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) else { throw SurveyDefinitionError.emptyDescription }
        
        self.id = id
        self.intro = markdownIntro
        self.questions = questions
        self.completionContent = completionContent
        self.skippable = skippable
    }
    
    public init(id: String, intro: AttributedString, questions: [Question],
                completionContent: SurveyCompletionContent, skippable: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        guard intro.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        
        self.id = id
        self.intro = intro
        self.questions = questions
        self.completionContent = completionContent
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
        
        let categoryQuestionOptions = [
            try! CategoryOption(id: "co-1", description: "Opción 1", emoji: "🕹️"),
            try! CategoryOption(id: "co-2", description: "Opción 2", emoji: "⏰"),
            try! CategoryOption(id: "co-3", description: "Opción 3", emoji: "⚔️"),
        ]
        
        let questions = [try! Question(id: "1", prompt: "Aquí va el texto de la pregunta 1",
                                  type: .singleChoice(options: questionOneOptions)),
                         try! Question(id: "2", prompt: "Este es el texto de la pregunta 2",
                                  type: .singleChoice(options: questionTwoOptions)),
                         try! Question(id: "quest-3", prompt: "Esta es una pregunta con múltiples categorías para elegir", type: .categorySelection(options: categoryQuestionOptions, maxSelectableItems: 2))
        ]
        
        let markdownIntro: AttributedString = try! AttributedString(
            markdown: "**Esta es la introducción**\n\nPuedes usar texto normal o con atributos."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        return try! Survey(id: UUID().uuidString, intro: markdownIntro,
                           questions: questions as! [Question], completionContent: SurveyCompletionContent.example)
    }
    
}

//MARK: Survey completion model
public struct SurveyCompletionContent: Sendable {
    public let title: AttributedString
    let description: AttributedString
    let imageName: String?
    let buttonTitle: String
    
    public init(attributedTitle: AttributedString, attributedDescription: AttributedString,
                imageName: String?, buttonTitle: String) throws {
        guard attributedTitle.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard attributedDescription.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard buttonTitle.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        
        self.title = attributedTitle
        self.description = attributedDescription
        self.imageName = imageName
        self.buttonTitle = buttonTitle
    }
    
    public init(title: String, description: String, imageName: String?, buttonTitle: String) throws {
        guard title.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard buttonTitle.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        
        guard let markdownTitle = try? AttributedString(markdown: title, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) else { throw SurveyDefinitionError.emptyDescription }
        guard let markdownDescription = try? AttributedString(markdown: description, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) else { throw SurveyDefinitionError.emptyDescription }
        
        self.title = markdownTitle
        self.description = markdownDescription
        self.imageName = imageName
        self.buttonTitle = buttonTitle
    }
    
    public static let example = try! SurveyCompletionContent(title: "Survey completed", description: "Thank you for participating", imageName: nil, buttonTitle: "Done")
}
