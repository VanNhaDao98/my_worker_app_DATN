//
//  MaterialHeaderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class MaterialHeaderView: CustomXibView {
    
    @IBOutlet private var searchView: SearchField!
    @IBOutlet private var addButton: AppBaseButton!
    @IBOutlet private var headerTitle: UILabel!
    
    public var search: ((String?) -> Void)? {
        get { searchView.textDidChanged}
        set { searchView.textDidChanged = newValue }
    }
    
    public var create: (() -> Void)? {
        get { addButton.action }
        set { addButton.action = newValue }
    }
    
    override func configeViews() {
        super.configeViews()
        headerTitle.font = Fonts.boldFont(ofSize: .title)
        headerTitle.textColor = ColorConstant.text
        headerTitle.text = "Thêm vật liệu"
        searchView.placeholder = "Tìm kiếm vật liệu"
    }
    
    public func updateView(title: String, isEnableCreateButton: Bool = true) {
        self.headerTitle.text = title
        self.addButton.isHidden = !isEnableCreateButton
    }

}
