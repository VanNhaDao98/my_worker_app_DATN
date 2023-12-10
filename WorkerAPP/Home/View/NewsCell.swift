//
//  NewsCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 28/11/2023.
//

import UIKit
import Utils

class NewsCell: UITableViewCell {

    @IBOutlet private var bannerImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImage.squircle()
        
        titleLabel.textColor = .text
        titleLabel.font = Fonts.defaultFont(ofSize: .default)
        
        timeLabel.textColor = .text50
        timeLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        
        selectionStyle = .none
    }
    
    public func updateView(item: News) {
        bannerImage.image = item.image
        titleLabel.text = item.title
        timeLabel.text = item.subTitle
    }
    
}
