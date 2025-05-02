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
    @Published var surveyCompleted = false
    @Published var currentResponse = QuestionResult(questionId: "")
    @Published private(set) var errorDetails: SurveyError?
    
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
    
    //MARK: Previous or next question
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
        currentResponse = responses[currentQuestion.id] ?? QuestionResult(questionId: currentQuestion.id)
    }
    
    func nextQuestion() {
        guard currentQuestionIndex < survey.questions.count - 1 else {
            surveyCompleted = true
            return
        }
    }
    
    private func limitComment(_ comment: String, maxChars: Int = 100) -> String {
        String(comment.trimmingCharacters(in: .whitespacesAndNewlines).prefix(100))
    }
}

extension SurveyStore: SingleSelectionVMProtocol {
    func selectOption(_ id: String) {
        let newResponse = QuestionResult(questionId: currentQuestion.id, selectedId: id)
        responses[currentQuestion.id] = newResponse
        currentResponse = newResponse
    }
    
    func addComment(_ comment: String) {
        guard let allowsTextOption = currentQuestion.allowTextOption else {
            return
        }
        
        let userComment = limitComment(comment)
        guard !userComment.isEmpty else {
            errorDetails = SurveyError.textIsEmpty
            return
        }

        var newResponse = QuestionResult(questionId: currentQuestion.id)
        if let selectedOptions = currentResponse.selectedOptionsId {
            if selectedOptions.contains(allowsTextOption.id) {
                newResponse.setResponse(selectedOptionsId: selectedOptions, comments: userComment)
                responses[currentQuestion.id] = newResponse
                currentResponse = newResponse
            }
        }
    }
}
