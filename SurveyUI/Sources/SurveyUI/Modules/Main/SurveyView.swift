//
//  SurveyView.swift
//  SurveyUI
//
//  Created by David Mendoza on 01/05/25.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var store: SurveyStore
    
    public init(store: SurveyStore) {
        self._store = StateObject(wrappedValue: SurveyStore())
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SurveyView(store: SurveyStore())
}
