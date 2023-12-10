//
//  EditMaterialView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Domain
import Utils

class EditMaterialView: CustomXibView {

    @IBOutlet private var validateLabel: UILabel!
    @IBOutlet private var confirmButton: Button!
    @IBOutlet private var cancelButton: Button!
    @IBOutlet private var unitTextFIeld: TextField!
    @IBOutlet private var priceTextField: TextField!
    @IBOutlet private var nameTextField: TextField!
    @IBOutlet private var dismissButton: UIButton!
    @IBOutlet private var titleLabel: HeaderLabel!
    
    struct Action {
        var confirmAction: () -> Void
        
        var updateName: (String?) -> Void
        var updateUnit: (String?) -> Void
        var updatePrice: (String?) -> Void
    }
    var action: Action?
    
    
    override func configeViews() {
        super.configeViews()
        titleLabel.text = "Sửa vật liệu"
        validateLabel.text = "Vui lòng điền đầy thủ giá trị thuộc tính"
        validateLabel.font = Fonts.italicFont(ofSize: .default)
        validateLabel.textColor = .red
        validateLabel.isHidden = true
        
        cancelButton.config.style = .outline
        cancelButton.title = "Hủy"
        
        confirmButton.makePrimary()
        confirmButton.title = "Lưu"
        
        confirmButton.squircle(radius: 24)
        cancelButton.squircle(radius: 24)
        
        unitTextFIeld.placeholder = "Đơn vị"
        unitTextFIeld.isRequired = true
        priceTextField.placeholder = "Giá vật liệu/Đơn vị"
        priceTextField.isRequired = true
        priceTextField.enableNumberInput()
        nameTextField.placeholder = "Tên vật liệu"
        nameTextField.isRequired = true
        
        unitTextFIeld.textDidChanged = { [weak self] text in
            self?.validateLabel.isHidden = true
            self?.action?.updateUnit(text)
        }
        
        nameTextField.textDidChanged = { [weak self] text in
            self?.validateLabel.isHidden = true
            self?.action?.updateName(text)
        }
        
        priceTextField.textDidChanged = { [weak self] text in
            self?.validateLabel.isHidden = true
            self?.action?.updatePrice(text)
        }
    }
    
    public func updateView(material: Material) {
        nameTextField.text = material.name
        unitTextFIeld.text = material.unit
        priceTextField.text = material.price.currencyFormat()
    }

    @IBAction func confirmAction(_ sender: Any) {
        if (nameTextField.text ?? "").isEmpty || (priceTextField.text ?? "").isEmpty || (unitTextFIeld.text ?? "").isEmpty {
            self.validateLabel.isHidden = false
            return
        }
        action?.confirmAction()
    }
    @IBAction func cancelAction(_ sender: Any) {
        Popup.hide()
    }
    @IBAction func dismissAction(_ sender: Any) {
        Popup.hide()
    }
}
