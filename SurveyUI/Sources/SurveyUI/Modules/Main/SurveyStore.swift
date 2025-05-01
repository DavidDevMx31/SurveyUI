//
//  SurveyStore.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

final class SurveyStore: ObservableObject {
    //MARK: Published properties
    @Published var currentQuestionIndex: Int = 0
    
    //MARK: Properties
    let survey: Survey
    var currentQuestion: Question {
        survey.questions[currentQuestionIndex]
    }
    var responses: [String:QuestionResult] = [:]
    
    //MARK: Initializer
    init(survey: Survey) {
        self.survey = survey
        survey.questions.forEach { question in
            responses[question.id] = QuestionResult(questionId: question.id)
        }
    }
}
