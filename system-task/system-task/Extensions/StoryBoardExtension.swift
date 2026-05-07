//
//  StoryBoardExtension.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import UIKit
import Foundation

extension UIStoryboard {
    
    func initVC<T: UIViewController>(ofType type: T.Type) -> T {
        let identifier = String(describing: type)
        
        guard let viewController = self.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier \(identifier). Check your Storyboard ID.")
        }
        
        return viewController
    }
    
    static func getVC<T: UIViewController>(id: StoryBoardIds = .main, ofType type: T.Type) -> T {
        let storyBoard = UIStoryboard(name: id.rawValue, bundle: nil)
        let viewController = storyBoard.initVC(ofType: type)
        return viewController
    }
}
