//
//  CreateWorkerDegreeViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class CreateWorkerDegreeViewController: BaseViewController, MVVMViewController {

    typealias VM = CreateWorkerDegreeViewModel
    
    var viewModel: CreateWorkerDegreeViewModel 
    
    private var didConfirmDegree: (Worker) -> Void
    private var continueButton = Button().makePrimary()
    private var tableView = BaseTableView(frame: .zero, style: .grouped).then({
        $0.improveTouchesBehavior = true
    })
    
    private var imageIndex = 0
    
    init(viewModel: CreateWorkerDegreeViewModel,
         didConfirmDegree: @escaping (Worker) -> Void) {
        self.viewModel = viewModel
        self.didConfirmDegree = didConfirmDegree
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
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreateDegreeCell.nib(in: .main), forCellReuseIdentifier: CreateDegreeCell.reuseId)
        tableView.register(AddDegreeTableViewCell.nib(in: .main), forCellReuseIdentifier: AddDegreeTableViewCell.reuseId)
        contentView.addSubview(tableView)
        enableHeaderView(pintoView: tableView, topConstant: 8)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        continueButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
        continueButton.squircle(radius: 24)
        continueButton.title = "Hoàn thành"
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(tableView.snp.bottom).offset(16)
            $0.height.equalTo(48)
        }
        
        title = "Tạo tài khoản"
        
    }
    
    func bind(viewModel: CreateWorkerDegreeViewModel) {
        viewModel.config(.init(didConfirm: { [weak self] account in
            self?.didConfirmDegree(account)
            self?.navigationController?.popViewController(animated: true)
        }, loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo ", message: error, present: self)
        }, currentDegree: { [weak self] _ in
            self?.tableView.reloadData()
        }, level: { [weak self] index, items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem() }),
                             title: "Loại bằng",
                             from: self, didSelectItems: { _, values in
                guard let value = values.first else { return }
                self.viewModel.send(.updateLevel(index, value))
            })
        }, type: { [weak self] index, items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem() }),
                             title: "Trình độ",
                             from: self, didSelectItems: { _, values in
                guard let value = values.first else { return }
                self.viewModel.send(.updateType(index, value))
            })
        }, startTime: { [weak self] index, time in
            guard let self = self else { return }
            DatePicker.show(title: "Thời gian bắt đầu",
                            config: .init(mode: .date,
                                          date: time ?? Date(),
                                          maximumDate: Date()),
                            from: self) { value in
                self.viewModel.send(.updateStartTime(index, value))
            }
        }, endTime: { [weak self] index, time in
            guard let self = self else { return }
            DatePicker.show(title: "Thời gian kết thúc",
                            config: .init(mode: .date,
                                          date: time ?? Date(),
                                          maximumDate: Date()),
                            from: self) { value in
                self.viewModel.send(.updateEndTime(index, value))
            }
        }, reloadAtIndex: { [weak self] index in
            self?.tableView.reloadRows([index], inSection: 0)
        }, modeButton: { [weak self] isEnable in
            self?.continueButton.isEnabled = isEnable
        }))
        viewModel.send(.viewDidLoad)
    }

}

extension CreateWorkerDegreeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.accountDegreeValue.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.viewModel.accountDegreeValue.count{
            let cell = tableView.dequeueReusableCell(type: CreateDegreeCell.self, for: indexPath)
            cell.updasteView(data: .init(degree: self.viewModel.accountDegreeValue[indexPath.row]))
            cell.action = .init(universityDidChanged: { [weak self] name in
                self?.viewModel.send(.updateName(indexPath.row, name))
            }, levelAction: { [weak self] in
                self?.viewModel.send(.tapLevel(indexPath.row))
            }, typeAction: { [weak self] in
                self?.viewModel.send(.tapType(indexPath.row))
            }, startTimeAction: { [weak self] in
                self?.viewModel.send(.tapStartTime(indexPath.row))
            }, endTimeAction: { [weak self] in
                self?.viewModel.send(.tapEndTime(indexPath.row))
            }, profileDegreeDidChanged: { [weak self] text in
                self?.viewModel.send(.updateProfile(indexPath.row, text))
            })
            return cell
        }
        
        let buttonCell = tableView.dequeueReusableCell(type: AddDegreeTableViewCell.self, for: indexPath)
        buttonCell.action = { [weak self] in
            self?.viewModel.send(.addDegree)
        }
        return buttonCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CreateWorkerHeaderView()
        headerView.backgroundColor = .white
        headerView.setValue(title: "Bằng cấp", subTitle: "Nếu có bằng cấp, bạn sẽ tạo được uy tín và thu hút được khách hàng hơn.")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AlertUtils.show(title: "Bạn có chắc muốn xóa loại bằng trên",
                            message: "Khi đã xác nhận xóa bạn sẽ không thể khôi phục lại được",
                            confirmTitle: "Đồng ý",
                            confirmAction: {
                self.viewModel.send(.remove(indexPath.row))
            }, cancelTitle: "Hủy",
                            present: self)
        }
    }
    
}
