//
//  ConnectLevelJobView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 24/11/2023.
//

import UIKit
import Presentation
import UIComponents

class ConnectLevelJobView: CustomXibView {
    @IBOutlet private var titleLabel: UILabel!
    
    public var action: (() -> Void)?
    
    override func configeViews() {
        super.configeViews()
        let attributedString = NSMutableAttributedString(string: "Nhấn vào đây để xác định được cấp bậc nghề nghiệp của bản thân ( Nguồn tham khảo đã được xác minh và lấy làm tiêu chuẩn cấp bậc)")
        let linkRange = (attributedString.string as NSString).range(of: "Nhấn vào đây")
        
        attributedString.addAttribute(.link, value: "", range: linkRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
        
        titleLabel.attributedText = attributedString
        
        titleLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLink))
        titleLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func openLink() {
        action?()
    }

}
