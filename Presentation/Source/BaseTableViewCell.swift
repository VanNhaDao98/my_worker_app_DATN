//
//  BaseTableViewCell.swift
//  Presentation
//
//  Created by Dao Van Nha on 09/10/2023.
//

import UIKit
import Utils

open class BaseTableViewCell: UITableViewCell {

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonSetup()
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        tintColor = ColorConstant.primary
    }
    
    open func setupView() {
        
    }
    
}
