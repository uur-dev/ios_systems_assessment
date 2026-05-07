//
//  UserService.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation

final class UserService {
    
    // singleton instance
    static let shared = UserService()
    
    // private constructor to prevent external instantiation
    private init() {}
    
    private enum Keys {
        static let email = "app.user_email"
        static let isLoggedIn = "app.isLoggedIn"
    }
    
    // email
    var email: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.email)
        }
    }
    
    // for checking - user is logged in or not
    var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        }
    }
    
    func login(email: String) {
        UserDefaults.standard.set(email, forKey: Keys.email)
        UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Keys.email)
        UserDefaults.standard.set(false, forKey: Keys.isLoggedIn)
    }
}
