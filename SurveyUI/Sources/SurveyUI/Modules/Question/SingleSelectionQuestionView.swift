//
//  SwiftUIView.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

//MARK: Protocols
protocol SurveyVMProtocol: ObservableObject {
    var currentQuestionIndex: Int { get }
    var currentQuestion: Question { get }
    var responses: [String:QuestionResult] { get }
    var currentResponse: QuestionResult { get }
}

protocol SingleSelectionVMProtocol: SurveyVMProtocol {
    func selectOption(_ id: String)
    func addComment(_ comment: String)
}

//MARK: View
struct SingleSelectionQuestionView<T: SingleSelectionVMProtocol>: View {
    @ObservedObject var store: T
    @State private var comments: String
    @FocusState private var isInputActive: Bool
    
    init(store: T) {
        self.store = store
        self.comments = store.currentResponse.comments ?? ""
    }
    
    private var selectedOptions: [String] {
        return store.currentResponse.selectedOptionsId ?? []
    }
    
    private var allowsTextOptionId: String? {
        store.currentQuestion.allowTextOption?.id
    }
    
    private var showTextField: Bool {
        if let allowsTextOptionId = allowsTextOptionId {
            if selectedOptions.contains(where: { $0 == allowsTextOptionId }) {
                return true
            }
        }
        return false
    }
    
    private var disableTextField: Bool {
        if let allowsTextId = allowsTextOptionId {
            return !selectedOptions.contains(allowsTextId)
        }
        return true
    }
    
    var body: some View {
        ForEach(store.currentQuestion.options) { option in
            QuestionOptionButton(title: option.description,
                    isSelected: selectedOptions.contains(option.id)) {
                withAnimation {
                    store.selectOption(option.id)
                    if !option.allowsText { comments = "" }
                }
            }
            .padding(.vertical, 4)
            .scaleEffect(selectedOptions.contains(option.id) ? 0.95 : 0.9)
        }
        
    }
}

/*
#Preview {
    SingleSelectionQuestionView(store: )
}
*/
