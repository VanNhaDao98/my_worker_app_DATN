//
//  RateWorkerCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import Utils

class RateWorkerCell: UITableViewCell {

    @IBOutlet private var createOnLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var start5: UIImageView!
    @IBOutlet private var start4: UIImageView!
    @IBOutlet private var start3: UIImageView!
    @IBOutlet private var start1: UIImageView!
    @IBOutlet private var start2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        nameLabel.font = Fonts.semiboldFont(ofSize: .default)
        nameLabel.textColor = ColorConstant.text
        rateLabel.textColor = ColorConstant.text
        rateLabel.font = Fonts.defaultFont(ofSize: .default)
        createOnLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        createOnLabel.textColor = ColorConstant.grayText
        contentView.backgroundColor = ColorConstant.BGNhat
    }
    
    public func updateView(rate: DetailPesionalViewModel.RateValue) {
        nameLabel.text = rate.customerName
        createOnLabel.text = rate.createOn
        rateLabel.text = rate.comment
        
        [start1, start2, start3, start4, start5].forEach { image in
            if image?.tag ?? 0 <= Int(rate.rate) {
                image?.image = ImageConstant.srartSelect
            } else {
                image?.image = ImageConstant.startGray
            }

        }
    }
    
}
