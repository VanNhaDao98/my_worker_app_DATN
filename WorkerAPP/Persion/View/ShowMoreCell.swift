//
//  ShowMoreCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/11/2023.
//

import UIKit

class ShowMoreCell: UITableViewCell {

    @IBOutlet private var showButton: UIButton!
    
    public var showMoreAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        showButton.imageToRight()
        contentView.backgroundColor = .BGNhat
    }
    
    @IBAction func showAction(_ sender: Any) {
        showMoreAction?()
    }
}

extension UIButton {
    func imageToRight() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}
