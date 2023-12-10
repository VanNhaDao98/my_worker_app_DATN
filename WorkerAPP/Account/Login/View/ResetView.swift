//
//  ResetView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 03/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class ResetView: CustomXibView {
    @IBOutlet weak var titleLabel: HeaderLabel!
    @IBOutlet weak var emailTextField: TextFieldTitle!
    
    @IBOutlet weak var confirmButton: Button!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cancelButton: Button!
    @IBOutlet weak var noteLabel: UILabel!
    
    struct Action {
        var dismiss: () -> Void
        var confirm: () -> Void
        var valueDIdChanged: (String?) -> Void
    }
    
    var action: Action?
    
    private var email: String = ""
    
    override func configeViews() {
        super.configeViews()
        
        titleLabel.text = "Quên mật khẩu"
        emailTextField.title = "Xác nhận email"
        emailTextField.isRequired = true
        emailTextField.placeholder = "Nhập email"
        
        emailTextField.textDidChanged = { [weak self] text in
            self?.email = text ?? ""
            self?.warningLabel.isHidden = true
            self?.action?.valueDIdChanged(text)
        }
        
        cancelButton.title = "Trở về"
        cancelButton.config.style = .outline
        cancelButton.config.primaryColor = .red
        
        confirmButton.title = "Xác nhận"
        confirmButton.config.primaryColor = .red
        confirmButton.setTitleColor(.white, for: .normal)
        
        warningLabel.text = "* Địa chỉ email sai định dạng"
        warningLabel.font = Fonts.italicFont(ofSize: .subtitle)
        warningLabel.textColor = .red
        warningLabel.isHidden = true
        
        [cancelButton, confirmButton].forEach({
            $0?.squircle(radius: 24)
        })
        
        cancelButton.action = { [weak self] in
            self?.action?.dismiss()
        }
        
        confirmButton.action = { [weak self] in
            if (self?.email ?? "").isEmpty {
                self?.warningLabel.text = "* Vui lòng nhập địa chỉ email"
                self?.warningLabel.isHidden = false
                return
            }
            
            if !(self?.email ?? "").isValidEmail() {
                self?.warningLabel.text = "* Địa chỉ email sai định dạng"
                self?.warningLabel.isHidden = false
                return
            }
            
            self?.action?.confirm()
        }
        
        noteLabel.font = Fonts.italicFont(ofSize: .subtitle)
        noteLabel.textColor = ColorConstant.primary
        noteLabel.text = "Hệ thống sẽ ghi nhận yêu cầu của bạn và sẽ xử lý ngay lập tức"
    }


}
