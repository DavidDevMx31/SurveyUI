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
    
    public init(id: String, intro: AttributedString, questions: [Question],
                completionContent: SurveyCompletionContent, skippable: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        
        self.id = id
        self.intro = intro
        self.questions = questions
        self.completionContent = completionContent
        self.skippable = skippable
    }
    
    public init(id: String, markdownIntro intro: String, questions: [Question],
                completionContent: SurveyCompletionContent, skippable: Bool = false) throws {
        guard id.validateRequired() else { throw SurveyDefinitionError.emptyId }
        
        guard let attributedIntro = try? AttributedString(markdown: intro, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) else { throw SurveyDefinitionError.emptyDescription }
        
        self.id = id
        self.intro = attributedIntro
        self.questions = questions
        self.completionContent = completionContent
        self.skippable = skippable
    }
    
    
    public static func getSurveyExample() -> Survey {
        let questionOneOptions = [
            try! QuestionOption(id: "1", description: "Option 1"),
            try! QuestionOption(id: "2", description: "Option 2"),
            try! QuestionOption(id: "3", description: "Option 3"),
            try! QuestionOption(id: "4", description: "Option 4")
        ]
        
        let questionTwoOptions = [
            try! QuestionOption(id: "5", description: "Option 5"),
            try! QuestionOption(id: "6", description: "Option 6"),
            try! QuestionOption(id: "7", description: "Option 7"),
            try! QuestionOption(id: "8", description: "Other", allowsText: true)
        ]
        
        let categoryQuestionOptions = [
            try! CategoryOption(id: "co-1", description: "Option 1", emoji: "🕹️"),
            try! CategoryOption(id: "co-2", description: "Option 2", emoji: "⏰"),
            try! CategoryOption(id: "co-3", description: "Option 3", emoji: "⚔️"),
        ]
        
        let questions = [try! Question(id: "1", prompt: "This is the text for question 1",
                                  type: .singleChoice(options: questionOneOptions)),
                         try! Question(id: "2", prompt: "This is the text for question 2",
                                  type: .singleChoice(options: questionTwoOptions)),
                         try! Question(id: "quest-3", prompt: "Choose from multiple categories", type: .categorySelection(options: categoryQuestionOptions, maxSelectableItems: 2))
        ]
        
        let markdownIntro: AttributedString = try! AttributedString(
            markdown: "**This is the introduction**\n\nYou can use plain text or formatted text."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        return try! Survey(id: UUID().uuidString, intro: markdownIntro,
                           questions: questions, completionContent: SurveyCompletionContent.example)
    }
    
}

//MARK: Survey completion model
public struct SurveyCompletionContent: Sendable {
    public let title: AttributedString
    let description: AttributedString
    let imageName: String?
    let buttonTitle: String
    
    public init(title: AttributedString, description: AttributedString,
                imageName: String?, buttonTitle: String) throws {
        guard title.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard description.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        guard buttonTitle.validateRequired() else { throw SurveyDefinitionError.emptyDescription }
        
        self.title = title
        self.description = description
        self.imageName = imageName
        self.buttonTitle = buttonTitle
    }
    
    public init(markdownTitle title: String, markdownDescription description: String,
                imageName: String?, buttonTitle: String) throws {
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
