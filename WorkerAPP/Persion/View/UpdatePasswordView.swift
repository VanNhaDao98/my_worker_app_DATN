//
//  UpdatePasswordView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 28/11/2023.
//
import UIKit
import Presentation
import UIComponents
import Utils

class UpdatePasswordView: CustomXibView {

    @IBOutlet private var confirmButton: Button!
    @IBOutlet private var cancelButton: Button!
    @IBOutlet private var confirmPasswordTextField: TextFieldTitle!
    @IBOutlet private var passwordTextField: TextFieldTitle!
    @IBOutlet private var titleLabel: HeaderLabel!
    @IBOutlet private var warningLabel: UILabel!
    
    struct Action {
        var dismiss: () -> Void
        var confirm: () -> Void
        var passwordDidChanged: (String?) -> Void
        var confirmPasswordDidChanged: (String?) -> Void
    }
    
    var action: Action?
    
    private var showPassword: Bool = false
    private var showConfirmPassword: Bool = false
    
    override func configeViews() {
        super.configeViews()
        
        titleLabel.text = "Thay đổi mật khẩu"
        
        warningLabel.text = "Mật khẩu không trùng nhau. Vui lòng kiểm tra lại"
        warningLabel.font = Fonts.italicFont(ofSize: .small)
        warningLabel.textColor = .red
        
        warningLabel.isHidden = true
        
        cancelButton.title = "Trở về"
        cancelButton.config.style = .outline
        cancelButton.config.primaryColor = .red
        
        confirmButton.title = "Xác nhận"
        confirmButton.config.primaryColor = .red
        confirmButton.setTitleColor(.white, for: .normal)
        
        [cancelButton, confirmButton].forEach({
            $0?.squircle(radius: 24)
        })
        
        cancelButton.action = { [weak self] in
            self?.action?.dismiss()
        }
        
        confirmButton.action = { [weak self] in
            self?.action?.confirm()
        }
        
        passwordTextField.title = "Nhập mật khẩu"
        passwordTextField.isRequired = true
        passwordTextField.placeholder = "Nhập mật khẩu"
        passwordTextField.isSecureTextEntry = !self.showPassword
        passwordTextField.rightIconMode = .custom({
            self.showPassword.toggle()
            self.passwordTextField.isSecureTextEntry = !self.showPassword
        }, ImageConstant.eyeSlashAlt)
        
        passwordTextField.textDidChanged = { [weak self] text in
            self?.action?.passwordDidChanged(text)
            self?.setHiddenWarning(true)
        }
        
        confirmPasswordTextField.textDidChanged = { [weak self] text in
            self?.action?.confirmPasswordDidChanged(text)
            self?.setHiddenWarning(true)
        }
        
        confirmPasswordTextField.title = "Nhập lại mật khẩu"
        confirmPasswordTextField.isRequired = true
        confirmPasswordTextField.placeholder = "Nhập lại mật khẩu"
        confirmPasswordTextField.isSecureTextEntry = !self.showConfirmPassword
        confirmPasswordTextField.rightIconMode = .custom({
            self.showConfirmPassword.toggle()
            self.confirmPasswordTextField.isSecureTextEntry = !self.showConfirmPassword
        }, ImageConstant.eyeSlashAlt)
    }
    
    public func setHiddenWarning(_ isHidden: Bool) {
        warningLabel.isHidden = isHidden
    }

}
