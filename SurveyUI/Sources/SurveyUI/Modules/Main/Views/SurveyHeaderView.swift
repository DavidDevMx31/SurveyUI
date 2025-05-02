//
//  SurveyHeaderView.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

struct SurveyHeaderView: View {
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Divider()
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            
            Text("Pregunta \(currentQuestion) de \(totalQuestions)")
                .lineLimit(1)
                .layoutPriority(1)
                .animation(.default, value: currentQuestion)
            
            Divider()
                .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        .frame(height: 40)
        .font(.callout)
        .padding(.horizontal)
    }

}

#Preview {
    SurveyHeaderView(currentQuestion: 1, totalQuestions: 4)
}
