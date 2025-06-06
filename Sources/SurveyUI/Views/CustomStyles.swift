//
//  SwiftUIView 2.swift
//  SurveyUI
//
//  Created by David Mendoza on 05/05/25.
//

import SwiftUI

struct OutlinedTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.gray, lineWidth: 2)
            })
    }
    
}
