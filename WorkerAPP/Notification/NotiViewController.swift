//
//  NotiViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 16/10/2023.
//

import UIKit
import Presentation
import UIComponents

class NotiViewController: BaseViewController, MVVMViewController {
    
    private var tableView = BaseTableView(frame: .zero, style: .plain).then({
        $0.improveTouchesBehavior = true
    })
    
    
    typealias VM = NotiViewModel
    
    var viewModel: NotiViewModel = .init()
    
    override init() {
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
        navigationItem.title = "Thông báo"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NotiOrderCell.nib(in: .main), forCellReuseIdentifier: NotiOrderCell.reuseId)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        })
    }
    
    func bind(viewModel: NotiViewModel) {
        viewModel.config(.init())
        viewModel.send(.viewDidLoad)
    }
}

extension NotiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: NotiOrderCell.self, for: indexPath)
        cell.demo(index: indexPath.row)
        return cell
    }
    
    
}
