//
//  ActionView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 17/10/2023.
//

import Foundation
import UIKit

public class ActionView: UIControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    public var action: (() -> Void)?
    public var defaultBackgroundColor: UIColor = .white
    public var highlightedBackgroundColor: UIColor = .white.darken()
    
    private func setupViews() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    @objc private func handleTouchDown() {
        transitionCrossDissolve {
            self.backgroundColor = self.highlightedBackgroundColor
        }
    }
    
    @objc private func handleTouchUp() {
        transitionCrossDissolve {
            self.backgroundColor = self.defaultBackgroundColor
        }
    }
    
    @objc private func handleAction() {
        action?()
    }
}
