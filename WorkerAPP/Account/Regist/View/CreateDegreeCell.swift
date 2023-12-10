//
//  CreateDegreeCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 04/11/2023.
//

import UIKit
import UIComponents
import Utils

class CreateDegreeCell: UITableViewCell {
    @IBOutlet private var degreeNameTextField: TextFieldTitle!
    @IBOutlet private var specialzesTextField: TextFieldTitle!
    @IBOutlet private var degreeTypeTextField: TextFieldTitle!
    @IBOutlet private var degreeLeveTextField: TextFieldTitle!
    @IBOutlet private var startTimeTextField: TextFieldTitle!
    @IBOutlet private var endTimeTextField: TextFieldTitle!
    
    struct Action {
        var universityDidChanged: (String?) -> Void
        var levelAction: () -> Void
        var typeAction: () -> Void
        var startTimeAction: () -> Void
        var endTimeAction: () -> Void
        var profileDegreeDidChanged: (String?) -> Void
    }
    
    var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        degreeLeveTextField.title = "Loại bằng"
        degreeLeveTextField.placeholder = "Chọn loại bằng"
        degreeLeveTextField.isRequired = true
        degreeLeveTextField.isSelectable = true
        degreeLeveTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.action?.levelAction()
        })
        
        degreeTypeTextField.title = "Trình độ"
        degreeTypeTextField.placeholder = "Chọn trình độ"
        degreeTypeTextField.isRequired = true
        degreeTypeTextField.isSelectable = true
        degreeTypeTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.action?.typeAction()
        })
        
        startTimeTextField.title = "Bắt đầu"
        startTimeTextField.isRequired = true
        startTimeTextField.isSelectable = true
        startTimeTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.action?.startTimeAction()
        })
        
        endTimeTextField.title = "Kết thúc"
        endTimeTextField.isRequired = true
        endTimeTextField.isSelectable = true
        endTimeTextField.rightIconMode = .arrowDown({ [weak self] in
            self?.action?.endTimeAction()
        })
        
        
        degreeNameTextField.title = "Tên trường"
        degreeNameTextField.placeholder = "Nhập tên trường"
        degreeNameTextField.isRequired = true
        degreeNameTextField.maxCharacterCount = 50
        degreeNameTextField.textDidChanged = { [weak self] text in
            self?.action?.universityDidChanged(text)
        }
        
        specialzesTextField.title = "Chuyên ngành đào tạo"
        specialzesTextField.placeholder = "Nhập chuyên ngành"
        specialzesTextField.isRequired = true
        specialzesTextField.maxCharacterCount = 50
        specialzesTextField.textDidChanged = { [weak self] text in
            self?.action?.profileDegreeDidChanged(text)
        }
        
        selectionStyle = .none
    }

    public func updasteView(data: CreateWorkerDegreeViewModel.DegreeValue) {
        degreeNameTextField.text = data.name
        degreeLeveTextField.text = data.level
        degreeTypeTextField.text = data.type
        startTimeTextField.text = data.startTime
        endTimeTextField.text = data.endTime
        specialzesTextField.text = data.profile
    }
    
}
