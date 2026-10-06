//
//  MultiSelectionQuestionScreen.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/10/26.
//

import SwiftUI

//MARK: Screen container
struct MultiSelectionQuestionScreen: View {
    @ObservedObject var store: SurveyStore
    let options: [CategoryOption]
    let maxSelectableItems: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(options) { option in
                rowForOption(option)
                Divider()
            }
            
            if let errorMessage = store.currentValidationState.message {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(SurveyUIThemeManager.shared.calloutFont)
            }
        }
    }
    
    @ViewBuilder
    private func rowForOption(_ option: CategoryOption) -> some View {
        HStack(alignment: .center, spacing: 12) {
            if option.emoji != nil { Text(option.emoji!) }
            Text(option.description)
            Spacer()
            if store.currentResponse.selectedOptionsId?.contains(option.id) == true {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.green)
                    .font(SurveyUIThemeManager.shared.calloutFont)
            }
        }
        .font(SurveyUIThemeManager.shared.bodyFont)
        .contentShape(Rectangle())
        .onTapGesture {
            self.onOptionTap(option)
        }
    }
    
    private func onOptionTap(_ option: CategoryOption) {
        store.selectOption(option.id)
    }
}

//MARK: Sub views
/*
#Preview {
    MultiSelectionQuestionScreen()
}
*/
