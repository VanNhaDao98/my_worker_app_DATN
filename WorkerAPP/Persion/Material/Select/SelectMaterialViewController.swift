//
//  SelectMaterialViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Domain

class SelectMaterialViewController: BaseViewController, MVVMViewController {
    typealias VM = SelectMaterialViewModel
    
    var viewModel: SelectMaterialViewModel
    
    private var didConfirm: ([LineItem]) -> Void
    
    init(viewModel: SelectMaterialViewModel, didConfirm: @escaping ([LineItem]) -> Void) {
        self.viewModel = viewModel
        self.didConfirm = didConfirm
        super.init()
        useContentView = true
    }
    
    private var tableView = BaseTableView(frame: .zero, style: .grouped).then({
        $0.improveTouchesBehavior = true
    })
    
    private var confirmButton = Button().makePrimary()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    

    func setupView() {
        isHiddenNavigationBar = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmptyCellCell.nib(in: .main), forCellReuseIdentifier: EmptyCellCell.reuseId)
        tableView.register(SelectLineItemCell.nib(in: .main), forCellReuseIdentifier: SelectLineItemCell.reuseId)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
        }
        
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(tableView.snp.bottom)
            $0.height.equalTo(48)
        })
        
        confirmButton.title = "Xác nhận"
        
        confirmButton.squircle(radius: 24)
        confirmButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
        self.showInitialLoading()
    }
    
    func bind(viewModel: SelectMaterialViewModel) {
        viewModel.config(.init(reloadView: { [weak self] in
            self?.tableView.reloadData()
            self?.hideInitialLoading()
        }, didConfirm: { [weak self] lineItems in
            self?.didConfirm(lineItems)
            self?.navigationController?.popViewController(animated: true)
        }))
        viewModel.send(.viewDidLoad)
    }

}

extension SelectMaterialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lineItemsValue.isEmpty ? 1 : viewModel.lineItemsValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.lineItemsValue.isEmpty {
            let cell = tableView.dequeueReusableCell(type: EmptyCellCell.self, for: indexPath)
            cell.setTitle(title: "Bạn hiện chưa đăng ký vật liệu nào \n Hãy vào mục Thông tin cá nhân -> Thêm vật liệu")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(type: SelectLineItemCell.self, for: indexPath)
        cell.updateView(lineItem: self.viewModel.lineItemsValue[indexPath.row], currentLineItem: viewModel.currentValue)
        cell.updateQuantity = { [weak self] value in
            self?.viewModel.send(.updateQuantity(indexPath.row, value))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MaterialHeaderView()
        headerView.updateView(title: "Tìm kiếm", isEnableCreateButton: false)
        headerView.search = { [weak self] query in
            self?.viewModel.send(.search(query ?? ""))
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.send(.selectLineItem(indexPath.row))
    }
}
