//
//  SurveyIntroView.swift
//  SurveyUI
//
//  Created by David Mendoza on 02/05/25.
//

import SwiftUI

struct SurveyIntroView: View {
    let introText: AttributedString
    
    var body: some View {
        Text(introText)
            .layoutPriority(1)
            .font(SurveyUIThemeManager.shared.surveyIntroFont)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
    }
}
#Preview {
    SurveyIntroView(introText: AttributedString("Texto de introducción de la encuesta."))
}
