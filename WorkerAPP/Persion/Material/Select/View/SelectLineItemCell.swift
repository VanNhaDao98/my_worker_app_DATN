//
//  SelectLineItemCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/11/2023.
//

import UIKit
import Utils
import SDWebImage
import Domain

class SelectLineItemCell: UITableViewCell {
    @IBOutlet private var checkboxImage: UIImageView!
    @IBOutlet private var materialImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var countStackView: UIStackView!
    @IBOutlet private var countView: CountControl!
    
    public var updateQuantity: ((Double) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        materialImage.squircle(radius: 24)
        nameLabel.textColor = .text
        nameLabel.font = Fonts.mediumFont(ofSize: .medium)
        
        priceLabel.textColor = .text50
        priceLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        selectionStyle = .none
        
        countView.valueDidChanged = { [weak self] value in
            self?.updateQuantity?(value)
        }
    }
    
    public func updateView(lineItem: LineItem, currentLineItem: [LineItem]) {
        
        if let currentLine = currentLineItem.first(where: { $0.id == lineItem.id}) {
            checkboxImage.image = ImageConstant.icCheckboxSelected24pt
            countStackView.isHidden = false
            countView.currentValue = currentLine.quantity
        } else {
            checkboxImage.image = ImageConstant.icCheckboxDeselected24pt
            countStackView.isHidden = true
        }
        if let url = lineItem.imageUrl {
            materialImage.sd_setImage(with: url)
        } else {
            materialImage.image = ImageConstant.imageEmpty
        }
        
        nameLabel.text = lineItem.name
        priceLabel.text = .join([lineItem.price.currencyFormat(), lineItem.unit], separator: "/")
    }
    
    public func updateView(lineItem: LineItem) {
        checkboxImage.isHidden = true
        if let url = lineItem.imageUrl {
            materialImage.sd_setImage(with: url)
        } else {
            materialImage.image = ImageConstant.imageEmpty
        }
        countView.isHidden = false
        countView.currentValue = lineItem.quantity
        nameLabel.text = lineItem.name
        let price: String = .join([lineItem.price.currencyFormat(), lineItem.unit], separator: "/")
        priceLabel.text = "\(price) x \(lineItem.quantity.currencyFormat())"
    }
    
}
