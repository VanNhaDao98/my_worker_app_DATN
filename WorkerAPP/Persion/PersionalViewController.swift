//
//  PersionViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 16/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class PersionalViewController: BaseViewController, MVVMViewController {
    
    typealias VM =  PersionalViewModel
    
    var viewModel: PersionalViewModel = .init()
    
    
    private var headerView = PersionHeaderView()
    
    private var sologanLabel = UILabel()
    
    private var persionalInfoView = PersionalInfoView()
    private var workView = WorkInfoView()
    private var supportView = SupportPersionalView()
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    private var logoutButton = Button()
    
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
        navigationItem.title = "Trang cá nhân"
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
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
        let containerView = UIView()
        containerView.backgroundColor = .red

        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(sologanLabel)
        mainStackView.addArrangedSubview(persionalInfoView)
        mainStackView.addArrangedSubview(workView)
        mainStackView.addArrangedSubview(supportView)
        
        
        mainStackView.addArrangedSubview(containerView)
        containerView.squircle(radius: 8)

        sologanLabel.textAlignment = .center
        sologanLabel.numberOfLines = 0
        sologanLabel.font = Fonts.italicFont(ofSize: .subtitle)
        
        logoutButton.title = "Đăng xuất"
        logoutButton.config.style = .outline
        logoutButton.config.primaryColor = .red
        logoutButton.squircle(radius: 8)
        
        
        persionalInfoView.action = .init(infoAction: { [weak self] in
            self?.viewModel.send(.detailAccount)
        }, addressAction: {
            
        }, degreeAction: {
            
        })
        
        workView.action = .init(workTypeAction: {
            
        }, materialAction: { [weak self] in
            MaterialViewController(viewModel: .init(), didUpdate: {
                self?.viewModel.send(.viewDidLoad)
            }).push(from: self)
        })
        
        supportView.action = .init(passwordAction: { [weak self] in
            self?.viewModel.send(.updatePassword)
        }, supportAction: { [weak self] in
            Utility.call(phoneNumber: "0962001538")
        })
        
        contentView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        }
        
        logoutButton.squircle(radius: 24)
        
        logoutButton.action = { [weak self] in
            self?.viewModel.send(.logout)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("orderCustomerList"), object: nil)
        
        self.showInitialLoading()
    }
    
    @objc func handleNotification(_ notification: Notification) {
            if let objects = notification.object {
                guard let data = objects as? [Order] else { return }
                self.viewModel.send(.sendData(data))
            }
        }
    
    func bind(viewModel: PersionalViewModel) {
        viewModel.config(.init(loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, describe: { [weak self] text in
            self?.sologanLabel.text = text
            self?.hideInitialLoading()
        }, detailAccount: { [weak self] account in
            DetailPesionalViewController(viewModel: .init(account: account)).push(from: self)
        }, logout: {
            let storyBoard: UIStoryboard = .init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            let nav = BaseNavigationViewController(rootViewController: vc!)
            UIApplication.shared.keyWindow?.rootViewController = nav
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh báo",
                            message: error,
                            present: self)
        }, header: { [weak self] data in
            self?.headerView.setValue(data: data)
        }, success: { success in
            AlertUtils.show( title: "Thông báo",
                             message: success,
                             present: self)
        }, updatePassword: { [weak self] in
            guard let self = self else { return }
            let view = UpdatePasswordView()
            var password: String = ""
            var confirmPassword = ""
            
            view.action = .init(dismiss: {
                Popup.hide()
            }, confirm: {
                if password != confirmPassword {
                    view.setHiddenWarning(false)
                } else {
                    Popup.hide()
                    self.viewModel.send(.confirmUpddatePassword(password))
                }
            }, passwordDidChanged: { value in
                password = value ?? ""
            }, confirmPasswordDidChanged: { value in
                confirmPassword = value ?? ""
            })
            
            Popup.show(present: self.tabBarController!, customView: view)
        }))
        viewModel.send(.viewDidLoad)
    }

}

