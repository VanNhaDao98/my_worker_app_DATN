//
//  DegreeView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class DegreeView: CustomXibView {

    @IBOutlet private var level: UILabel!
    @IBOutlet private var degreeTime: UILabel!
    @IBOutlet private var degreeName: UILabel!
    @IBOutlet private var logoImage: UIImageView!
    override func configeViews() {
        super.configeViews()
        
        backgroundColor = ColorConstant.BGNhat
        
        logoImage.squircle(radius: 20)
        
        degreeName.font = Fonts.defaultFont(ofSize: .default)
        degreeName.textColor = ColorConstant.text
        
        level.font = Fonts.defaultFont(ofSize: .default)
        level.textColor = ColorConstant.text50
        
        degreeTime.font = Fonts.defaultFont(ofSize: .default)
        degreeTime.textColor = ColorConstant.grayText
    }
    
    public func updateView(data: DetailPesionalViewModel.Degree) {
        level.text = data.level
        degreeName.text = data.title
        degreeTime.text = data.time
    }

}
