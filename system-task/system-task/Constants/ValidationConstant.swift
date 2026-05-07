//
//  ValidatorConstant.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation

enum ValidationError: String {
    case invalidEmail = "Invalid Email Address."
    case invalidPassword = "Password must be 8-15 characters."
}


enum ValidationConstant: String {
    case emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}
