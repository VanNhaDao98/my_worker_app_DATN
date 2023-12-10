//
//  HomeViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 16/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class HomeViewController: BaseViewController, MVVMViewController {
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    
    private var acceptJobView = SwitchLabelView()
    private var totalPriceView = TotalPriceView()
    private var revenueView = ReportRecenueView()
    
    private var newsTableView = AutoSizingTableView(frame: .zero, style: .plain).then({
        $0.improveTouchesBehavior = true
    })
    
    typealias VM =  HomeViewModel
    
    var viewModel: HomeViewModel = .init()
    
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
        
        showInitialLoading()
        isHiddenNavigationBar = false
        newsTableView.isScrollEnabled = false
        newsTableView.separatorStyle = .none
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(NewsCell.nib(in: .main), forCellReuseIdentifier: NewsCell.reuseId)
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 2, right: 16)
        
        acceptJobView.title = "Nhận làm việc"
        
        mainStackView.addArrangedSubview(acceptJobView)
        mainStackView.addArrangedSubview(totalPriceView)
        mainStackView.addArrangedSubview(revenueView)
        mainStackView.addArrangedSubview(newsTableView)
        
        revenueView.snp.makeConstraints({
            $0.height.equalTo(150)
        })
        
        totalPriceView.rechargeAction = { [weak self] in
            guard let self = self , let tabbar = self.tabBarController else { return }
            let view = RechareView()
            
            var codeValue: String = ""
            view.action = .init(confirm: {
                self.viewModel.send(.card(codeValue))
                Popup.hide()
            }, codeDidChanged: { code in
                codeValue = code ?? ""
            })
            
            Popup.show(present: tabbar, customView: view)
        }
        
        acceptJobView.valueDidChange = { [weak self] value in
            self?.viewModel.send(.changeStatue(value))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("orderCustomerList"), object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
            if let objects = notification.object {
                guard let data = objects as? [Order] else { return }
                self.viewModel.send(.sendData(data))
            }
        }
    
    func bind(viewModel: HomeViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, headerTitle: { [weak self] name in
            self?.navigationItem.title = "Xin chào \(name)"
            self?.hideInitialLoading()
        }, activeStatus: { [weak self] status in
            self?.acceptJobView.isOn = status
        }, updateStatusSuccess: { [weak self] in
            guard let self = self else { return }
            AlertUtils.show(title: "Thông báo",
                            message: "Bạn đã cập nhật trạng thái thành công" ,
                            present: self)
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Thông báo",
                            message: error ,
                            present: self)
        }, totalMoney: { [weak self] value in
            self?.totalPriceView.setValue(totalMoney: value)
        }, reloadNewsTableView: { [weak self] in
            self?.newsTableView.reloadData()
        }, report: { [weak self] report in
            self?.revenueView.updateView(report: report)
        }))
        viewModel.send(.viewDidLoad)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: NewsCell.self, for: indexPath)
        cell.updateView(item: viewModel.newsValue[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.send(.openLine(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let title = UILabel()
        title.text = "Trang thông tin"
        title.font = Fonts.boldFont(ofSize: .title)
        title.textColor = ColorConstant.text
        headerView.addSubview(title)
        title.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(9)
        })
        
        return headerView
    }
}
