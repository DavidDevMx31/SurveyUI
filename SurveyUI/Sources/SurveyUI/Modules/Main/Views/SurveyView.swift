//
//  SurveyView.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var store: SurveyStore
    private var onCompletedSurvey: (SurveyResult) -> Void
    
    public init(survey: Survey,
                onCompleted: @escaping (SurveyResult)->Void) {
        self._store = StateObject(wrappedValue: SurveyStore(survey: survey))
        self.onCompletedSurvey = onCompleted
    }
    
    var body: some View {
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
                
                SurveyFooterView(store: store)
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
