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
                .font(SurveyUIThemeManager.shared.questionFont)
                .padding(.vertical, 24)
                .padding(.horizontal, 8)
                .animation(.linear, value: store.currentQuestionIndex)
            
            switch store.currentQuestion.type {
            case .singleChoice(options: _), .multipleChoice(options: _):
                MultipleOptionQuestionView(store: store)
            case .open(placeholder: _):
                EmptyView()
            case .categorySelection(options: let options, maxSelectableItems: let maxSelectableItems):
                MultiSelectionQuestionScreen(store: store, options: options, maxSelectableItems: maxSelectableItems)
            }
        }
        .animation(.default, value: store.currentQuestionIndex)
    }
}

#Preview {
    SurveyQuestionView(store: .init(survey: Survey.getSurveyExample()))
}
