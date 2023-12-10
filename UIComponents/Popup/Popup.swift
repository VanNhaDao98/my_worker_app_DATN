//
//  Popup.swift
//  UIComponent
//
//  Created by Dao Van Nha on 25/10/2023.
//

import Foundation
import UIKit

public class AlertViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }
}

public class Popup {
    public static var vc = AlertViewController()
    
    public static func show(present: UIViewController,
                            customView: UIView) {
        for i in vc.view.subviews {
            i.removeFromSuperview()
        }
        vc.view.addSubview(customView)
        customView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        })
        customView.squircle(radius: 12)
        customView.layer.shadowColor = UIColor.gray.cgColor
        customView.layer.shadowOpacity = 0.5
        customView.layer.shadowOffset = .zero
        customView.layer.shadowRadius = 5
        vc.modalPresentationStyle = .overCurrentContext
        present.present(vc, animated: false)
    }
    
    public static func showConfirmValue(title: String? = nil,
                                        subTitle: String? = nil,
                                        returnAction: (() -> Void)? = nil,
                                        confirmAction: (() -> Void)? = nil,
                                        present: UIViewController) {
        let popupView = ConfirmPopupView()
        popupView.title = title
        popupView.subTitle = subTitle
        popupView.returnAction = {
            returnAction?()
            Popup.hide()
        }
        
        popupView.confirmAction = {
            confirmAction?()
        }
        
        popupView.dismissAction = {
            Popup.hide()
        }
        
        Popup.show(present: present, customView: popupView)
    }
    
    public static func hide() {
        vc.dismiss(animated: false)
    }
}
