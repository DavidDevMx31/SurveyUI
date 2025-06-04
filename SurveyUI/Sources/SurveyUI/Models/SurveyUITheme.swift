//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 03/06/25.
//

import SwiftUI

public protocol SurveyUITheme {
    var backgroundColor: Color? { get }
    var foregroundColor: Color? { get }
    
    var surveyIntroFont: Font { get }
    var questionFont: Font { get }
    var calloutFont: Font { get }
    var bodyFont: Font { get }
    
    var optionBackgroundColor: Color { get }
    var unselectedOptionForegroundColor: Color { get }
    var selectedOptionForegroundColor: Color { get }
}

public class SurveyThemeManager {
    @MainActor public static let shared: SurveyUITheme = DefaultSurveyUITheme()
}

struct DefaultSurveyUITheme: SurveyUITheme {
    var backgroundColor: Color? = Color("BackgroundColor", bundle: .module)
    var foregroundColor: Color? = Color("ForegroundColor", bundle: .module)
    
    var surveyIntroFont = Font.title2
    var questionFont = Font.title3
    var calloutFont: Font = Font.callout
    var bodyFont: Font = Font.body
    
    var optionBackgroundColor = Color.blue
    var unselectedOptionForegroundColor = Color.blue
    var selectedOptionForegroundColor = Color.white
}
