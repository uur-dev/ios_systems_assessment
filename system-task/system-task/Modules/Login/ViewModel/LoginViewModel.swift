//
//  LoginViewModel.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    let emailText: BehaviorRelay<String> = .init(value: "")
    let passwordText: BehaviorRelay<String> = .init(value: "")
    
    let emailError: Observable<String?>
    let passwordError: Observable<String?>
    let isLoginEnabled: Observable<Bool>
    
    init(emailValidator: ValidationStrategy = EmailValidator(), paswordValidator: ValidationStrategy = PasswordValidator()) {
    
        emailError = emailText.asObservable().map({ emailValidator.validate(value: $0) ? nil : emailValidator.errorMessage})
        
        passwordError = passwordText.asObservable().map({ paswordValidator.validate(value: $0) ? nil : paswordValidator.errorMessage})
        
        isLoginEnabled = Observable.combineLatest(emailError, passwordError) { $0 == nil && $1 == nil }
        
        super.init()
        
    }
}
