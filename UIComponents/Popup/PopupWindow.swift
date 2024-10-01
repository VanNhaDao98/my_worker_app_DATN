//
//  PopupWindow.swift
//  UIComponents
//
//  Created by Dao Van Nha on 01/10/2024.
//

import Foundation
import UIKit
import SnapKit

open class PopupWindow: AnimatedWIndow {
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        return view
    }()
    
    public var subView: UIView = {
        
        let customView = UIView()
        customView.squircle(radius: 12)
        customView.layer.shadowColor = UIColor.gray.cgColor
        customView.layer.shadowOpacity = 0.5
        customView.layer.shadowOffset = .zero
        customView.layer.shadowRadius = 5
        
        return customView
    }()
    
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
    
    public override func fadeIn(comptele: @escaping () -> Void) {
        comptele()
    }
    
    public override func fadeOut(comptele: @escaping () -> Void) {
        comptele()
    }
    
    private func setupViews() {
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        backgroundView.addSubview(subView)
        
        subView.snp.makeConstraints({
            $0.center.equalToSuperview()
            
//            $0.leading.trailing.equalToSuperview().inset(24)
            
            
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped() {
        hide {
            
        }
    }
}
