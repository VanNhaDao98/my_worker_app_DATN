//
//  HeaderTitleView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/11/2023.
//

import UIKit
import Presentation
import UIComponents

class HeaderTitleView: CustomXibView {
    @IBOutlet private var titleLabel: HeaderLabel!
    @IBOutlet private var addButton: AppBaseButton!
    
    public var action: (() -> Void)? {
        get { addButton.action }
        set { addButton.action = newValue }
    }
    
    override func configeViews() {
        super.configeViews()
    }
    public func setTitle(title: String) {
        self.titleLabel.text = title
    }

}
