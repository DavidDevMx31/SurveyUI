//
//  PreviousQuestionButton.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

struct PreviousQuestionButton: View {
    @Environment(\.isEnabled) var isEnabled
    var onTappedCompletion: (() -> Void)
    
    private var buttonOpacity: CGFloat {
        if isEnabled { return 0.8 }
        return 0.6
    }
    
    init(_ onTappedCompletion: @escaping () -> Void) {
        self.onTappedCompletion = onTappedCompletion
    }
    
    var body: some View {
        Button {
            onTappedCompletion()
        } label: {
            Label("Anterior", systemImage: "arrow.left.circle")
                .foregroundColor(isEnabled ? Color.black.opacity(buttonOpacity) : Color.black.opacity(buttonOpacity))
        }
        .tint(Color(uiColor: UIColor.systemGray3))
        .buttonStyle(.borderedProminent)
         
    }
}

#Preview {
    PreviousQuestionButton(){ debugPrint("PreviousQuestionButton tapped")}
}
