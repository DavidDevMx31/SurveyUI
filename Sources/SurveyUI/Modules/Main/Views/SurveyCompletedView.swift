//
//  SurveyCompletedView.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

struct SurveyCompletedView: View {
    let completionContent: SurveyCompletionContent
    var onFinishTapped: () -> Void
    
    init(content: SurveyCompletionContent, _ completion: @escaping () -> Void) {
        self.completionContent = content
        self.onFinishTapped = completion
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 48) {
            Text(completionContent.title)
                .font(SurveyUIThemeManager.shared.surveyIntroFont)
            
            if completionContent.imageName != nil {
                Image(completionContent.imageName!)
                    .resizable()
                    .scaledToFit()
            }
            
            Text(completionContent.description)
                .font(SurveyUIThemeManager.shared.bodyFont)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .transition(.slide)
        .safeAreaInset(edge: .bottom) {
            Button {
                onFinishTapped()
            } label: {
                Label(completionContent.buttonTitle, systemImage: "checkmark.circle")
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
            }
            .tint(Color.blue)
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SurveyCompletedView(
        content: SurveyCompletionContent.example) {
        debugPrint("Tapped CTA button")
    }
}
