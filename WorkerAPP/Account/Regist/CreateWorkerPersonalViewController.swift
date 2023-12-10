//
//  CreateWorkerPersonalViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class CreateWorkerPersonalViewController: BaseViewController, MVVMViewController {

    typealias VM = CreateWorkerPersonalViewModel
    
    var viewModel: CreateWorkerPersonalViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    private var continueButton = Button()
    private var nameTextField = TextFieldTitle()
    private var birthdayTextField = TextFieldTitle()
    private var genderTextField = TextFieldTitle()
    private var phoneNumberTextField = TextFieldTitle()
    private var describerTitlelabel = UILabel()
    private var describeTextView = TextView()
    
    private var didConfirmInfo: (Worker) -> Void
    
    init(viewModel: CreateWorkerPersonalViewModel,
         didConfirmInfo: @escaping (Worker) -> Void) {
        self.viewModel = viewModel
        self.didConfirmInfo = didConfirmInfo
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
        headerView.setValue(title: "Thông tin cơ bản", subTitle: "Hoàn thiện thông tin cơ bản của bạn.")
        describerTitlelabel.attributedText = AttributedStringMaker(string: "Giới thiệu bản thân *")
            .font(Fonts.defaultFont(ofSize: .subtitle))
            .color(ColorConstant.grayText).first(match: "*", maker: {
                $0.color(.red)
            }).build()
        
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(phoneNumberTextField)
        mainStackView.addArrangedSubview(birthdayTextField)
        mainStackView.addArrangedSubview(genderTextField)
        mainStackView.addArrangedSubview(describerTitlelabel)
        mainStackView.addArrangedSubview(describeTextView)
     
        nameTextField.title = "Họ và tên"
        nameTextField.placeholder = "Nhập họ và tên"
        nameTextField.isRequired = true
        nameTextField.maxCharacterCount = 50
        
        phoneNumberTextField.title = "Số điện thoại"
        phoneNumberTextField.isRequired = true
        phoneNumberTextField.placeholder = "Nhập số điện thoại"
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.maxCharacterCount = 13
        
        phoneNumberTextField.textDidChanged = { [weak self] text in
            self?.viewModel.send(.updatePhoneNumber(text))
        }
        
        nameTextField.textDidChanged = { [weak self] name in
            self?.viewModel.send(.updateName(name))
        }

        describeTextView.textDidChanged = { [weak self] text in
            self?.viewModel.send(.updateDescribe(text))
        }
        birthdayTextField.title = "Ngày sinh"
        birthdayTextField.placeholder = "Chọn ngày sinh"
        birthdayTextField.isSelectable = true
        birthdayTextField.isRequired = true
        birthdayTextField.rightIconMode = .custom({ [weak self] in
            self?.viewModel.send(.tapBirthDay)
        }, ImageConstant.calendar)
        
        genderTextField.title = "Giới tính"
        genderTextField.placeholder = "Chọn giới tính"
        genderTextField.isSelectable = true
        genderTextField.isRequired = true
        genderTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.viewModel.send(.tapGender)
        })

        
        continueButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
        
        
        continueButton.squircle(radius: 24)
        continueButton.title = "Hoàn thành"
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        }
        
        title = "Tạo tài khoản"
        
    }
    
    func updateView(data: CreateWorkerPersonalViewModel.Generic) {
        nameTextField.text = data.fullname
        birthdayTextField.text = data.birthday
        genderTextField.text = data.gender
        describeTextView.text = data.describe
        phoneNumberTextField.text = data.phone
    }
    
    func bind(viewModel: CreateWorkerPersonalViewModel) {
        viewModel.config(.init(didConfirm: { [weak self] account in
            self?.didConfirmInfo(account)
            self?.navigationController?.popViewController(animated: true)
        }, generic: { [weak self] data in
            self?.updateView(data: data)
        },date: { [weak self] date in
            guard let self = self else { return }
            DatePicker.show(title: "Ngày sinh" ,
                            config: .init(mode: .date,
                                          date: date,
                                          maximumDate: Date()),
                            from: self) { value in
                self.viewModel.send(.updateBirthDat(value))
            }
        }, gender: { [weak self] items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem()}),
                             title: "Giới tính",
                             from: self, didSelectItems: { _, values in
                if let value = values.first {
                    self.viewModel.send(.updateGender(value))
                }
            })
        }, enableButton: { [weak self] isEnable in
            self?.continueButton.isEnabled = isEnable
        }, error: {[weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo",
                            message: error,
                            present: self)
        }))
        viewModel.send(.viewDidLoad)
    }
}
