//
//  SurveyStoreProtocol.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/05/25.
//

import Foundation

//MARK: Protocols
protocol SurveyStoreProtocol: ObservableObject {
    var currentQuestionIndex: Int { get }
    var currentQuestion: Question { get }
    var responses: [String:QuestionResult] { get }
    var currentResponse: QuestionResult { get }
}

protocol MultipleOptionQuestionProtocol: SurveyStoreProtocol {
    func selectOption(_ id: String)
    func addComment(_ comment: String)
}
