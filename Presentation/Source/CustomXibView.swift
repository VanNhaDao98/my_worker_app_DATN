//
//  CustomXibView.swift
//  Presentation
//
//  Created by Dao Van Nha on 08/10/2023.
//

import Foundation
import UIKit

public protocol CustomXibViewSupport {
    var nibName: String { get }
    var containerView: UIView { get }
    func loadViews()
}

extension CustomXibViewSupport where Self: UIView {
    public func loadViews() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}

open class CustomXibView: UIView, CustomXibViewSupport {
    
    @IBOutlet private var _containerView: UIView!
    
    public var nibName: String {
        return String(describing: type(of: self))
    }
    
    public var containerView: UIView {
        if _containerView == nil {
            fatalError("_containerView is not connected to XIB with name \"\(nibName)\"")
        }
        return _containerView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
        configeViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViews()
        configeViews()
    }
    
    open func configeViews() {
        
    }
    
}
