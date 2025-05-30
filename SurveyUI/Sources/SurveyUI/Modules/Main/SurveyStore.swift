//
//  SurveyStore.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import Foundation

final class SurveyStore {
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
    var selectionStrategy: MultipleOptionQuestionStrategy? {
        switch currentQuestion.type {
        case .singleSelection(_):
            return SingleSelectionStrategy(currentQuestion: currentQuestion)
        case .multipleSelection(_):
            return MultipleSelectionStrategy(currentQuestion: currentQuestion)
        case .open(_):
            return nil
        }
    }
    private(set) var responses: [String:QuestionResult] = [:]
    
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
        if let error = validateCurrentResponse() {
            errorDetails = error
            return
        }
        
        guard currentQuestionIndex < survey.questions.count - 1 else {
            surveyCompleted = true
            return
        }
        
        errorDetails = nil
        currentQuestionIndex += 1
        currentResponse = responses[currentQuestion.id] ?? QuestionResult(questionId: currentQuestion.id)
    }
    
    private func limitComment(_ comment: String, maxChars: Int = 100) -> String {
        String(comment.trimmingCharacters(in: .whitespacesAndNewlines).prefix(100))
    }
    
    private func validateCurrentResponse() -> SurveyError? {
        guard let selectedOptions = currentResponse.selectedOptionsId,
              !selectedOptions.isEmpty else { return SurveyError.noSelection }
        
        if let textOption = currentQuestion.allowTextOption {
            if selectedOptions.contains(textOption.id) {
                guard let comments = currentResponse.comments,
                      !comments.isEmpty else { return SurveyError.textIsEmpty }
            }
        }
        
        return nil
    }
}

extension SurveyStore: MultipleOptionQuestionProtocol {
    func selectOption(_ id: String) {
        guard let strategy = selectionStrategy else { return }
        let newResponse = strategy.selectId(id , currentResult: currentResponse)
        responses[currentQuestion.id] = newResponse
        currentResponse = newResponse
    }
    
    func addComment(_ comment: String) {
        guard let strategy = selectionStrategy else { return }
        let addCommentResult = strategy.appendComment(comment, withOptionIds: currentResponse.selectedOptionsId)
        switch addCommentResult {
        case .success(let newResponse):
            responses[currentQuestion.id] = newResponse
            currentResponse = newResponse
        case .failure(let failure):
            errorDetails = failure
        }
    }
}
