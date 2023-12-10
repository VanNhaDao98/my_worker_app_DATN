//
//  WorkPriceCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class WorkPriceCell: UITableViewCell {
    @IBOutlet private var workPriceTitle: UILabel!
    @IBOutlet private var workPriceValue: UILabel!
    @IBOutlet private var editButton: AppBaseButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        workPriceTitle.font = Fonts.semiboldFont(ofSize: .title)
        workPriceTitle.textColor = ColorConstant.text
        
        workPriceValue.font = Fonts.semiboldFont(ofSize: .subtitle)
        workPriceValue.textColor = ColorConstant.text
        
        selectionStyle = .none
    }
    
}
