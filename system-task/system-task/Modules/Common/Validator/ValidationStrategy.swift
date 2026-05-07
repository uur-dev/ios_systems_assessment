//
//  ValidationStrategy.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation

public protocol ValidationStrategy {
    func validate(value: String) -> Bool
    var errorMessage: String? { get }
}

