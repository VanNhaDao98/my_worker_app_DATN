//
//  CreateWorkerAddressViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class CreateWorkerAddressViewController: BaseViewController, MVVMViewController {
    typealias VM = CreateWorkerAddressViewModel
    
    var viewModel: CreateWorkerAddressViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    private var continueButton = Button()
    private var provinceTextField = TextField()
    private var districtTextField = TextField()
    private var wardTextField = TextField()
    private var addressTextField = TextField()
    
    private var didConfirmAddress: (Worker) -> Void
    
    init(viewModel: CreateWorkerAddressViewModel,
         didConfirmAddress: @escaping (Worker) -> Void) {
        self.viewModel = viewModel
        self.didConfirmAddress = didConfirmAddress
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
        headerView.setValue(title: "Địa chỉ làm việc", subTitle: "Điền đúng địa chỉ làm việc sẽ giúp bạn và khách hàng dễ dàng kết nối.")
        
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(provinceTextField)
        mainStackView.addArrangedSubview(districtTextField)
        mainStackView.addArrangedSubview(wardTextField)
        mainStackView.addArrangedSubview(addressTextField)
     
        provinceTextField.placeholder = "Tỉnh/Thành phố"
        provinceTextField.isRequired = true
        provinceTextField.isSelectable = true
        provinceTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.viewModel.send(.tapProvince)
        })
        
        districtTextField.placeholder = "Quận/Huyện"
        districtTextField.isRequired = true
        districtTextField.isSelectable = true
        districtTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.viewModel.send(.tapDistrict)
        })
        
        wardTextField.placeholder = "Phường/Xã"
        wardTextField.isRequired = true
        wardTextField.isSelectable = true
        wardTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.viewModel.send(.tapWard)
        })
        
        addressTextField.textDidChanged = { [weak self] text in
            self?.viewModel.send(.updateAdderss(text))
        }
        
        addressTextField.placeholder = "Địa chỉ chi tiết"
        continueButton.squircle(radius: 24)
        continueButton.title = "Hoàn thành"
        contentView.addSubview(continueButton)
        
        continueButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        }
        
        title = "Tạo tài khoản"
        
    }
    
    private func updateView(data: CreateWorkerAddressViewModel.Address) {
        provinceTextField.text = data.province
        districtTextField.text = data.district
        wardTextField.text = data.ward
        addressTextField.text = data.address
    }
    
    func bind(viewModel: CreateWorkerAddressViewModel) {

        viewModel.config(.init(didConfirm: { [weak self] account in
            self?.didConfirmAddress(account)
            self?.navigationController?.popViewController(animated: true)
        }, loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, provinces: { [weak self] items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem() }),
                             title: "Tỉnh/Thành phố",
                             searchable: true,
                             from: self, didSelectItems: { _, values in
                guard let value = values.first else { return }
                self.viewModel.send(.updateProvince(value))
            })
        }, districts: { [weak self] items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem() }),
                             title: "Quận/Huyện",
                             searchable: true,
                             from: self, didSelectItems: { _, values in
                guard let value = values.first else { return }
                self.viewModel.send(.updateDistrict(value))
            })
        }, wards: { [weak self] items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem() }),
                             title: "Phường/Xã",
                             searchable: true,
                             from: self, didSelectItems: { _, values in
                guard let value = values.first else { return }
                self.viewModel.send(.updateWard(value))
            })
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo",
                            message: error,
                            present: self)
        }, address: { [weak self] address in
            self?.updateView(data: address)
        }, status: { [weak self] isEnable in
            self?.continueButton.isEnabled = isEnable
        }))
        viewModel.send(.viewDidLoad)
    }
}
