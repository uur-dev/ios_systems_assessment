//
//  HomeViewController.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        
        self.tabBar.tintColor = .black
        self.tabBar.backgroundColor = .systemBackground
    }
    
    private func setupTabs() {
        //set delegate
        self.delegate = self
        
        let postVC = UIStoryboard.getVC(ofType: PostViewController.self)
        let favVC = UIStoryboard.getVC(ofType: FavouriteViewController.self)
        
        // Set Tab Bar Items (Icons and Labels)
        postVC.tabBarItem = UITabBarItem(
            title: "Posts",
            image: UIImage(systemName: "list.bullet.rectangle"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        
        favVC.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        self.viewControllers = [postVC, favVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        updateNavigationItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateNavigationItems()
    }
}

// MARK: - UITabBarControllerDelegate
extension HomeViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Update the title every time a tab is tapped
        updateNavigationItems()
    }
}

// MARK: - Logout Button
extension HomeViewController {
    
    private func updateNavigationItems() {
        self.navigationItem.title = selectedViewController?.tabBarItem.title
        
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .systemRed
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logoutTapped() {
        // move to login vc
        let loginVC = UIStoryboard.getVC(ofType: LoginViewController.self)
        self.navigationController?.makeRoot(viewController: loginVC, animated: true)
        // call user logout
        UserService.shared.logout()
    }
    
}
