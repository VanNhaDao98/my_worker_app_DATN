//
//  RechareView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class RechareView: CustomXibView {
    @IBOutlet private var titleLabel: HeaderLabel!
    @IBOutlet private var textField: TextField!
    @IBOutlet private var cancelButton: Button!
    @IBOutlet private var confirmButton: Button!
    @IBOutlet private var warningLabel: UILabel!
    
    struct Action {
        var confirm: () -> Void
        var codeDidChanged: (String?) -> Void
    }
    
    var action: Action?
    
    override func configeViews() {
        super.configeViews()
        
        titleLabel.text = "Nhập thẻ nạp"
        textField.placeholder = "Nhập mã thẻ"
        textField.isRequired = true
        
        textField.textDidChanged = { [weak self] text in
            self?.warningLabel.isHidden = true
            self?.action?.codeDidChanged(text)
        }
        
        warningLabel.font = Fonts.italicFont(ofSize: .subtitle)
        warningLabel.textColor = .red90
        warningLabel.isHidden = true
        
        confirmButton.makePrimary()
        confirmButton.title = "Xác nhận"
        
        confirmButton.action = { [weak self] in
            if (self?.textField.text ?? "").isEmpty {
                self?.warningLabel.isHidden = false
                return
            }
            self?.action?.confirm()
        }
        cancelButton.title = "Hủy"
        cancelButton.config.primaryColor = .red90
        cancelButton.action = {
            Popup.hide()
        }
        
        [cancelButton, confirmButton].forEach {
            $0?.squircle(radius: 24)
        }
    }

}
