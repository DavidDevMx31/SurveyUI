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
    
    var onSkipTapped: () -> Void
    
    init(store: SurveyStore, onSkipTapped: @escaping () -> Void) {
        self.store = store
        self.onSkipTapped = onSkipTapped
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
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
            
            if store.survey.skippable {
                SkipSurveyButton {
                    onSkipTapped()
                }
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    SurveyFooterView(store: .init(survey: Survey.getSurveyExample())) {
        debugPrint("Skip button tapped")
    }
}
