//
//  DatePicker.swift
//  UIComponent
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

public class DatePicker: UIView, BottomSheetContentView {
    public enum Mode {
        case date
        case time
        case dateAndTime
    }
    
    public struct Config {
        public let mode: Mode
        public var date: Date
        public var minimumDate: Date?
        public var maximumDate: Date?
        public var inlineDateTime: Bool = true
        
        public init(mode: Mode,
                    date: Date,
                    minimumDate: Date? = nil,
                    maximumDate: Date? = nil,
                    inlineDateTime: Bool = true) {
            self.mode = mode
            self.date = date
            self.minimumDate = minimumDate
            self.maximumDate = maximumDate
            self.inlineDateTime = inlineDateTime
        }
    }
    
    private let datePicker: UIDatePicker = .init()
    private let confirmButton: Button = .init(type: .custom)
    
    public var innerScrollView: UIScrollView? { nil }
    
    public let config: Config
    public var confirmedAction: ((Date) -> Void)?
    
    init(config: Config, confirmedAction: ((Date) -> Void)? = nil) {
        self.config = config
        self.confirmedAction = confirmedAction
        
        super.init(frame: .zero)
        
        configs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configs() {
        addSubview(datePicker)
        addSubview(confirmButton)
        
        var pickerHeight: CGFloat = 180.0
        
        switch config.mode {
        case .date:
            datePicker.datePickerMode = .date
            
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        case .time:
            datePicker.datePickerMode = .time
            
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        case .dateAndTime:
            datePicker.datePickerMode = .dateAndTime
            
            if #available(iOS 14.0, *) {
                if config.inlineDateTime {
                    datePicker.preferredDatePickerStyle = .inline
                    pickerHeight = 400.0
                } else {
                    datePicker.preferredDatePickerStyle = .wheels
                }
            }
        }
        
        datePicker.date = config.date
        
        if let min = config.minimumDate {
            datePicker.minimumDate = min
        }
        
        if let max = config.maximumDate {
            datePicker.maximumDate = max
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(pickerHeight)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(16.0)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16.0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16.0).priority(999)
            $0.height.equalTo(48.0)
        }
        
        confirmButton.title = "Xong"
        confirmButton.squircle(radius: 8)
        
        confirmButton.action = { [weak self] in
            guard let self = self else { return }
            self.confirmedAction?(self.datePicker.date)
        }
    }
}

extension DatePicker {
    public static func show(title: String,
                            config: Config,
                            autoDismiss: Bool = true,
                            from presenter: UIViewController,
                            datePicked: @escaping (Date) -> Void) {
        let datePicker = DatePicker(config: config) { date in
            datePicked(date)
            
            if autoDismiss {
                presenter.dismiss(animated: true)
            }
        }
        
        BottomSheet.show(contentView: datePicker,
                         sheetConfig: .init(title: title,
                                            showCloseButton: true,
                                            sizes: [.intrinsic]),
                         from: presenter)
    }
}

