//
//  BaseWindow.swift
//  UIComponents
//
//  Created by Dao Van Nha on 01/10/2024.
//

import Foundation
import UIKit

open class BaseWindow: UIWindow {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        rootViewController = WindowViewController()
    }
}

public class WindowViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: .main)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isHidden = true
    }
}


