//
//  SurveyFooterView.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

struct SurveyFooterView: View {
    @ObservedObject var store: SurveyStore
    
    private var disableNextButton: Bool {
        guard let selectedOptions = store.currentResponse.selectedOptionsId,
              !selectedOptions.isEmpty else {
            return true
        }

        if let allowsTextOption = store.currentQuestion.allowTextOption {
            if selectedOptions.contains(allowsTextOption.id) {
                guard let comment = store.currentResponse.comments,
                      !comment.isEmpty else {
                    return true
                }
            } //else { return true }
        }
        
        return false
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 96) {
            PreviousQuestionButton {
                store.previousQuestion()
            }
            .disabled(store.currentQuestionIndex == 0)
            
            NextQuestionButton {
                store.nextQuestion()
            }
            .disabled(disableNextButton)
            
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    SurveyFooterView(store: .init(survey: Survey.getSurveyExample()))
}
