//
//  SurveyQuestionView.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

struct SurveyQuestionView: View {
    @ObservedObject var store: SurveyStore
    
    var body: some View {
        ScrollView {
            Text(store.currentQuestion.prompt)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.body)
                .padding(.vertical, 24)
                .padding(.horizontal, 8)
                .animation(.linear, value: store.currentQuestionIndex)
            
            switch store.currentQuestion.type {
            case .singleSelection(options: _):
                MultipleOptionQuestionView(store: store)
            case .multipleSelection(options: _),
                    .open(placeholder: _):
                EmptyView()
            }
        }
        .animation(.default, value: store.currentQuestionIndex)
    }
}

#Preview {
    SurveyQuestionView(store: .init(survey: Survey.getSurveyExample()))
}
