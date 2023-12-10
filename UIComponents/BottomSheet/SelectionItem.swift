//
//  SelectionItem.swift
//  UIComponents
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation
import UIKit

public struct SelectionItem<T> {
    public enum ImageSource {
        case image(UIImage)
    }
    
    public var title: String
    public var subtitle: String?
    public var image: ImageSource? = nil
    public var isSelected: Bool
    public var isEditable: Bool = true
    public var rawData: T
    
    public init(title: String,
                subtitle: String? = nil,
                image: ImageSource? = nil,
                isSelected: Bool,
                isEditable: Bool = true,
                rawData: T) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.isSelected = isSelected
        self.isEditable = isEditable
        self.rawData = rawData
    }
    
    public init(title: String,
                subtitle: String? = nil,
                image: ImageSource? = nil,
                isSelected: Bool,
                isEditable: Bool = true) where T == Any? {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.isSelected = isSelected
        self.isEditable = isEditable
        self.rawData = nil
    }
}

extension SelectionItem {
    public func bottomSheetItem(imageContentMode: UIView.ContentMode = .scaleAspectFill) -> BottomSheetListItem<T> {
        let imageSource: BottomSheetListItem<T>.ImageSource? = {
            switch self.image {
            case .image(let image):
                return .image(image)
            case nil:
                return nil
            }
        }()
        
        return .init(title: title,
                     subTitle: subtitle,
                     numberOfLinesSubTitle: 0,
                     imageSource: imageSource,
                     imageContentMode: imageContentMode,
                     isSelected: isSelected,
                     isEditable: isEditable,
                     rawData: rawData)
    }
}
