//
//  JobCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import UIKit
import Utils
import Domain

class JobCell: UICollectionViewCell {
    @IBOutlet private var jobImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        jobImage.image = nil
        nameLabel.text = nil
    }
    
    private func setupView() {
        nameLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        nameLabel.textColor = ColorConstant.text
    }
    
    public func updateView(data: Job, currentJob: Job?) {
        let select = data.id == currentJob?.id
        jobImage.image = (select ? data.type.selectImage : data.type.deSelectImage) ?? ImageConstant.imageEmpty
        nameLabel.text = data.type.title
        nameLabel.textColor = select ? ColorConstant.primary : ColorConstant.text
    }

}
