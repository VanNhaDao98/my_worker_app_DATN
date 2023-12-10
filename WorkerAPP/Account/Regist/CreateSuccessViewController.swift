//
//  CreateSuccessViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 05/11/2023.
//

import UIKit
import Presentation
import UIComponents

class CreateSuccessViewController: BaseViewController {
    
    private var successView = SuccessView()
    private var loginButton = Button().makePrimary()
    
    override init() {
        super.init()
        useContentView = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(successView)
        successView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        loginButton.action = {
            let mainTabbar = MainTabbarViewController()
            UIApplication.shared.keyWindow?.rootViewController = mainTabbar
        }
        
        loginButton.title = "Đăng nhập"
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        })
        
        loginButton.squircle(radius: 24)
    }
}
