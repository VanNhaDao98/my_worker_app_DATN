//
//  DetailJobWebViewViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 24/11/2023.
//

import UIKit
import Presentation
import WebKit
import Utils
import UIComponents

class DetailJobWebViewViewController: BaseViewController {
    
    private var webView = WKWebView(frame: .zero, configuration: .init())
    private var stringUrl: String
    
    init(stringUrl: String) {
        self.stringUrl = stringUrl
        super.init()
        useContentView = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        contentView.addSubview(webView)
        enableHeaderView(pintoView: webView)
        webView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        title = "Chi tiết cấp bậc"
        loadURL()
    }
    

    func loadURL() {
        if let url = URL(string: self.stringUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension DetailJobWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loading.shared.showLoading(view: self.view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loading.shared.showLoading(view: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            Popup.showConfirmValue(title: "Thông báo", subTitle: "Load thông tin thất bại, chúng tôi rất tiếc vì sự cố trên",present: self)
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loading.shared.hideLoading()
    }
}

