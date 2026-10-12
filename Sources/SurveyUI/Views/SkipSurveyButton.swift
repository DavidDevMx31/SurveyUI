//
//  SwiftUIView.swift
//  SurveyUI
//
//  Created by David Mendoza on 07/10/26.
//

import SwiftUI

struct SkipSurveyButton: View {
    var onSkipTapped: (() -> Void)
    
    var body: some View {
        Button {
            onSkipTapped()
        } label: {
            Text("Ahora no")
                .underline()
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .font(.subheadline)

    }
}

#Preview {
    SkipSurveyButton() {
        debugPrint("Skip button tapped")
    }
}
