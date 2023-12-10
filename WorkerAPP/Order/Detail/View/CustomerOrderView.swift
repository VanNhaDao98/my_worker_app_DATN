//
//  CustomerOrderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 11/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import SDWebImage
import Domain

class CustomerOrderView: CustomXibView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var birthDayLabel: UILabel!
    @IBOutlet private var addressView: LeftRightLabelView!
    @IBOutlet private var phoneNumberLabel: LeftRightLabelView!
    @IBOutlet private var callButton: UIButton!
    @IBOutlet private var mesengerButton: UIButton!
    @IBOutlet private var buttonStackView: UIStackView!
    struct Action {
        var callAction: () -> Void
        var mesengerAction: () -> Void
    }
    
    var action: Action?
    
    override func configeViews() {
        super.configeViews()
        imageView.squircle(radius: 26)
        titleLabel.font = Fonts.semiboldFont(ofSize: .title)
        titleLabel.textColor = .text
        titleLabel.text = "Khách hàng"
        
        nameLabel.font = Fonts.mediumFont(ofSize: .medium)
        nameLabel.textColor = .text
        
        birthDayLabel.textColor = .text50
        birthDayLabel.font = Fonts.defaultFont(ofSize: .default)
        
        [addressView, phoneNumberLabel].forEach({
            $0?.leftTextFont = Fonts.mediumFont(ofSize: .default)
            $0?.rightTextColor = .text50
            $0?.leftTextColor = .text
            $0?.rightTextFont = Fonts.defaultFont(ofSize: .default)
        })
        
        addressView.leftIcon = ImageConstant.locationPin
        phoneNumberLabel.leftIcon = ImageConstant.phone
        addressView.leftText = "Địa chỉ"
        phoneNumberLabel.leftText = "Số điện thoại"
        
    }

    @IBAction func callAction(_ sender: Any) {
        action?.callAction()
    }
    
    @IBAction func messengerAction(_ sender: Any) {
        action?.mesengerAction()
    }
    
    public func updateView(customer: OrderDetailViewModel.CustomerData) {
        if let url = customer.urlImage {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = ImageConstant.imageEmpty
        }
        
        switch customer.status {
        case .await, .confirm, .pending, .progress:
            self.buttonStackView.isHidden = false
            phoneNumberLabel.rightText = customer.phoneNumber
        default:
            self.buttonStackView.isHidden = true
            phoneNumberLabel.rightText = "---"
            
        }
        
        nameLabel.text = customer.name
        birthDayLabel.text = customer.birthday
        addressView.rightText = customer.address
    }
}
