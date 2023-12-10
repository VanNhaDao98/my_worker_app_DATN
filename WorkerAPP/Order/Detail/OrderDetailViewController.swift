//
//  OrderDetailViewController.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 25/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class OrderDetailViewController: BaseViewController, MVVMViewController {
    
    typealias VM = OrderDetailViewModel
    
    var viewModel: OrderDetailViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    
    private var genericView = GenericOrderView()
    private var customerView = CustomerOrderView()
    
    private var materialTableView = AutoSizingTableView(frame: .zero, style: .plain).then({
        $0.improveTouchesBehavior = true
    })
    
    private var confirmButton = Button()
    private var cancelButton = Button()
    private var progressButton = Button().makePrimary()
    private var pendingButton = Button()
    private var completeButton = Button().makePrimary()
    
    private var editButton = Button().makePrimary()
    
    private var buttonStackView = UIStackView()
    
    init(viewModel: OrderDetailViewModel) {
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
        isHiddenNavigationBar = false
        materialTableView.delegate = self
        materialTableView.dataSource = self
        materialTableView.register(SelectLineItemCell.nib(in: .main), forCellReuseIdentifier: SelectLineItemCell.reuseId)
        materialTableView.register(EmptyCellCell.nib(in: .main), forCellReuseIdentifier: EmptyCellCell.reuseId)
        contentView.addSubview(scrollView)
        navigationItem.title = "Chi tiết đơn hàng"
        scrollView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview().priority(999)
        })
        scrollView.addSubview(mainStackView)
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.backgroundColor = .ink05
        mainStackView.spacing = 12
        mainStackView.axis = .vertical
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide  )
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })

        mainStackView.addArrangedSubview(genericView)
        mainStackView.addArrangedSubview(customerView)
        
        mainStackView.addArrangedSubview(materialTableView)
        
        customerView.action = .init(callAction: { [weak self] in
            self?.viewModel.send(.call)
        }, mesengerAction: { [weak self] in
            self?.viewModel.send(.messenger)
        })
        
       
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(progressButton)
        buttonStackView.addArrangedSubview(pendingButton)
        buttonStackView.addArrangedSubview(completeButton)
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
//            $0.height.equalTo(48)
            $0.top.equalTo(scrollView.snp.bottom)
        })
        
        cancelButton.action = { [weak self] in
            guard let self = self else { return }
            Popup.showConfirmValue(title: "Hủy yêu cầu",subTitle: "Bạn có chắc chắn muốn hủy?", confirmAction: {
                Popup.hide()
                self.viewModel.send(.cancel)
            }, present: self.tabBarController!)
        }
        
        editButton.isHidden = true
        
        editButton.action = { [weak self] in
            self?.viewModel.send(.addLineItem)
        }
        
        confirmButton.action = { [weak self] in
            self?.viewModel.send(.comfirm)
        }
        
        progressButton.action = { [weak self] in
            self?.viewModel.send(.progress)
        }
        
        pendingButton.action = { [weak self] in
            self?.viewModel.send(.pending)
        }
        
        completeButton.action = { [weak self] in
            self?.viewModel.send(.complete)
        }
        
        [cancelButton, confirmButton, progressButton, pendingButton, completeButton, editButton].forEach({
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        })
        
        editButton.squircle(radius: 24)
        editButton.title = "Thêm vật liệu"
        
        cancelButton.squircle(radius: 24)
        cancelButton.title = "Hủy đơn hàng"
        cancelButton.config.style = .outline
        cancelButton.config.primaryColor = .red
        
        confirmButton.squircle(radius: 24)
        confirmButton.title = "Xác nhận đơn hàng"
        confirmButton.config.style = .outline
        confirmButton.config.primaryColor = .primary
        
        progressButton.squircle(radius: 24)
        progressButton.title = "Tiến hành công việc"
        progressButton.config.primaryColor = .primary
        
        pendingButton.squircle(radius: 24)
        pendingButton.title = "Tạm dừng công việc"
        pendingButton.config.style = .outline
        pendingButton.config.primaryColor = .primary
        
        completeButton.squircle(radius: 24)
        completeButton.title = "Hoàn thành"
        completeButton.config.primaryColor = .primary
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("orderDetail"), object: nil)
        self.showInitialLoading()
    }
    
    @objc private func handleNotification(_ noti: Notification) {
        guard let data = noti.object as? Order else { return }
        self.viewModel.send(.sendOrder(data))
    }
    
    func bind(viewModel: OrderDetailViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, generic: { [weak self] generic in
            self?.genericView.updateView(data: generic)
            self?.hideInitialLoading()
        }, customer: { [weak self] customer in
            self?.customerView.updateView(customer: customer)
        }, button: { [weak self] status in
            self?.updateButton(status: status)
        }, reloadTableView: { [weak self] in
            self?.materialTableView.reloadData()
        }, lineItems: { [weak self] lineItems in
            SelectMaterialViewController(viewModel: .init(currentLineItems: lineItems,
                                                          parseVariantToLineItem: {
                return .init(metarial: $0, quantity: 0)
            })) { [weak self] lineItems in
                self?.viewModel.send(.updateLineItem(lineItems))
            }.push(from: self)
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show( title: "Thông báo", message: error, present: self)
        }, success: { success in
            AlertUtils.show( title: "Thông báo", message: success, present: self)
        }))
        viewModel.send(.viewDidLoad)
    }
    
    private func updateButton(status: VM.ButtonStatus) {
        self.cancelButton.isHidden = status.isHiddenCanncelButton
        self.completeButton.isHidden = status.isHiddenCompleteButtom
        self.progressButton.isHidden = status.isHiddenProgressButton
        self.pendingButton.isHidden = status.isHiddenPendingButton
        self.confirmButton.isHidden = status.isHiddenConfirmButton
        self.editButton.isHidden = status.isHiddenEditButton
        self.cancelButton.title = status.cancelTitle
    }

}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lineItems.isEmpty ? 1 : viewModel.lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.lineItems.isEmpty {
            let cell = tableView.dequeueReusableCell(type: EmptyCellCell.self, for: indexPath)
            cell.setTitle(title: "Đơn hàng của bạn không có vật liệu nào")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(type: SelectLineItemCell.self, for: indexPath)
            cell.updateView(lineItem: self.viewModel.lineItems[indexPath.row])
            cell.updateQuantity = { [weak self] quantity in
                self?.viewModel.send(.updateQuantity(indexPath.row, quantity))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderTitleView()
        headerView.setTitle(title: viewModel.totalPriceLineItem)
        headerView.action = { [weak self] in
            self?.viewModel.send(.selectLineItem)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
