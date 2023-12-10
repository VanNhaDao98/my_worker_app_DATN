//
//  CreateWorkerGeneralViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import UIKit
import UIComponents
import Presentation
import Utils

class CreateWorkerGeneralViewController: BaseViewController, MVVMViewController {
    
    typealias VM = CreateWorkerGeneralViewModel
    
    var viewModel: CreateWorkerGeneralViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    private var continueButton = Button()
    private var avatarTextField = TextField()
    private var generalTextField = TextField()
    private var addressTextField = TextField()
    private var degreeTextField = TextField()
    
    init(viewModel: CreateWorkerGeneralViewModel) {
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
        
        
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.spacing = 8
        
        contentView.addSubview(scrollView)
        enableHeaderView(pintoView: scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        let headerView = CreateWorkerHeaderView()
        headerView.setValue(title: "Thông tin cá nhân", subTitle: "Nhập thông tin cá nhân để hoàn thiện hồ sơ đăng ký tài khoản")
        
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(avatarTextField)
        mainStackView.addArrangedSubview(generalTextField)
        mainStackView.addArrangedSubview(addressTextField)
        mainStackView.addArrangedSubview(degreeTextField)
        
        [avatarTextField, generalTextField, addressTextField, degreeTextField].forEach {
            $0.isSelectable = true
        }
        
        avatarTextField.rightIconMode = .arrowRight({ [weak self] in
            self?.viewModel.send(.tapAvatar)
        })
        
        generalTextField.rightIconMode = .arrowRight({ [weak self] in
            self?.viewModel.send(.tapGeneric)
        })

        addressTextField.rightIconMode = .arrowRight({ [weak self] in
            self?.viewModel.send(.tapAddress)
        })

        degreeTextField.rightIconMode = .arrowRight ({ [weak self] in
            self?.viewModel.send(.tapDegree)
        })
        
        continueButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }

        
        avatarTextField.text = "Ảnh đại diện"
        generalTextField.text = "Thông tin cơ bản"
        addressTextField.text = "Địa chỉ làm việc"
        degreeTextField.text = "Bằng cấp"
           
        continueButton.squircle(radius: 24)
        continueButton.title = "Tiếp tục"
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        }
        
        title = "Tạo tài khoản"
        
    }
    
    func bind(viewModel: CreateWorkerGeneralViewModel) {
        viewModel.config(.init(avatar: { [weak self] account in
            CreateWorkerAvatarViewController(viewModel: .init(genericAccount: account)) { value in
                self?.viewModel.send(.updateAccount(value))
            }.push(from: self)
        }, generic: { [weak self] account in
            CreateWorkerPersonalViewController(viewModel: .init(genericAccount: account)) { value in
                self?.viewModel.send(.updateAccount(value))
            }.push(from: self)
        }, address: { [weak self] account in
            CreateWorkerAddressViewController(viewModel: .init(genericAccount: account)) { value in
                self?.viewModel.send(.updateAccount(value))

            }.push(from: self)
        }, degree: { [weak self] account in
            CreateWorkerDegreeViewController(viewModel: .init(genericAccount: account)) { value in
                self?.viewModel.send(.updateAccount(value))
            }.push(from: self)
        }, avatarStatus: { [weak self] status in
            self?.avatarTextField.leftIcon = status ? ImageConstant.checkfillCirle : nil
        }, genericStatus: { [weak self] status in
            self?.generalTextField.leftIcon = status ? ImageConstant.checkfillCirle : nil
        }, addressStatus: { [weak self] status in
            self?.addressTextField.leftIcon = status ? ImageConstant.checkfillCirle : nil
        }, degreeStatus: { [weak self] status in
            self?.degreeTextField.leftIcon = status ? ImageConstant.checkfillCirle : nil
        }, buttonMode: { [weak self] isEnable in
            self?.continueButton.isEnabled = isEnable
        }, didCreateAccount: { [weak self] account in
            CreateWorkerJobViewViewController(viewModel: .init(genericAccount: account)).push(from: self)
        }))
        viewModel.send(.viewDidLoad)
    }
    

}
