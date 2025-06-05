//
//  CommentTextField.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/05/25.
//

import Combine
import SwiftUI

struct CommentTextField: View {
    let placeholderText: String
    @Binding var commentText: String
    
    private let maxChars: Int = 100
    private var remainingChars: Int {
        return maxChars - commentText.count
    }
    
    private var remainingCharTextColor: Color {
        if remainingChars > 20 { return Color(uiColor: UIColor.systemGray3) }
        else if remainingChars <= 20 && remainingChars >= 10 { return Color.yellow }
        else { return Color.red}
    }
    
    let onSubmitHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            TextField(placeholderText, text: $commentText)
                .frame(minHeight: 40)
                .padding(.horizontal, 8)
                .textFieldStyle(OutlinedTextFieldStyle())
                .font(SurveyUIThemeManager.shared.bodyFont)
                .onReceive(Just(commentText)) { _ in limitText(maxChars) }
                .onSubmit {
                    onSubmitHandler()
                }
            
            Text("\(remainingChars)/\(maxChars)")
                .font(.callout)
                .foregroundColor(remainingCharTextColor)
        }
    }
    
    private func limitText(_ limit: Int) {
        if commentText.count > limit {
            commentText = String(commentText.prefix(limit))
        }
    }
}

#Preview {
    CommentTextField(placeholderText: "Placeholder text", commentText: .constant("")) { debugPrint("CommentTextField completion")}
}
