//
//  SwiftUIView.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

//MARK: View
struct MultipleOptionQuestionView<T: MultipleOptionQuestionProtocol>: View {
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
    
    var body: some View {
        ForEach(store.currentQuestion.options) { option in
            QuestionOptionButton(title: option.description,
                    isSelected: selectedOptions.contains(option.id)) {
                withAnimation {
                    store.selectOption(option.id)
                    //if !option.allowsText { comments = "" }
                    comments = store.currentResponse.comments ?? ""
                }
            }
            .padding(.vertical, 4)
            .scaleEffect(selectedOptions.contains(option.id) ? 0.95 : 0.9)
        }
        
        if showTextField {
            CommentTextField(placeholderText: "Comparte tus comentarios",
                             commentText: $comments) {
                isInputActive = false
                store.addComment(comments)
                comments = store.currentResponse.comments ?? ""
            }
            .transition(.opacity)
        }
    }
}

/*
#Preview {
    MultipleOptionQuestionView(store: )
}
*/
