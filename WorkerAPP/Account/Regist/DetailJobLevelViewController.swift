//
//  DetailJobLevelViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils


class DetailJobLevelViewController: BaseViewController, MVVMViewController {
    
    typealias VM = DetailJobLevelViewModel
    
    var viewModel: DetailJobLevelViewModel
    
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()

    
    init(viewModel: DetailJobLevelViewModel) {
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
        title = "Chi tiết cấp bậc"
        scrollView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
        })
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        })
        backButton = ImageConstant.icClose
        tapBackAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        
    }
    
    func bind(viewModel: DetailJobLevelViewModel) {
        viewModel.config(.init(item: { [weak self] items in
            self?.stackView.removeArrangedSubviews()
            for item in items {
                let view = RankJobView(item: item)
                self?.stackView.addArrangedSubview(view)
            }
        }))
        viewModel.send(.viewDidLoad)
    }

}
