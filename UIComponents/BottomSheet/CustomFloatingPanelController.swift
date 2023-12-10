//
//  CustomFloatingPanelController.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import FloatingPanel

class CustomFloatingPanelController: FloatingPanelController, FloatingPanelControllerDelegate {
    private var lastState: FloatingPanelState?
    private let panelLayout: DefaultPanelLayout
    
    private var observers: [NSObjectProtocol] = []
    
    var moveToFullWhenHandleKeyboard: Bool = true
    
    init(supportedSizes: [BottomSheetConfig.Size]) {
        self.panelLayout = DefaultPanelLayout(supportedSizes: supportedSizes)
        
        super.init(delegate: nil)
        
        self.delegate = self
        self.behavior = DefaultBehavior()
        
        let showObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                guard self.view.window?.isKeyWindow ?? false else {
                    return
                }
                
                if self.moveToFullWhenHandleKeyboard {
                    self.lastState = self.state
                    self.panelLayout.forceAllowFull(true)
                    self.invalidateLayout()
                    self.moveToState(.full)
                } else {
                    self.lastState = self.state
                    self.invalidateLayout()
                }
            }
        
        let hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self, let lastState = self.lastState else { return }
                self.panelLayout.forceAllowFull(false)
                self.invalidateLayout()
                
                if self.panelLayout.anchors.keys.contains(lastState) {
                    self.move(to: lastState, animated: true)
                }
            }
        
        observers.append(contentsOf: [showObserver, hideObserver])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveToState(_ state: FloatingPanelState) {
        if panelLayout.anchors.keys.contains(state) {
            move(to: state, animated: true)
        } else {
            move(to: panelLayout.initialState, animated: true)
        }
    }
    
    deinit {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    // MARK: - FloatingPanelControllerDelegate
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        panelLayout
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
        if panelLayout.anchors.keys.contains(.tip) {
            return velocity.dy > 7
        }
        
        let height = fpc.view.window?.bounds.height ?? 0
        return height - location.y < 128 || velocity.dy > 7
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state != .full {
            UIResponder.findFirst()?.resignFirstResponder()
        }
    }
}

private class DefaultBehavior: FloatingPanelDefaultBehavior {
    override func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
        true
    }
}

private extension UIResponder {
    private weak static var first: UIResponder? = nil
    
    @objc
    private func __find_first_responder(sender: AnyObject) {
        UIResponder.first = self
    }
    
    static func findFirst() -> UIResponder? {
        UIApplication.shared.sendAction(#selector(__find_first_responder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.first
    }
}

