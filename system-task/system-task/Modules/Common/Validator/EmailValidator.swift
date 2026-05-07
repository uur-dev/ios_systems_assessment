//
//  EmailValidator.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation

struct EmailValidator: ValidationStrategy {
    
    var errorMessage: String? {
        get {
            return ValidationError.invalidEmail.rawValue
        }
    }
    
    func validate(value: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", ValidationConstant.emailRegex.rawValue).evaluate(with: value)
    }
}
