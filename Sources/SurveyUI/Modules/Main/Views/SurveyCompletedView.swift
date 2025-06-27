//
//  SurveyCompletedView.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

struct SurveyCompletedView: View {
    let acknowledgments: AttributedString
    var onFinishTapped: () -> Void
    
    init(acknowledgments: AttributedString, _ completion: @escaping () -> Void) {
        self.acknowledgments = acknowledgments
        self.onFinishTapped = completion
    }
    
    var body: some View {
        Group {
            Text(acknowledgments)
                .font(SurveyUIThemeManager.shared.surveyIntroFont)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .transition(.slide)
            
            Button {
                onFinishTapped()
            } label: {
                Label("Finalizar encuesta", systemImage: "checkmark.circle")
                    .foregroundColor(Color.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SurveyCompletedView(acknowledgments: "Ejemplo") { debugPrint("Completed survey tapped") }
}
