//
//  ViewController.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        emailTextField.placeholder = "abc@example.com"
        passwordTextField.placeholder = "********"
        passwordTextField.isSecureTextEntry = true
        
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind TextFields
            emailTextField.rxText
                .orEmpty
                .bind(to: loginViewModel.emailText)
                .disposed(by: disposeBag)
            
            passwordTextField.rxText
                .orEmpty
                .bind(to: loginViewModel.passwordText)
                .disposed(by: disposeBag)

        // Bind TextFields Errors
            loginViewModel.emailError
                .skip(1)
                .observe(on: MainScheduler.instance)
                .bind(to: emailTextField.errorText)
                .disposed(by: disposeBag)
            
            loginViewModel.passwordError
                .skip(1)
                .observe(on: MainScheduler.instance)
                .bind(to: passwordTextField.errorText)
                .disposed(by: disposeBag)
            
        // Bind Login Button State
            loginViewModel.isLoginEnabled
                .observe(on: MainScheduler.instance)
                .bind(to: buttonLogin.rx.isEnabled)
                .disposed(by: disposeBag)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        UserService.shared.login(email: emailTextField.text)
        // set home vc
        let homeVC = HomeViewController()
        self.navigationController?.makeRoot(viewController: homeVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

