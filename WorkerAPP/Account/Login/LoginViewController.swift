//
//  ViewController.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 22/10/2023.
//

import UIKit
import SnapKit
import Presentation
import Utils
import UIComponents

class LoginViewController : BaseViewController, MVVMViewController {
    
    typealias VM = LoginViewModel
    
    var viewModel: LoginViewModel = .init()
    
    @IBOutlet private var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        // test ciu
    }
    
    @objc private func demo() {
        print("connect")
    }
    
    func setupView() {
        
        loginView.isHidden = true
        contentView.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(demo), name: Notification.Name("demo"), object: nil)
        
        loginView.action = .init(phoneNumber: { [weak self] email in
            self?.viewModel.send(.updateEmail(email))
        }, password: { [weak self] password in
            self?.viewModel.send(.updatePassword(password))
        }, registAction: { [weak self] in
            RegistAccountViewController(viewModel: .init()).push(from: self)
//            CreateWorkerJobViewViewController(viewModel: .init(genericAccount: .init())).push(from: self)
        }, loginAction: { [weak self] in
            self?.viewModel.send(.login)
        }, resetPasswordAction: { [weak self] in
            self?.viewModel.send(.tapResetPassword)
        })
    }
    
    func bind(viewModel: LoginViewModel) {
        viewModel.config(.init(actionFail: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo", message: error, present: self)
        }, showLoading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, didRequestResetPassword: { [weak self] message in
            guard let self = self else { return }
            AlertUtils.show(title: "Thông báo", message: message, present: self)
        }, resetPassword: { [weak self] in
            guard let self = self else { return }
            
            let resetView = ResetView()
            var email: String = ""
            resetView.action = .init(dismiss: {
                Popup.hide()
            }, confirm: {
                Popup.hide()
                self.viewModel.send(.resetPassword(email))
            }, valueDIdChanged: { value in
                email = value ?? ""
            })
            Popup.show(present: self, customView: resetView)
        }, emptyAccount: { [weak self] account in
            CreateWorkerGeneralViewController(viewModel: .init(account: account)).push(from: self)
            self?.loginView.isHidden = false
        }, successGenericAccount: { genericAccount in
            let mainTabbar = MainTabbarViewController()
            UIApplication.shared.keyWindow?.rootViewController = mainTabbar
        }, loginView: { [weak self] in
            self?.loginView.isHidden = false
        }))
        viewModel.send(.viewDidLoad)
    }
    
}

