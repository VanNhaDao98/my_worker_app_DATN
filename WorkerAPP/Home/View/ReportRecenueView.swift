//
//  ReportRecenueView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 21/10/2023.
//

import UIKit
import Presentation
import Utils

class ReportRecenueView: CustomXibView {
    @IBOutlet private var reportRevenueTitle: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var revenueValue: UILabel!
    @IBOutlet private var orderValue: UILabel!
    @IBOutlet private var orderValueView: UIView!
    @IBOutlet private var customerValue: UILabel!
    @IBOutlet private var customerValueView: UIView!
    @IBOutlet private var cancelOrderValue: UILabel!
    @IBOutlet private var cancelOrderVIew: UIView!
    @IBOutlet private var reportView: UIView!
    
    override func configeViews() {
        super.configeViews()
        setupView()
    }
    
    private func setupView() {
        
        reportView.squircle(radius: 8)
        [orderValueView, customerValueView, cancelOrderVIew].forEach({
            $0?.squircle(radius: 6)
        })
        
        [orderValue, customerValue, cancelOrderValue].forEach({
            $0?.font = Fonts.defaultFont(ofSize: .subtitle)
            $0?.textColor = ColorConstant.text
        })
        
        reportRevenueTitle.textColor = .white
        reportRevenueTitle.font = Fonts.defaultFont(ofSize: .default)
        reportRevenueTitle.text = "Doanh thu hôm nay"
        
        timeLabel.textColor = .white
        timeLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        
        revenueValue.textColor = .white
        revenueValue.font = Fonts.boldFont(ofSize: .title)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        timeLabel.text = dateFormatter.string(from: Date())
        
    }
    
    public func updateView(report: HomeViewModel.Report) {
        revenueValue.text = report.totalMoney
        cancelOrderValue.text = "\(report.cancelOrder) Đơn hủy"
        customerValue.text = "\(report.customer) Khách"
        orderValue.text = "\(report.order) Đơn"
    }

}
