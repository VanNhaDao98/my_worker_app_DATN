//
//  CreateWorkerJobDetailViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 24/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class CreateWorkerJobDetailViewController: BaseViewController, MVVMViewController {
    
    typealias VM = CreateWorkerJobDetailViewModel
    
    var viewModel: CreateWorkerJobDetailViewModel
    
    private var completeButton = Button().makePrimary()
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
  
    private var wokerView = DetailLevelView()
    
    init(viewModel: CreateWorkerJobDetailViewModel) {
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
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12,
                                               left: 16,
                                               bottom: 12,
                                               right: 16)
        stackView.spacing = 16
        contentView.addSubview(scrollView)
        enableHeaderView(pintoView: scrollView)
        title = "Tạo tài khoản"
        scrollView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
        })
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })
        
        let noteView = ConnectLevelJobView()
        noteView.action = { [weak self] in
            self?.viewModel.send(.tapReference)
        }
        noteView.squircle(radius: 8)
        let headerView = CreateWorkerHeaderView()
        headerView.setValue(title: "Chọn ngành nghề của bạn", subTitle: "Khách hàng sẽ dựa vào ngành nghề này để tìm kiếm đến bạn")
        headerView.addView(noteView)
        
        let spacingView = UIView()
        spacingView.backgroundColor = .ink05
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(wokerView)
        
        wokerView.action = .init(selected: { [weak self] in
            self?.viewModel.send(.tapChooseJob)
        }, selectLevel: { [weak self] in
            self?.viewModel.send(.tapLevel)
        }, updateSkill: { [weak self] detail in
            self?.viewModel.send(.updateDetailLevel(detail ?? ""))
        })
        
        completeButton.action = { [weak self] in
            self?.viewModel.send(.complete)
        }
        
        completeButton.title = "Hoàn tất"
        
        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        })
        completeButton.squircle(radius: 24)
    }
    
    
    func bind(viewModel: CreateWorkerJobDetailViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, jobs: { [weak self] jobs in
            guard let self = self else { return }
            
            BottomSheet.show(items: jobs.map({ $0.bottomSheetItem()}),
                             title: "Công việc",
                             searchable: true,
                             from: self) { _, values in
                if let value = values.first {
                    self.viewModel.send(.updateJob(value))
                }
            }
        }, item: { [weak self] item in
            self?.wokerView.upateView(item: item)
        }, urlreference: { [weak self] job in
            DetailJobLevelViewController(viewModel: .init(job: job)).present(from: self)
        }, levels: { [weak self] items in
            guard let self = self else { return }
            BottomSheet.show(items: items.map({ $0.bottomSheetItem()}),
                             title: "Cấp độ",
                             searchable: true,
                             from: self) { _, values in
                if let value = values.first {
                    self.viewModel.send(.updateLevel(value))
                }
            }
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Thông báo", message: error, present: self)
        }, didComplete: { [weak self] in
            CreateSuccessViewController().push(from: self)
        }))
        viewModel.send(.viewDidLoad)
    }
    
}
