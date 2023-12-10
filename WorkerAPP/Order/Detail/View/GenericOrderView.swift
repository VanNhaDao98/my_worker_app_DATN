//
//  GenericOrderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 11/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class GenericOrderView: CustomXibView {
    @IBOutlet private var titleLabel: HeaderLabel!
    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var createOnLabel: UILabel!
    @IBOutlet private var dueOnLabel: UILabel!
    @IBOutlet private var issueLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var statusView: TagView!
    @IBOutlet private var jobImage: UIImageView!
    @IBOutlet private var cancelOn: UILabel!
    @IBOutlet private var timeEnd: UILabel!
    @IBOutlet private var paymentStatusView: TagView!
    override func configeViews() {
        super.configeViews()
        titleLabel.text = "Thông tin cơ bản"
        codeLabel.font = Fonts.mediumFont(ofSize: .title)
        codeLabel.textColor = .text
        jobImage.squircle(radius: 15)
        statusView.textFont = Fonts.italicFont(ofSize: .default)
        paymentStatusView.textFont = Fonts.italicFont(ofSize: .default)
        createOnLabel.textColor = .grayText
        createOnLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        
        cancelOn.textColor = .grayText
        cancelOn.font = Fonts.defaultFont(ofSize: .subtitle)
        
        timeEnd.textColor = .grayText
        timeEnd.font = Fonts.defaultFont(ofSize: .subtitle)
    }
    
    public func updateView(data: OrderDetailViewModel.Generic) {
        codeLabel.text = data.code
        addressLabel.attributedText = data.address
        issueLabel.attributedText = data.issue
        dueOnLabel.attributedText = data.duaOn
        createOnLabel.text = data.createOn
        statusView.text = data.status.title
        statusView.textColor = data.status.color
        statusView.backgroundColor = data.status.bg
        jobImage.image = data.jobIcon
        
        paymentStatusView.text = data.paymentStatus.title
        paymentStatusView.textColor = data.paymentStatus.color
        paymentStatusView.backgroundColor = data.paymentStatus.bg
        paymentStatusView.isHidden = data.status == .cancel || data.status == OrderStatus.await
        cancelOn.isHidden = data.isHiddenCancelOn
        cancelOn.text = data.cancelOn
        timeEnd.isHidden = data.isHiddenTimeEnd
        timeEnd.text = data.timeEnd
    }


}
