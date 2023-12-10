//
//  AddDegreeTableViewCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 04/11/2023.
//

import UIKit
import UIComponents

class AddDegreeTableViewCell: UITableViewCell {

    @IBOutlet private var addButton: Button!
    
    public var action: (() -> Void)? {
        get { addButton.action }
        set { addButton.action = newValue}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.config.style = .outline
        addButton.title = "Thêm bằng cấp"
        addButton.squircle(radius: 24)
        selectionStyle = .none
    }
    
}
