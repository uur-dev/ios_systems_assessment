//
//  NavigationExtension.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import UIKit
import Foundation

extension UINavigationController {
    
    func popToRoot(animated: Bool) {
        if viewControllers.count <= 1 {
            return
        }
        
        popToViewController(viewControllers.first!, animated: animated)
    }
    
    func makeRoot(viewController: UIViewController, animated: Bool) {
        setViewControllers([viewController], animated: animated)
    }
}
