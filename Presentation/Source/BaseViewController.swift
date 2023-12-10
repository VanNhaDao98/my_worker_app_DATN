//
//  BaseViewController.swift
//  Presentation
//
//  Created by Dao Van Nha on 09/10/2023.
//

import UIKit
import UIComponents

open class BaseViewController: UIViewController {
    
    public var isHiddenNavigationBar: Bool = false {
        didSet {
            invalidateNavigationBarHiddenState(animated: true)
        }
    }
    
    public var useContentView: Bool = false
    private var headerView: NavigationHeader?
    
    public var tapBackAction: (() -> Void)?
    
    @IBOutlet var _contentView: UIView?
    
    public var contentView: UIView {
        _contentView ?? view
    }
    
    public var backButton: UIImage? {
        didSet {
            headerView?.setBackButton(icon: backButton)
        }
    }
    
    open override var title: String? {
        didSet {
            headerView?.title = title
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: .main)
    }
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil ?? .main)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var initialLoadingView: DefaultIndicatorView?
    private var initialHeaderView: UIView?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if useContentView && _contentView == nil {
            _contentView = UIView()
            view.addSubview(_contentView!)
            _contentView?.translatesAutoresizingMaskIntoConstraints = false
            _contentView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            _contentView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            _contentView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            _contentView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
    
        self.view.backgroundColor = .white
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        invalidateNavigationBarHiddenState(animated: true)
        
    }
    
    
    public func showInitialLoading() {
        guard let contentView = _contentView else {
            return
        }
        
        if initialLoadingView != nil {
            return
        }
        
        contentView.isHidden = true
        
        let indicator = DefaultIndicatorView(minDurationBeforeVisible: 0)
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        indicator.layer.shadowOpacity = 0
        indicator.show()
        
        initialLoadingView = indicator
        
        if let headerView = headerView {
            initialHeaderView = buildHeaderView(into: view).then({
                self.view.sendSubviewToBack($0)
            })
        }
    }
    
    public func hideInitialLoading(delay: DispatchTimeInterval? = nil) {
        guard let contentView = _contentView else {
            return
        }
        
        guard initialLoadingView != nil else {
            return
        }
        
        func hide() {
            initialLoadingView?.hide(duration: 0.3) {
                self.initialLoadingView?.removeFromSuperview()
                self.initialHeaderView?.removeFromSuperview()
                
                self.initialLoadingView = nil
                self.initialHeaderView = nil
            }
            
            contentView.isHidden = false
            contentView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                contentView.alpha = 1
            }
        }
        
        if let delay {
            DispatchQueue.main.asyncAfter(deadline: .now() +  delay) {
                hide()
            }
        } else {
            hide()
        }
    }

    
    public func enableHeaderView(pintoView: UIView? = nil,
                                 isHiddenLeftButton: Bool = false, topConstant: CGFloat = 0) {
        self.headerView = self.buildHeaderView(into: _contentView ?? view)
        self.headerView?.isHiddenLeftButton = isHiddenLeftButton
        isHiddenNavigationBar = true
        if let pintoView, let headerView {
            pintoView.translatesAutoresizingMaskIntoConstraints = false
            pintoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: topConstant).isActive = true
        }
    }
    
    private func buildHeaderView(into parentView: UIView) -> NavigationHeader {
        let headerView = NavigationHeader(frame: .init(x: 0, y: 0, width: 300, height: 128))
        parentView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        headerView.leftAction = { [weak self] in
            if self?.tapBackAction == nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.tapBackAction?()
            }
        }

        headerView.title = title ?? navigationItem.title
        return headerView
    }
    
    public func customHeaderView(pinToView: UIView? = nil,
                                 headerView: UIView) {
        isHiddenNavigationBar = true
        let parrentView = _contentView ?? view
        parrentView?.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        if let pinToView {
            pinToView.translatesAutoresizingMaskIntoConstraints = false
            pinToView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        }
    }
    
    private func checkLeaks() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            if let self {
                print("⚠️⚠️⚠️⚠️⚠️ \(type(of: self)) DOES NOT DEINIT AFTER 1s, CHECK FOR LEAKS NOW ⚠️⚠️⚠️⚠️⚠️")
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
        let vc = parent ?? self
        if vc.isBeingDismissed {
            checkLeaks()
        }
    }
    
    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            checkLeaks()
        }
    }
    
}

extension BaseViewController: HiddenNavigationBarSupport {
    public var shouldNavigationHiddenBar: Bool {
        return self.isHiddenNavigationBar
    }
}
