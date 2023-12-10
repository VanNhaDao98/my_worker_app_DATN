//
//  BottomSheetListItem.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import Utils

public protocol BottomSheetListIdentifiableItem {
    associatedtype ID: Hashable
    
    var id: ID { get }
}

public struct BottomSheetListItem<T> {
    public enum Style {
        case `default`
        case destructive
    }
    
    public enum ImageSource {
        case image(UIImage)
    }
    
    public var title: TextProtocol
    public var subTitle: TextProtocol? = nil
    public var style: Style = .default
    public var imageSource: ImageSource?
    public var imageContentMode: UIView.ContentMode = .center
    public var isSelected: Bool = false
    public var isEditable: Bool = true
    public var rawData: T
    public var numberOfLinesSubTitle: Int
    
    public init(title: TextProtocol,
                subTitle: TextProtocol? = nil,
                numberOfLinesSubTitle: Int = 1,
                style: Style = .default,
                imageSource: ImageSource? = nil,
                imageContentMode: UIView.ContentMode = .center,
                isSelected: Bool = false,
                isEditable: Bool = true,
                rawData: T) {
        self.title = title
        self.style = style
        self.imageSource = imageSource
        self.imageContentMode = imageContentMode
        self.isSelected = isSelected
        self.isEditable = isEditable
        self.rawData = rawData
        self.subTitle = subTitle
        self.numberOfLinesSubTitle = numberOfLinesSubTitle
    }
    
    public init(title: TextProtocol,
                subTitle: TextProtocol? = nil,
                numberOfLinesSubTitle: Int = 1,
                style: Style = .default,
                imageSource: ImageSource? = nil,
                imageContentMode: UIView.ContentMode = .center,
                isSelected: Bool = false,
                isEditable: Bool = true) where T == Any? {
        self.title = title
        self.subTitle = subTitle
        self.style = style
        self.imageSource = imageSource
        self.imageContentMode = imageContentMode
        self.isSelected = isSelected
        self.isEditable = isEditable
        self.rawData = nil
        self.numberOfLinesSubTitle = numberOfLinesSubTitle
    }
}

