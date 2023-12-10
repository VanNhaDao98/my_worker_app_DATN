//
//  OrderListCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 11/11/2023.
//

import UIKit
import UIComponents
import Domain
import Utils

class OrderListCell: UITableViewCell {
    @IBOutlet private var borderView: UIView!
    @IBOutlet private var jobIcon: UIImageView!
    @IBOutlet private var jobName: UILabel!
    @IBOutlet private var statusView: TagView!
    @IBOutlet private var customerName: UILabel!
    @IBOutlet private var createOn: UILabel!
    @IBOutlet private var address: UILabel!
    @IBOutlet private var cancelOn: UILabel!
    @IBOutlet private var endTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        jobIcon.squircle(radius: 10)
        borderView.border(width: 1, color: .lineView)
        borderView.squircle(radius: 12)
        [customerName, createOn, address, cancelOn, endTime].forEach {
            $0?.font = Fonts.defaultFont(ofSize: .default)
            $0?.textColor = .text50
        }
        jobName.font = Fonts.boldFont(ofSize: .medium)
        selectionStyle = .none
    }
    
    public func updateView(order: Order) {
        jobName.text = order.job?.name ?? ""
        jobIcon.image = order.job?.type.selectImage
        statusView.text = order.status.title
        statusView.textColor = order.status.color
        statusView.backgroundColor = order.status.bg
        customerName.text = "Khách hàng: \(order.customer?.fullName ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        if let date = order.createOn {
            createOn.text = "Tạo lúc: \(dateFormatter.string(from: date))"
            createOn.isHidden = false
        } else {
            createOn.isHidden = true
        }
        
        let addressValue: String = .join([order.address,
                                     order.ward?.name,
                                     order.district?.name,
                                     order.province?.name], separator: ", ")
        address.text = "Địa chỉ: \(addressValue)"
        endTime.isHidden = order.endTime == nil
        cancelOn.isHidden = order.cancelOn == nil
        
        if let date = order.cancelOn {
            self.cancelOn.text = "Hủy lúc: \(dateFormatter.string(from: date))"
        }
        
        if let date = order.endTime {
            self.endTime.text = "Hoàn thành lúc: \(dateFormatter.string(from: date))"
        }
        
    }
    
}
