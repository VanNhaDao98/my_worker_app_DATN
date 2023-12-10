//
//  DetailRateViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/11/2023.
//

import UIKit
import Presentation
import UIComponents

class DetailRateViewController: BaseViewController, MVVMViewController {
    var viewModel: DetailRateViewModel
    
    init(viewModel: DetailRateViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private var tableView = BaseTableView(frame: .zero, style: .grouped)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
    }
    
    func setupView() {
        
        self.navigationItem.title = "Đánh giá"
        isHiddenNavigationBar = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RateWorkerCell.nib(in: .main), forCellReuseIdentifier: RateWorkerCell.reuseId)
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        showInitialLoading()
    }
    
    func bind(viewModel: DetailRateViewModel) {
        viewModel.config(.init(items: { [weak self] in
            self?.hideInitialLoading()
            self?.tableView.reloadData()
        }))
        viewModel.send(.viewDidLoad)
    }
}

extension DetailRateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.ratesValue.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RateHeaderView()
        headerView.updateView(data: viewModel.ratesValue.map({ .init(rate: $0)}))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: RateWorkerCell.self, for: indexPath)
        cell.updateView(rate: .init(rate: viewModel.ratesValue[indexPath.row]))
        return cell
    }
}

