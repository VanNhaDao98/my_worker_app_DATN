//
//  RegistAccountViewController.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 22/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class RegistAccountViewController: BaseViewController, MVVMViewController {
    
    typealias VM = RegistAccountViewModel
    
    var viewModel: RegistAccountViewModel
    private var mainStackView = UIStackView()
    private var scrollView = UIScrollView()
    
    private var confirmButton = Button().makePrimary()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var emailTextField = TextFieldTitle()
    private var passwordTextField = TextFieldTitle()
    private var confirmPasswordTextField = TextFieldTitle()
    private var warningView = CustomWarningView()
    
    private var isShowPasword: Bool = false
    private var isShowConfirmPassword: Bool = false
    
    init(viewModel: RegistAccountViewModel) {
        self.viewModel = viewModel
        super.init()
        useContentView = true
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func setupView() {
        title = "Tạo tài khoản"
        
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subTitleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(confirmPasswordTextField)
        mainStackView.spacing = 12
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        
        titleLabel.text = "Nhập email của bạn"
        titleLabel.font = Fonts.boldFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        
        subTitleLabel.text = "Vui lòng nhập số email của bạn để tạo tài khoản, mỗi tài khoản chỉ được sử dụng 1 lần"
        subTitleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        subTitleLabel.textColor = ColorConstant.text50
        subTitleLabel.numberOfLines = 0
        
        emailTextField.title = "Địa chỉ email"
        emailTextField.placeholder = "Nhập địa chỉ email"
        emailTextField.isRequired = true
        
        passwordTextField.title = "Mật khẩu"
        passwordTextField.placeholder = "Nhập mật khẩu"
        passwordTextField.isRequired = true
        passwordTextField.isSecureTextEntry = !isShowPasword
        passwordTextField.rightIconMode = .custom({ [weak self] in
            self?.isShowPasword.toggle()
            self?.passwordTextField.isSecureTextEntry = !(self?.isShowPasword ?? false)
        }, ImageConstant.eyeSlashAlt)
        
        confirmPasswordTextField.title = "Xác nhận mật khẩu"
        confirmPasswordTextField.placeholder = "Nhập lại mật khẩu"
        confirmPasswordTextField.isRequired = true
        confirmPasswordTextField.isSecureTextEntry = !isShowConfirmPassword
        confirmPasswordTextField.rightIconMode = .custom({ [weak self] in
            self?.isShowConfirmPassword.toggle()
            self?.confirmPasswordTextField.isSecureTextEntry = !(self?.isShowConfirmPassword ?? false)
        }, ImageConstant.eyeSlashAlt)
        
        confirmButton.config.primaryColor = ColorConstant.primary
        confirmButton.title = "Xác nhận"
        confirmButton.squircle(radius: 24)
        
        contentView.addSubview(scrollView)
        enableHeaderView(pintoView: scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })
        
        
        warningView.updateView(icon: ImageConstant.shieldCheck, title: "Bằng việc nhấn vào nút Xác nhận, bạn đã đồng ý với Quy chế của chúng tôi" )
        
        contentView.addSubview(warningView)
        warningView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(scrollView.snp.bottom)
        }
        
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(warningView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        emailTextField.textDidChanged = { [weak self] email in
            self?.viewModel.send(.updateEmail(email))
        }
        
        passwordTextField.textDidChanged = { [weak self] password in
            self?.viewModel.send(.updatePassword(password))
        }
        
        confirmPasswordTextField.textDidChanged = { [weak self] password in
            self?.viewModel.send(.updateConfirmPassword(password))
        }
        
        confirmButton.action = { [weak self] in
            self?.viewModel.send(.submit)
        }
        
    }
    
    func bind(viewModel: RegistAccountViewModel) {
        viewModel.config(.init(showLoding: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, didRegistAccount: { [weak self] account in
            CreateWorkerGeneralViewController(viewModel: .init(account: account)).push(from: self)
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo", message: error, present: self)
        }))
        viewModel.send(.viewDidLoad)
    }

}

