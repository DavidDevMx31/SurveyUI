//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

//MARK: Question result
public struct SurveyResult {
    public let surveyId: String
    public var answers: [QuestionResult]
    
    init(surveyId: String, answers: [QuestionResult]) {
        self.surveyId = surveyId
        self.answers = answers
    }
}

public struct QuestionResult {
    public let questionId: String
    public var selectedOptionsId: [String]?
    public var comments: String?
    
    internal init(questionId: String) {
        self.questionId = questionId
        self.selectedOptionsId = nil
        self.comments = nil
    }
    
    internal init(questionId: String, selectedId: String) {
        self.questionId = questionId
        self.selectedOptionsId = [selectedId]
        self.comments = nil
    }
    
    internal init(questionId: String, comment: String) {
        self.questionId = questionId
        self.selectedOptionsId = nil
        self.comments = comment
    }
    
    internal mutating func setResponse(selectedOptionsId: [String]?, comments: String?) {
        self.selectedOptionsId = selectedOptionsId
        self.comments = comments
        debugPrint(self)
    }
}
