//
//  HeaderLabel.swift
//  UIComponent
//
//  Created by Dao Van Nha on 28/10/2023.
//

import UIKit
import Utils

open class HeaderLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.font = Fonts.mediumFont(ofSize: .title)
        self.textColor = ColorConstant.text
    }

}
