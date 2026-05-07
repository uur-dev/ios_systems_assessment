//
//  FormTextField.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class FormTextField: UIView {
    
    // UI Elements
    private let stackView: UIStackView = UIStackView()
    private let _textField: UITextField = UITextField()
    private let _errorLabel: UILabel = UILabel()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        initUI()
    }
    
    private func initUI() {
        initStackView()
        initTextField()
        initErrorLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setAppearance()
    }
    
    private var _placeholder: String?
    public var placeholder: String? {
        get { _placeholder }
        set {
            _placeholder = newValue
            _textField.placeholder = _placeholder
        }
    }
    
    private var _isSecureTextEntry: Bool = false
    public var isSecureTextEntry: Bool {
        get { _isSecureTextEntry }
        set {
            _isSecureTextEntry = newValue
            _textField.isSecureTextEntry = _isSecureTextEntry
        }
    }
}


// MARK: - UI Setup
extension FormTextField {
    
    private func setAppearance() {
        self.layer.cornerRadius = 8
    }
    
    private func initStackView() {
        // remove from subview if already in view
        stackView.removeFromSuperview()
        // add in main view
        addSubview(stackView)
        // remove constsraints - if any
        stackView.removeConstraints(stackView.constraints)
        // add new constraints
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        // configuration
        stackView.spacing = 8
        stackView.axis = .vertical
        
        // add textfield
        _textField.removeFromSuperview()
        stackView.addArrangedSubview(_textField)
        
        // add error
        _errorLabel.removeFromSuperview()
        stackView.addArrangedSubview(_errorLabel)
    }
    
    private func initErrorLabel() {
        _errorLabel.isHidden = true
        _errorLabel.textColor = .red
        _errorLabel.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private func initTextField() {
        _textField.borderStyle = .none
        _textField.font = .systemFont(ofSize: 16, weight: .regular)
        _textField.textColor = .darkGray
    }
}

// MARK: - RX Swift
extension FormTextField {
    var rxText: ControlProperty<String?> {
        return _textField.rx.text
    }
    
    var errorText: Binder<String?> {
        return Binder(self) { view, message in
            view._errorLabel.text = message
            view._errorLabel.isHidden = (message == nil)
        }
    }
    
    var text: String {
        get {
            return _textField.text ?? ""
        }
    }
}
