//
//  QuestionOptionButton.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

struct QuestionOptionButton: View {
    let title: String
    let action: () -> Void
    private let opacity: CGFloat
    private let foregroundColor: Color
    private let iconName: String
    
    init(title: String, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.iconName = isSelected ? "checkmark.circle" : "circle"
        self.opacity = isSelected ? 1.0 : 0.2
        self.foregroundColor = isSelected ? .white : .gray
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: iconName)
                    .padding(.all, 8)
                
                Text(title)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.7)
            }
            .font(.body)
            .foregroundColor(foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.blue.opacity(opacity),
                            lineWidth: 2.0)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(opacity))
                    )
            )
            
        }

    }
}

#Preview {
    QuestionOptionButton(title: "Texto del botón") {
        debugPrint("Tapped option")
    }
}
