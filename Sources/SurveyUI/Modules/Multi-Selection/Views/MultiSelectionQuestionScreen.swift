//
//  MultiSelectionQuestionScreen.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/10/26.
//

import SwiftUI

//MARK: Screen container
struct MultiSelectionQuestionScreen: View {
    let options: [MultiSelectionOption] = Array(repeating: MultiSelectionOption.example, count: 10)
    
    var body: some View {
        List(options) { option in
            rowForOption(option)
        }
    }
    
    @ViewBuilder
    private func rowForOption(_ option: MultiSelectionOption) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(option.emoji)
            Text(option.description)
            Spacer()
            if option.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.green)
                    .font(SurveyUIThemeManager.shared.calloutFont)
            }
        }
        .font(SurveyUIThemeManager.shared.bodyFont)
    }
}

//MARK: Sub views

#Preview {
    MultiSelectionQuestionScreen()
}

//MARK: Model
struct MultiSelectionOption: Identifiable {
    let id: String
    let description: String
    let emoji: String
    let isSelected: Bool
    
    static let example = MultiSelectionOption(id: UUID().uuidString, description: "Ejemplo", emoji: emojiExamples.randomElement()!, isSelected: true)
    static let emojiExamples = ["🫰🏻", "👀", "📱", "⏳", "📖"]
}
