//
//  File.swift
//  SurveyUI
//
//  Created by David Mendoza on 07/10/26.
//

import Foundation

extension String {
    func validateRequired() -> Bool {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return false }
        return true
    }
}
