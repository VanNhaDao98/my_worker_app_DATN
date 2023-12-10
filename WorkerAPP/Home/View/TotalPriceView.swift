//
//  TotalIncomeView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class TotalPriceView: CustomXibView {
    @IBOutlet private var rechargeButton: AppBaseButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priceValueLabel: UILabel!
    
    public var rechargeAction: (() -> Void)? {
        get { rechargeButton.action }
        set { rechargeButton.action = newValue }
    }
    
    override func configeViews() {
        super.configeViews()
        
        [titleLabel, priceValueLabel].forEach {
            $0?.textColor = .white
        }
        
        titleLabel.font = Fonts.defaultFont(ofSize: .popupTitle)
        titleLabel.text = "Tổng tiền"
        
        priceValueLabel.font = Fonts.boldFont(ofSize: .custom(30))
        
        squircle(radius: 8)
    }
    
    public func setValue(totalMoney: String) {
        self.priceValueLabel.text = totalMoney
    }

}
