//
//  SurveyView.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var store: SurveyStore
    
    public init(survey: Survey) {
        self._store = StateObject(wrappedValue: SurveyStore(survey: survey))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if store.surveyCompleted {
                EmptyView()
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
        
    }
}

#Preview {
    SurveyView(survey: Survey.getSurveyExample())
}
