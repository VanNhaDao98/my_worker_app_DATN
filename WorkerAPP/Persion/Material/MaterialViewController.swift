//
//  MaterialViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class MaterialViewController: BaseViewController, MVVMViewController {
    typealias VM = MaterialViewModel
    
    var viewModel: MaterialViewModel
    
    public var didUpdate: () -> Void
    
    init(viewModel: MaterialViewModel, didUpdate: @escaping () -> Void) {
        self.viewModel = viewModel
        self.didUpdate = didUpdate
        super.init()
        useContentView = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView = BaseTableView(frame: .zero, style: .plain).then {
        $0.improveTouchesBehavior = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    func setupView() {
        isHiddenNavigationBar = false
        navigationItem.title = "Vật liệu"
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MaterialCell.nib(in: .main), forCellReuseIdentifier: MaterialCell.reuseId)
        tableView.register(EmptyCellCell.nib(in: .main), forCellReuseIdentifier: EmptyCellCell.reuseId)
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        })
        
        showInitialLoading()
    }
    
    func bind(viewModel: MaterialViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, reloadView: { [weak self] in
            self?.hideInitialLoading()
            self?.tableView.reloadData()
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh bảo", message: error, present: self)
        }, createMaterial: { [weak self] material in
            CreateMaterialViewController(viewModel: .init(oldMaterials: material), didCreateMaterial: { [weak self] in
                self?.viewModel.send(.viewDidLoad)
                self?.didUpdate()
            }).push(from: self)
        }, editMaterial: { [weak self] index, value in
            guard let self = self else { return }
            var material = value
            
            let editView = EditMaterialView()
            editView.updateView(material: material)
            editView.action = .init(confirmAction: { [weak self] in
                Popup.hide()
                self?.viewModel.send(.edit(index, material))
            }, updateName: { name in
                material.updateName(name: name ?? "")
            }, updateUnit: { unit in
                material.updateUnit(unit: unit ?? "")
            }, updatePrice: { price in
                material.updatePrice(price: Formatter.shared.number(from: price))
            })
            
            Popup.show(present: self, customView: editView)

        }, didUpdateMaterial: { [weak self] in
            self?.didUpdate()
        }))
        viewModel.send(.viewDidLoad)
    }
    
}

extension MaterialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.maretialValue.isEmpty ? 1 : viewModel.maretialValue.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MaterialHeaderView()
        headerView.create = { [weak self] in
            self?.viewModel.send(.create)
        }
        
        headerView.search = { [weak self] query in
            self?.viewModel.send(.search(query: query))
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.maretialValue.isEmpty {
            let cell = tableView.dequeueReusableCell(type: EmptyCellCell.self, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(type: MaterialCell.self, for: indexPath)
            cell.updateView(data: viewModel.maretialValue[indexPath.row])
            cell.editAction = { [weak self] in
                self?.viewModel.send(.tapEdit(indexPath.row))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AlertUtils.show(title: "Bạn có chắc muốn xóa vật liệu này",
                            message: "Khi đã xác nhận xóa bạn sẽ không thể khôi phục lại được",
                            confirmTitle: "Đồng ý",
                            confirmAction: {
                self.viewModel.send(.remove(indexPath.row))
            }, cancelTitle: "Hủy",
                            present: self)
        }
    }
    
}
