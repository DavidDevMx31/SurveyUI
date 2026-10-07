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
    
    let canSkip: Bool
    var onSkipTapped: (() -> Void)
    
    init(store: SurveyStore, canSkip: Bool, onSkipTapped: @escaping (() -> Void)) {
        self.store = store
        self.canSkip = canSkip
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
            
            if canSkip {
                SkipSurveyButton {
                    onSkipTapped()
                }
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    SurveyFooterView(store: .init(survey: Survey.getSurveyExample()), canSkip: false) {
        debugPrint("Skip button tapped")
    }
}
