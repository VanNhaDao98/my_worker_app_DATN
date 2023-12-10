//
//  OTPView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import UIKit
import Presentation
import UIComponents

class OTPView: CustomXibView, BottomSheetContentView {
    var innerScrollView: UIScrollView? {
        scrollVIew
    }
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet private var textFieldStackView: UIStackView!
    @IBOutlet private var tf6: TextField!
    @IBOutlet private var tf5: TextField!
    @IBOutlet private var tf4: TextField!
    @IBOutlet private var tf3: TextField!
    @IBOutlet private var tf2: TextField!
    @IBOutlet private var tf1: TextField!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sendOtpButton: Button!
    @IBOutlet private var scrollVIew: UIScrollView!
    
    var sendOtpAction: (() -> Void)? {
        get { sendOtpButton.action }
        set { sendOtpButton.action = newValue }
    }
    
    override func configeViews() {
        super.configeViews()
        
        sendOtpButton.config.style = .filled
        sendOtpButton.title = "Gửi mã OTP"
        sendOtpButton.squircle(radius: 24)
        [tf1, tf2, tf3, tf4, tf5, tf6].forEach {
            $0?.maxCharacterCount = 1
            $0?.textAlignment = .center
            $0?.keyboardType = .numberPad
        }
        
        mainStackView.setCustomSpacing(50, after: textFieldStackView)
    }

}
