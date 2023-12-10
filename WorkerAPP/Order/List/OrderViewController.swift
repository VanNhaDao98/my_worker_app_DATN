//
//  MessageViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 16/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class OrderViewController: BaseViewController, MVVMViewController {
    
    typealias VM = OrderViewModel
    
    var viewModel: OrderViewModel = OrderViewModel()
    
    private var tableView: BaseTableView = .init(frame: .zero, style: .plain).then({
        $0.improveTouchesBehavior = true
    })
    
    private var emptyView = CommonEmptyView()
    
    public override init() {
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
        
        addRightBarButtonItem(image: ImageConstant.filter,
                              color: .primary,
                              action: #selector(filter))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderListCell.nib(in: .main), forCellReuseIdentifier: OrderListCell.reuseId)
        navigationItem.title = "Hợp đồng"
        isHiddenNavigationBar = false
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.leading.trailing.bottom.top.equalToSuperview()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("orderCustomerList"), object: nil)
        
        contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        })
        
        emptyView.isHidden = true
    }
    
    @objc func filter() {
        viewModel.send(.filter)
    }
    
    func bind(viewModel: OrderViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, items: { [weak self] orders in
            self?.emptyView.isHidden = orders.count != 0
            self?.tableView.isHidden = orders.count == 0
            self?.tableView.reloadData()
        }, detailItems: { [weak self] order in
            OrderDetailViewController(viewModel: .init(order: order)).push(from: self)
        }, filter: { [weak self] items in
            guard let self = self, let tabbar = self.tabBarController else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem()}),
                             title: "Lọc theo trạng thái",
                             allowMultipleSelections: true,                             from: tabbar) { _, values in
                self.viewModel.send(.updateFilterValue(values))
            }
        }, headerTitle: { [weak self] title in
            self?.title = title
        }))
        viewModel.send(.viewDidLoad)
    }
    
    @objc func handleNotification(_ notification: Notification) {
            if let objects = notification.object {
                guard let data = objects as? [Order] else { return }
                self.viewModel.send(.sendData(data))
            }
        }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: OrderListCell.self, for: indexPath)
        cell.updateView(order: viewModel.orderValue[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.send(.selectItem(indexPath.row))
    }
}
