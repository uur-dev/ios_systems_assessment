//
//  PasswordValidator.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation

struct PasswordValidator: ValidationStrategy {
    
    var errorMessage: String? {
        get {
            return ValidationError.invalidPassword.rawValue
        }
    }
    
    func validate(value: String) -> Bool {
        return value.count >= 8 && value.count < 16
    }
}
