//
//  LoginView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 10/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class LoginView: CustomXibView {
    
    @IBOutlet private var loginButton: AppBaseButton!
    @IBOutlet private var resetPasswordButton: AppBaseButton!
    @IBOutlet private var passwordTextField: TextField!
    @IBOutlet private var phoneNumberTextField: TextField!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var registButton: AppBaseButton!
    @IBOutlet private var noteLabel: UILabel!
    
    struct Action {
        var phoneNumber: (String?) -> Void
        var password: (String?) -> Void
        var registAction: () -> Void
        var loginAction: () -> Void
        var resetPasswordAction: () -> Void
    }
    
    var action: Action?
    
    private var isShowPassword = false
    override func configeViews() {
        super.configeViews()
        squircle(radius: 12)
        border(width: 8, color: ColorConstant.lineView)
        
        titleLabel.text = "Đăng nhập"
        titleLabel.font = Fonts.boldFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        
        noteLabel.text = "Hoặc"
        noteLabel.font = Fonts.defaultFont(ofSize: .small)
        noteLabel.textColor = ColorConstant.grayText
        
        phoneNumberTextField.placeholder = "Nhập Email của bạn"
        passwordTextField.placeholder = "Nhập mật khẩu"
        passwordTextField.isSecureTextEntry = true
        
        resetPasswordButton.setTitle(title: "Quên mật khẩu ?")
        resetPasswordButton.setTitleColor(ColorConstant.primary, for: .normal)
        
        loginButton.squircle(radius: 8)
        loginButton.setTitle(title: "Đăng nhập")
        loginButton.backgroundColor = ColorConstant.primary
        loginButton.setTitleColor(.white, for: .normal)
        
        registButton.squircle(radius: 8)
        registButton.setTitle(title: "Tạo Tài khoản")
        registButton.backgroundColor = ColorConstant.primary
        registButton.setTitleColor(.white, for: .normal)
        
        passwordTextField.rightIconMode = .custom({ [weak self] in
            self?.setPasswordMode()
        }, ImageConstant.eyeSlashAlt)
        passwordTextField.leftIcon = ImageConstant.icLock
        passwordTextField.dismissOnReturn = true
        phoneNumberTextField.leftIcon = ImageConstant.userCircle
        phoneNumberTextField.dismissOnReturn = true
        
        phoneNumberTextField.textDidChanged = { [weak self] text in
            self?.action?.phoneNumber(text)
        }
        
        passwordTextField.textDidChanged = { [weak self] text in
            self?.action?.password(text)
        }
        
        resetPasswordButton.action = { [weak self] in
            self?.action?.resetPasswordAction()
        }
        
        loginButton.action = { [weak self] in
            self?.action?.loginAction()
        }
        
        registButton.action = { [weak self] in
            self?.action?.registAction()
        }
    }
    private func setPasswordMode() {
        isShowPassword.toggle()
        passwordTextField.isSecureTextEntry = !isShowPassword
    }

}
