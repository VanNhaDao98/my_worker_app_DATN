//
//  UiViewController+Exts.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import Utils
import FloatingPanel

extension UIViewController {
    public func showAsBottomSheet(config: BottomSheetConfig = .default,
                                  from presenter: UIViewController,
                                  present: Bool = true) -> UIViewController {
        let fpc = CustomFloatingPanelController(supportedSizes: config.sizes)
        fpc.isRemovalInteractionEnabled = config.dismissable
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = config.dismissable
        fpc.surfaceView.appearance = SurfaceAppearance().with {
            $0.cornerRadius = 16.0
            $0.shadows = [.init().with({ $0.opacity = 0.3 })]
            
            if #available(iOS 13.0, *) {
                $0.cornerCurve = .continuous
            }
        }
        fpc.surfaceView.grabberHandle.isHidden = config.sizes.count <= 1
        fpc.surfaceView.grabberHandle.barColor = .hex(0xDDE0E2)
        fpc.surfaceView.grabberHandlePadding = -10.0
        fpc.surfaceView.grabberHandleSize = .init(width: 40, height: 4)
        fpc.set(contentViewController: self)
        
        self.view.layoutIfNeeded()
        
        switch config.keyboardHandlingMode {
        case .disabled, .updateHeight:
            fpc.moveToFullWhenHandleKeyboard = false
        case .moveToFull:
            fpc.moveToFullWhenHandleKeyboard = true
        }
        
        if let vc = self as? BottomSheet, let scrollView = vc.sheetScrollView {
            fpc.track(scrollView: scrollView)
        } else if let nav = self as? UINavigationController,
                  let vc = nav.topViewController as? BottomSheet,
                  let scrollView = vc.sheetScrollView {
            fpc.track(scrollView: scrollView)
        }
        
        fpc.contentMode = .fitToBounds
        
        if present {
            presenter.present(fpc, animated: true, completion: nil)
        } else {
            fpc.addPanel(toParent: presenter, at: 0)
        }
        return fpc
    }
}

class BottomSheetButtonView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        let button = Button()
        view.addSubview(button)
        button.snp.makeConstraints({
            $0.edges.equalTo(view.safeAreaLayoutGuide).priority(999)
        })
    }
}

