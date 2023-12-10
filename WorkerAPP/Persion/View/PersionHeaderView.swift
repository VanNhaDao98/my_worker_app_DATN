//
//  PersionHeaderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import Presentation
import Utils
import SDWebImage

class PersionHeaderView: CustomXibView {

    @IBOutlet private var avatarimage: UIImageView!
    @IBOutlet private var contractValue: UILabel!
    @IBOutlet private var contractTitle: UILabel!
    @IBOutlet private var customerValue: UILabel!
    @IBOutlet private var customerTitle: UILabel!
    @IBOutlet private var imageContainerView: UIView!
    override func configeViews() {
        super.configeViews()
        containerView.squircle()
        imageContainerView.squircle(radius: 50)
        imageContainerView.border(width: 5, color: ColorConstant.lineView)
        
        [contractTitle, customerTitle].forEach {
            $0?.textColor = .white
            $0?.font = Fonts.defaultFont(ofSize: .title)
        }
        [customerValue, contractValue].forEach {
            $0?.textColor = .white
            $0?.font = Fonts.boldFont(ofSize: .headerTitle)
        }
        
        customerTitle.text = "Khách hàng"
        contractTitle.text = "Hợp đồng"
    }
    
    public func setValue(data: DetailPesionalViewModel.Header) {
        if let imageUrl = data.url {
            avatarimage.sd_setImage(with: imageUrl)
        } else {
            avatarimage.image = ImageConstant.imageEmpty
        }
        
        customerValue.text = data.customerValue
        contractValue.text = data.orderValue
    }

}
