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
        !store.currentValidationState.canAdvance
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
