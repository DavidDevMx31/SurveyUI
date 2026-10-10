//
//  MultiSelectionQuestionScreen.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/10/26.
//

import SwiftUI

//MARK: Screen container
struct CategorySelectionScreen: View {
    @ObservedObject var store: SurveyStore
    let options: [CategoryOption]
    let maxSelectableItems: Int
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            ForEach(options) { option in
                rowForOption(option)
            }
        }
        if let errorMessage = store.currentValidationState.message {
            Text(errorMessage)
                .foregroundStyle(.red)
                .font(SurveyUIThemeManager.shared.calloutFont)
        }
    }
    
    @ViewBuilder
    private func rowForOption(_ option: CategoryOption) -> some View {
        var isSelected: Bool {
            store.currentResponse.selectedOptionsId?.contains(option.id) == true
        }
        
        HStack(alignment: .center) {
            if option.emoji != nil {
                Text(option.emoji!)
                    .layoutPriority(1)
            }
            Text(option.description)
        }
        .font(SurveyUIThemeManager.shared.bodyFont)
        .foregroundStyle(isSelected ? SurveyUIThemeManager.shared.selectedOptionForegroundColor : SurveyUIThemeManager.shared.unselectedOptionForegroundColor)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(SurveyUIThemeManager.shared.optionBackgroundColor.opacity(isSelected ? 1.0 : 0.2), lineWidth: 2.0)
                .background(SurveyUIThemeManager.shared.optionBackgroundColor.opacity(isSelected ? 1.0 : 0.2))
                .clipped()
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            self.onOptionTap(option)
        }
    }
    
    private func onOptionTap(_ option: CategoryOption) {
        store.selectOption(option.id)
    }
}

/*
#Preview {
    MultiSelectionQuestionScreen()
}
*/
