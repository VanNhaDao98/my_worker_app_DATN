//
//  DetailPesionalViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class DetailPesionalViewController: BaseViewController, MVVMViewController {
    
    typealias VM =  DetailPesionalViewModel
    
    var viewModel: DetailPesionalViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    
    private var materialTableView = AutoSizingTableView(frame: .zero, style: .plain)
    private var rateTableView = AutoSizingTableView(frame: .zero, style: .plain)
    
    private var headerView = PersionHeaderView()
    private var degreeView = DegreeGroupView()
    private var infoView = DetailInfomationWorkerView()
    private var skillView = PesionDetailSkillView()
    private var levelView = LevelWorkerView()
    
    private var sologanLabel = UILabel()
    
    private lazy var rateDataSource: RateTableViewDataSource = .init(data: viewModel.rates)
    private lazy var materialDataSource: MaterialTableViewDataSource = .init(data: viewModel.materials)
    
    init(viewModel: DetailPesionalViewModel) {
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
        
        rateTableView.delegate = rateDataSource
        rateTableView.dataSource = rateDataSource
        rateTableView.register(RateWorkerCell.nib(in: .main), forCellReuseIdentifier: RateWorkerCell.reuseId)
        rateTableView.register(ShowMoreCell.nib(in: .main), forCellReuseIdentifier: ShowMoreCell.reuseId)
        rateTableView.isScrollEnabled = false
        rateTableView.separatorStyle = .none
        
        navigationItem.title = "Thông tin cá nhân"
        rateDataSource.action = { [weak self] in
            DetailRateViewController(viewModel: .init()).push(from: self)
        }
        
        materialTableView.separatorStyle = .none
        materialTableView.delegate = materialDataSource
        materialTableView.dataSource = materialDataSource
        materialTableView.register(MaterialCell.nib(in: .main), forCellReuseIdentifier: MaterialCell.reuseId)
        materialTableView.register(WorkPriceCell.nib(in: .main), forCellReuseIdentifier: WorkPriceCell.reuseId)
        materialTableView.register(ShowMoreCell.nib(in: .main), forCellReuseIdentifier: ShowMoreCell.reuseId)
        materialTableView.isScrollEnabled = false
        
        materialDataSource.action = .init(createAction: { [weak self] in
            self?.viewModel.send(.createMaterial)
        }, editAction: { [weak self] index in
            self?.viewModel.send(.tapEditMaterial(index))
        }, showMoreAction: { [weak self] in
            MaterialViewController(viewModel: .init(), didUpdate: {
                self?.viewModel.send(.viewDidLoad)
            }).push(from: self)
        })
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        scrollView.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })
        
        rateTableView.squircle(radius: 8)
        materialTableView.squircle(radius: 8)
        materialTableView.backgroundColor = .BGNhat
        
        sologanLabel.textAlignment = .center
        sologanLabel.numberOfLines = 0
        sologanLabel.font = Fonts.italicFont(ofSize: .subtitle)
        
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(sologanLabel)
        mainStackView.addArrangedSubview(infoView)
        mainStackView.addArrangedSubview(degreeView)
        mainStackView.addArrangedSubview(skillView)
        mainStackView.addArrangedSubview(levelView)
        mainStackView.addArrangedSubview(materialTableView)
        mainStackView.addArrangedSubview(rateTableView)
        
        showInitialLoading()
        
        levelView.action = { [weak self] in
            self?.viewModel.send(.detailLevel)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("orderCustomerList"), object: nil)
        
    }
    
    @objc func handleNotification(_ notification: Notification) {
            if let objects = notification.object {
                guard let data = objects as? [Order] else { return }
                self.viewModel.send(.sendData(data))
            }
        }
    
    func bind(viewModel: DetailPesionalViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, sologan: { [weak self] text in
            self?.sologanLabel.text = text
        }, generic: { [weak self] data in
            self?.hideInitialLoading()
            self?.infoView.setValue(data: data)
        }, header: { [weak self] data in
            self?.headerView.setValue(data: data)
        }, degree: { [weak self] datas in
            self?.degreeView.updateView(datas: datas)
        }, rate: { [weak self] rates in
            self?.rateDataSource.setData(data: rates)
            self?.rateTableView.reloadData()
        }, materials: { [weak self] materials in
            self?.materialDataSource.setData(data: materials)
            self?.materialTableView.reloadData()
        }, createMaterial: { [weak self] material in
            CreateMaterialViewController(viewModel: .init(oldMaterials: material), didCreateMaterial: { [weak self] in
                self?.viewModel.send(.viewDidLoad)
            }).push(from: self)
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh bảo", message: error, present: self)
        }, editMaterial: { [weak self] index, value in
            guard let self = self else { return }
            var material = value
            
            let editView = EditMaterialView()
            editView.updateView(material: material)
            editView.action = .init(confirmAction: { [weak self] in
                Popup.hide()
                self?.viewModel.send(.updateMaterial(index, material))
            }, updateName: { name in
                material.updateName(name: name ?? "")
            }, updateUnit: { unit in
                material.updateUnit(unit: unit ?? "")
            }, updatePrice: { price in
                material.updatePrice(price: Formatter.shared.number(from: price))
            })
            
            Popup.show(present: self, customView: editView)
        }, skill: { [weak self] skill in
            self?.skillView.updateView(subTitle: skill)
        }, level: { [weak self] item in
            self?.levelView.updateView(data: item)
        }, detalLevel: { [weak self]job in
            DetailJobLevelViewController(viewModel: .init(job: job)).present(from: self)
        }))
        viewModel.send(.viewDidLoad)
    }

}

class RateTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data: [DetailPesionalViewModel.RateValue]
    
    var action: (() -> Void)?
    
    public init(data: [DetailPesionalViewModel.RateValue]) {
        self.data = data
    }
    
    public func setData(data: [DetailPesionalViewModel.RateValue]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count > 3 ? 4 : data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RateHeaderView()
        headerView.updateView(data: self.data)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(type: RateWorkerCell.self, for: indexPath)
            cell.updateView(rate: data[indexPath.row])
            return cell
        }
        let showMoreCell = tableView.dequeueReusableCell(type: ShowMoreCell.self, for: indexPath)
        showMoreCell.showMoreAction = { [weak self] in
            self?.action?()
        }
        return showMoreCell
    }
}

class MaterialTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data: [Material]
    
    struct Action {
        var createAction: () -> Void
        var editAction: (Int) -> Void
        var showMoreAction: () -> Void
    }
    
    var action: Action?
    
    public init(data: [Material]) {
        self.data = data
    }
    
    
    public func setData(data: [Material]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count > 5 ? 6 : data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MeterialHeaderShowMoreView()
        headerView.createAction = { [weak self] in
            self?.action?.createAction()
        }
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 5 {
            let cell = tableView.dequeueReusableCell(type: MaterialCell.self, for: indexPath)
            cell.updateView(data: data[indexPath.row])
            cell.editAction = { [weak self] in
                self?.action?.editAction(indexPath.row)
            }
            return cell
        }
        let showMoreCell = tableView.dequeueReusableCell(type: ShowMoreCell.self, for: indexPath)
        showMoreCell.showMoreAction = { [weak self] in
            self?.action?.showMoreAction()
        }
        return showMoreCell
    }
    
}
