//
//  MaterialCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import UIComponents
import Utils
import Domain
import SDWebImage

class MaterialCell: UITableViewCell {
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var marerialName: UILabel!
    @IBOutlet weak var materialPrice: UILabel!
    @IBOutlet weak var editButton: AppBaseButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public var editAction: (() -> Void)? {
        get { editButton.action }
        set { editButton.action = newValue }
    }
    
    private func setupView() {
        imageVIew.squircle(radius: 24)
        marerialName.font = Fonts.mediumFont(ofSize: .default)
        marerialName.textColor = .text
        
        materialPrice.font =  Fonts.mediumFont(ofSize: .subtitle)
        materialPrice.textColor = .text
        contentView.backgroundColor = .BGNhat
        selectionStyle = .none
    }
    
    public func updateView(data: Material) {
        if let url = data.imageUrl {
            imageVIew.sd_setImage(with: url)
        } else {
            imageVIew.image = ImageConstant.imageEmpty
        }
        
        marerialName.text = data.name
        materialPrice.text = "\(data.price.currencyFormat())/ \(data.unit)"
    }
}
