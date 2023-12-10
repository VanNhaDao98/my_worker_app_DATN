//
//  EmptyCellCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/11/2023.
//

import UIKit
import Utils

class EmptyCellCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        titleLabel.textColor = .text
        titleLabel.text = "Rất tiếc chúng tôi không tìm thấy kết quả!"
    }
    
    public func setTitle(title: String) {
        self.titleLabel.text = title
    }
}
