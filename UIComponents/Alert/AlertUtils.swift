//
//  AlertUtils.swift
//  UIComponent
//
//  Created by Dao Van Nha on 25/10/2023.
//

import Foundation
import UIKit

public class AlertUtils {
    
    public static func show(title: String? = nil,
                            message: String? = nil,
                            confirmTitle: String? = nil,
                            confirmAction: (() -> Void)? = nil,
                            cancelTitle: String? = nil,
                            cancelAction: (() -> Void)? = nil,
                            present: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if let cancelTitle = cancelTitle {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: { _ in
                cancelAction?()
            }))
        }
        alert.addAction(UIAlertAction(title: confirmTitle ?? "Đồng ý", style: .default, handler: { _ in
            confirmAction?()
        }))
        present.present(alert, animated: true)
    }
}
