//
//  BottomSheetListCell.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

class BottomSheetListCell: UITableViewCell {
    private let stackView = UIStackView()
    private let labelStackView = UIStackView()
    private let imgView = UIImageView()
    private let label = UILabel()
    private let subLabel = UILabel()
    private let checkboxImage = UIImageView()
    private let checkmarkImage = UIImageView()
    private let separatorLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        let inset = UIEdgeInsets(top: 12,
                                 left: 16,
                                 bottom: 12,
                                 right: 16)
        
        stackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(BottomSheetListView<Any>.defaultRowHeight - inset.top - inset.bottom)
            make.top.leading.trailing.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset.bottom).priority(.init(999))
        }
        stackView.addArrangedSubview(checkboxImage)
        checkboxImage.setContentHuggingPriority(.required, for: .horizontal)
        checkboxImage.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.addArrangedSubview(imgView)
        labelStackView.axis = .vertical
        labelStackView.spacing = 2
        stackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(label)
        labelStackView.addArrangedSubview(subLabel)
        
        separatorLine.backgroundColor = ColorConstant.lineView
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints({
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        subLabel.font = Fonts.defaultFont(ofSize: .small)
        subLabel.textColor = ColorConstant.text
        
        imgView.contentMode = .center
        imgView.isHidden = true
        imgView.squircle(radius: 4)
        imgView.snp.makeConstraints({
            $0.width.height.equalTo(32.0)
        })
        
        checkboxImage.contentMode = .center
        checkboxImage.isHidden = true
        checkboxImage.snp.makeConstraints({
            $0.width.equalTo(24.0)
        })
        
        label.font = Fonts.defaultFont(ofSize: .default)
        label.textColor = ColorConstant.text
        label.setContentHuggingPriority(.required, for: .vertical)
        
        stackView.addArrangedSubview(checkmarkImage)
        checkmarkImage.image = ImageConstant.check!.alwaysTemplate()
        checkmarkImage.tintColor = ColorConstant.primary
        checkmarkImage.isHidden = true
        checkmarkImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        checkmarkImage.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkmarkImage.isHidden = true
        checkboxImage.isHidden = true
    }
    
    enum CheckboxStyle {
        case full
        case partial
    }
    
    func update<T>(item: BottomSheetListItem<T>,
                   useCheckbox: Bool,
                   checkboxStyle: CheckboxStyle,
                   separatorEnabled: Bool = false) {
        item.title.update(into: label)
        item.subTitle?.update(into: subLabel)
        checkmarkImage.setHiddenIfChange(useCheckbox || !item.isSelected)
        checkboxImage.setHiddenIfChange(!useCheckbox)
        if item.isEditable {
            if item.isSelected {
                switch checkboxStyle {
                case .full:
                    checkboxImage.image = ImageConstant.icCheckboxSelected24pt
                case .partial:
                    checkboxImage.image = ImageConstant.icCheckboxPartial24pt
                }
            } else {
                checkboxImage.image = ImageConstant.icCheckboxDeselected24pt
            }
        } else {
            checkboxImage.image = item.isSelected
            ? ImageConstant.icCheckboxSelectedDisabled24pt
            : ImageConstant.icCheckboxDeselected24pt
        }
        imgView.isHidden = item.imageSource == nil
        
        // iOS 13 bug: isHidden = true but it's still showing (WTF)
        if checkboxImage.isHidden {
            checkboxImage.image = nil
        }
        if checkmarkImage.isHidden {
            checkmarkImage.image = nil
        } else {
            checkmarkImage.image = ImageConstant.check!.alwaysTemplate()
        }
        
        selectionStyle = item.isEditable ? .default : .none
        
        subLabel.isHidden = item.subTitle == nil
        
        if item.subTitle != nil {
            label.font = Fonts.mediumFont(ofSize: .default)
        } else {
            label.font = Fonts.defaultFont(ofSize: .default)
        }
        
        switch item.style {
        case .`default`:
            label.textColor = ColorConstant.text
            imgView.tintColor = .gray
        case .destructive:
            label.textColor = .red
            imgView.tintColor = .red
        }
        
        switch item.imageSource {
        case .image(let image):
            imgView.image = image
        case nil:
            imgView.image = nil
        }
        
        imgView.contentMode = item.imageContentMode
        
        subLabel.numberOfLines = item.numberOfLinesSubTitle
        
        separatorLine.setHiddenIfChange(!separatorEnabled)
    }
    
    func updateSelectAllItem(isSelected: Bool, isPartial: Bool) {
        update(item: .init(title: "Chọn tất cả", isSelected: isSelected),
               useCheckbox: true,
               checkboxStyle: isPartial ? .partial : .full,
               separatorEnabled: true)
    }
}

