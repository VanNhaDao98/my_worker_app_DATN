//
//  NotiOrderCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 21/10/2023.
//

import UIKit
import UIComponents
import Utils

class NotiOrderCell: UITableViewCell {

    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var confirmButton: Button!
    @IBOutlet private var cancelButton: AppBaseButton!
    @IBOutlet private var agoLabel: UILabel!
    @IBOutlet private var notiLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var circleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        circleView.squircle(radius: 3)
        avatarImageView.squircle(radius: 20)
        notiLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        notiLabel.textColor = ColorConstant.text
        
        agoLabel.font = Fonts.defaultFont(ofSize: .small)
        agoLabel.textColor = ColorConstant.grayText
        
        cancelButton.setTitle(title: "Không đồng ý")
        cancelButton.setTitleColor(ColorConstant.primary, for: .normal)
        
        confirmButton.setTitle(title: "Đồng ý")
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.squircle(radius: 18)
        statusLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        statusLabel.textColor = ColorConstant.text50
    }
    
    public func demo(index: Int) {
        if index % 2 == 0 {
            contentView.backgroundColor = ColorConstant.primary5
            circleView.isHidden = false
            cancelButton.isHidden = false
            confirmButton.isHidden = false
            statusLabel.isHidden = true
        } else {
            contentView.backgroundColor = .white
            circleView.isHidden = true
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            statusLabel.isHidden = false
        }
    }
    
}
