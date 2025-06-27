//
//  NextQuestionButton.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

struct NextQuestionButton: View {
    @Environment(\.isEnabled) var isEnabled
        
    private var onTappedCompletion: () -> Void
    
    init(_ onTappedCompletion: @escaping () -> Void) {
        self.onTappedCompletion = onTappedCompletion
    }
    
    var body: some View {
        Button {
            onTappedCompletion()
        }
        label: {
            Label("Siguiente",
                  systemImage: "arrow.right.circle")
            .foregroundColor(isEnabled ? Color.blue : Color(uiColor: UIColor.systemGray5))
        }
    }
}

#Preview {
    NextQuestionButton { debugPrint("Tapped NextQuestionButton") }
}
