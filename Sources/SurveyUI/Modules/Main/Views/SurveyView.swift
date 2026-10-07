//
//  SurveyView.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import SwiftUI

public struct SurveyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store: SurveyStore
    private var onCompletedSurvey: (SurveyResult) -> Void
    private let canSkip: Bool
    
    public init(survey: Survey,
                onCompleted: @escaping (SurveyResult)->Void) {
        self._store = StateObject(wrappedValue: SurveyStore(survey: survey))
        self.onCompletedSurvey = onCompleted
        self.canSkip = survey.skippable
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if store.surveyCompleted {
                SurveyCompletedView(acknowledgments: store.survey.acknowledgments) {
                    let results = store.getSurveyResults()
                    onCompletedSurvey(results)
                }
            } else {
                SurveyHeaderView(currentQuestion: store.currentQuestionIndex + 1, totalQuestions: store.survey.questions.count)
                    .animation(.linear, value: store.currentQuestionIndex)
                
                if store.currentQuestionIndex == 0 {
                    SurveyIntroView(introText: store.survey.intro)
                }
                
                SurveyQuestionView(store: store)
                    .alert(isPresented: store.foundError, error: store.errorDetails, actions: { _ in
                        Text("Ok")
                    }, message: { error in
                        Text(error.recoverySuggestion ?? "")
                    })
                
                SurveyFooterView(store: store, canSkip: canSkip) {
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundColor(SurveyUIThemeManager.shared.foregroundColor)
        .background {
            if SurveyUIThemeManager.shared.backgroundColor == nil {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
            } else {
                SurveyUIThemeManager.shared.backgroundColor
                    .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
}

#Preview {
    SurveyView(survey: Survey.getSurveyExample()) { _ in
        debugPrint("Survey completed")
    }
}
