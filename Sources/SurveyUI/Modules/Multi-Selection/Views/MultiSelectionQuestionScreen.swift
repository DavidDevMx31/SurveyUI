//
//  MultiSelectionQuestionScreen.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/10/26.
//

import SwiftUI

//MARK: Screen container
struct MultiSelectionQuestionScreen: View {
    @State private var question = MultiSelectionQuestion.example
    
    var body: some View {
        List {
            Section {
                ForEach(question.options) { option in
                    rowForOption(option)
                }
            } footer: {
                if let error = question.errorMessage {
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                        .font(SurveyUIThemeManager.shared.calloutFont)
                }
            }

        }
    }
    
    @ViewBuilder
    private func rowForOption(_ option: MultiSelectionOption) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(option.emoji)
            Text(option.description)
            Spacer()
            if question.selectedOptions.contains(option.id) {
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
    
    private func onOptionTap(_ option: MultiSelectionOption) {
        question.select(optionId: option.id)
    }
}

//MARK: Sub views

#Preview {
    MultiSelectionQuestionScreen()
}

//MARK: Model
struct MultiSelectionOption: Identifiable, Equatable {
    let id: String
    let description: String
    let emoji: String
    
    static func ==(lhs: MultiSelectionOption, rhs: MultiSelectionOption) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let example = MultiSelectionOption(id: UUID().uuidString, description: "Ejemplo", emoji: emojiExamples.randomElement()!)
    static let emojiExamples = ["🫰🏻", "👀", "📱", "⏳", "📖"]
}

struct MultiSelectionQuestion: Identifiable {
    let id: String
    let prompt: String
    var options: [MultiSelectionOption]
    
    let maxSelectableItems: Int
    var selectedOptions: [MultiSelectionOption.ID] = []
    
    var errorMessage: MultiSelectionError? {
        if selectedOptions.count > maxSelectableItems {
            return .invalidMaxSelectableItems(maxElements: maxSelectableItems)
        }
        return nil
    }
    
    static let example = MultiSelectionQuestion(id: UUID().uuidString,
                    prompt: "Esta es una pregunta de ejemplo con múltiples opciones",
                    options: [
                        MultiSelectionOption(id: "1", description: "Ejemplo 1", emoji: "📲"),
                        MultiSelectionOption(id: "2", description: "Ejemplo 2", emoji: "⏳"),
                        MultiSelectionOption(id: "3", description: "Ejemplo 3", emoji: "📖")],
                                                maxSelectableItems: 2)
    
    mutating func select(optionId: MultiSelectionOption.ID) {
        //Valida si existe la opcion
        guard options.first(where: { $0.id == optionId }) != nil else { return }
        //Vemos si esta seleccionada previamente
        if selectedOptions.contains(optionId) {
            selectedOptions.removeAll(where: {$0 == optionId })
        } else {
            selectedOptions.append(optionId)
        }
    }
}

enum MultiSelectionError: Error {
    case invalidMaxSelectableItems(maxElements: Int)

    var localizedDescription: String {
        switch self {
        case .invalidMaxSelectableItems(let maxElements):
            return "Selecciona hasta \(maxElements) elementos"
        }
    }
}
