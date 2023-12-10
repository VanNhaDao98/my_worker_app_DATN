//
//  CreateMaterialCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Domain

class CreateMaterialCell: UITableViewCell {
    @IBOutlet private var chooseImageView: ChooseImageView!
    @IBOutlet private var nameTextField: TextField!
    @IBOutlet private var unitTextField: TextField!
    @IBOutlet private var priceTextField: TextField!
    
    
    struct Action {
        var chooseImage: () -> Void
        var updateName: (String?) -> Void
        var updateUnit: (String?) -> Void
        var updatePrice: (String?) -> Void
    }
    
    var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public func setupView() {
        chooseImageView.chooseImageAction = { [weak self] in
            self?.action?.chooseImage()
        }
        
        nameTextField.textDidChanged = { [weak self] text in
            self?.action?.updateName(text)
        }
        
        unitTextField.textDidChanged = { [weak self] text in
            self?.action?.updateUnit(text)
        }
        
        priceTextField.textDidChanged = { [weak self] text in
            self?.action?.updatePrice(text)
        }
        
        nameTextField.placeholder = "Tên vật liệu"
        nameTextField.isRequired = true
        nameTextField.maxCharacterCount = 20
        
        unitTextField.placeholder = "Đơn vị"
        unitTextField.maxCharacterCount = 10
        unitTextField.isRequired = true
        
        priceTextField.placeholder = "Giá vật liệu/ 1 đơn vị"
        priceTextField.isRequired = true
        priceTextField.enableCurrencyInput()
        
        selectionStyle = .none
    }
    
    public func updateView(material: Material) {
        chooseImageView.updateView(image: material.image)
        nameTextField.text = material.name
        unitTextField.text = material.unit
        priceTextField.text = material.price.currencyFormat()
    }
}
