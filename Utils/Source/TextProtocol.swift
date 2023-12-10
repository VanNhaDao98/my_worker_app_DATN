//
//  TextProtocol.swift
//  Utils
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import UIKit

public protocol TextProtocol {
    func update(into displayable: TextProtocolDisplayable)
    
    var string: String { get }
}

public protocol TextProtocolDisplayable: AnyObject {
    func display(text: String?)
    func display(attributedText: NSAttributedString?)
}

extension UILabel: TextProtocolDisplayable {
    public func display(text: String?) {
        self.text = text
    }
    
    public func display(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }
}

extension UITextView: TextProtocolDisplayable {
    public func display(text: String?) {
        self.text = text
    }
    
    public func display(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }
}

extension String: TextProtocol {
    public func update(into displayable: TextProtocolDisplayable) {
        displayable.display(attributedText: nil)
        displayable.display(text: self)
    }
    
    public var string: String { self }
}

extension NSAttributedString: TextProtocol {
    public func update(into displayable: TextProtocolDisplayable) {
        displayable.display(text: nil)
        displayable.display(attributedText: self)
    }
}

