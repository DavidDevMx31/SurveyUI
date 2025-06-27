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
    
    init(_ onTappedCompletion: @escaping () -> Void) {
        self.onTappedCompletion = onTappedCompletion
    }
    
    var body: some View {
        Button {
            onTappedCompletion()
        } label: {
            Label("Anterior", systemImage: "arrow.left.circle")
                .foregroundColor(isEnabled ? Color.blue : Color(uiColor: UIColor.systemGray5))
        }
    }
}

#Preview {
    PreviousQuestionButton(){ debugPrint("PreviousQuestionButton tapped")}
}
