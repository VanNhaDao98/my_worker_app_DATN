//
//  AttributedStringMaker.swift
//  Utils
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit

/// Type-safe NSAttributedString maker
public class AttributedStringMaker {

    public enum MatchType {
        case first
        case last
        case all
        case append
    }
    
    public typealias Maker = (AttributedStringMaker) -> Void
    
    private var attributes: [NSAttributedString.Key: Any] = [:]
    private var attachments: [NSTextAttachment] = []

    private var matchType: MatchType = .first

    private var subMakers: [AttributedStringMaker] = []

    public var string: String
    
    /// For subMakers only
    private var strings: [String]?

    public init(string: String?) {
        self.string = string ?? ""
    }
    
    /// For subMakers only
    private init(strings: [String]?) {
        self.string = ""
        self.strings = strings
    }
    
    private func createSubmaker(string: String? = nil,
                                strings: [String]? = nil,
                                match: MatchType,
                                maker: Maker) -> AttributedStringMaker {
        let sub = string != nil ? AttributedStringMaker(string: string) : AttributedStringMaker(strings: strings)
        sub.matchType = match
        subMakers.append(sub)
        maker(sub)
        return self
    }
    
    public func build() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)

        addAttachments(for: attributedString)
        processSubmakers(for: attributedString)

        return attributedString
    }
    
    private func addAttachments(for attributedString: NSMutableAttributedString) {
        guard !attachments.isEmpty else {
            return
        }
        
        for attachment in attachments {
            let attachmentString = NSAttributedString(attachment: attachment)
            attributedString.append(NSAttributedString(string: " "))
            attributedString.append(attachmentString)
        }
    }
    
    private func processSubmakers(for attributedString: NSMutableAttributedString) {
        guard !subMakers.isEmpty else {
            return
        }
        
        let make = { (maker: AttributedStringMaker, s: String) in
            var nsRange: NSRange?
            var nsRanges: [NSRange]?
            
            switch maker.matchType {
            case .first:
                nsRange = self.string.nsRange(of: s)
            case .last:
                nsRange = self.string.nsRanges(of: s).last
            case .all:
                nsRanges = self.string.nsRanges(of: s)
            case .append:
                let next = NSAttributedString(string: s, attributes: maker.attributes)
                attributedString.append(next)
                return
            }

            if let range = nsRange {
                attributedString.addAttributes(maker.attributes, range: range)
                return
            }
            
            if let ranges = nsRanges {
                for range in ranges {
                    attributedString.addAttributes(maker.attributes, range: range)
                }
            }
        }
        
        for maker in subMakers {
            if let strings = maker.strings, strings.count > 0 {
                for s in strings {
                    make(maker, s)
                }
            } else {
                make(maker, maker.string)
            }
        }
    }
    
    public func mutableBuild() -> NSMutableAttributedString {
        NSMutableAttributedString(attributedString: build())
    }
}

public extension AttributedStringMaker {

    @discardableResult
    func font(_ font: UIFont?) -> AttributedStringMaker {
        attributes[.font] = font
        return self
    }

    @discardableResult
    func color(_ color: UIColor?) -> AttributedStringMaker {
        attributes[.foregroundColor] = color
        return self
    }

    @discardableResult
    func backgroundColor(_ color: UIColor?) -> AttributedStringMaker {
        attributes[.backgroundColor] = color
        return self
    }

    @discardableResult
    func paragraphStyle(_ style: NSParagraphStyle?) -> AttributedStringMaker {
        attributes[.paragraphStyle] = style
        return self
    }
    
    @discardableResult
    func underlineStyle(_ style: NSUnderlineStyle?) -> AttributedStringMaker {
        attributes[.underlineStyle] = style?.rawValue
        return self
    }

    @discardableResult
    func link(_ string: String?) -> AttributedStringMaker {
        if let string = string, let url = URL(string: string) {
            attributes[.link] = url
        }
        
        return self
    }

    @discardableResult
    func strikethroughColor(_ strikethroughColor: UIColor) -> AttributedStringMaker {
        attributes[.strikethroughColor] = strikethroughColor
        
        if attributes[.strikethroughStyle] == nil {
            attributes[.strikethroughStyle] = 1.0
        }
        
        return self
    }
    
    @discardableResult
    func strikethroughStyle(_ strikethroughStyle: NSUnderlineStyle) -> AttributedStringMaker {
        attributes[.strikethroughStyle] = strikethroughStyle.rawValue
        return self
    }
    
    @discardableResult
    func custom(_ attrs: [NSAttributedString.Key: Any]) -> AttributedStringMaker {
        attrs.forEach({ attributes[$0.key] = $0.value })
        return self
    }
    
    /// Add images as attachment of text
    /// - Parameters:
    ///   - images: images
    ///   - font: if font is available, set this to calculate vertical offset of image
    /// - Returns: this maker
    @discardableResult
    func addImages(_ images: [UIImage], withFont font: UIFont? = nil) -> AttributedStringMaker {
        for image in images {
            let attachment = NSTextAttachment()
            attachment.image = image
            if let font = font {
                attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2,
                                           width: image.size.width,
                                           height: image.size.height)
            } else {
                attachment.bounds = CGRect(x: 0, y: -2,
                                           width: image.size.width,
                                           height: image.size.height)
            }
            attachments.append(attachment)
        }
        
        return self
    }

    @discardableResult
    func first(match substring: String?, maker: Maker) -> AttributedStringMaker {
        createSubmaker(string: substring, match: .first, maker: maker)
    }

    @discardableResult
    func last(match substring: String?, maker: Maker) -> AttributedStringMaker {
        createSubmaker(string: substring, match: .last, maker: maker)
    }

    @discardableResult
    func all(match substring: String?, maker: Maker) -> AttributedStringMaker {
        createSubmaker(string: substring, match: .all, maker: maker)
    }
    
    @discardableResult
    func multiple(substrings: [String]?, match: MatchType = .all, maker: Maker) -> AttributedStringMaker {
        createSubmaker(strings: substrings, match: match, maker: maker)
    }
    
    @discardableResult
    func append(_ s: String?, maker: Maker) -> AttributedStringMaker {
        createSubmaker(string: s, match: .append, maker: maker)
    }
}

extension String {
    public var attributedMaker: AttributedStringMaker {
        return AttributedStringMaker(string: self)
    }
}

public extension NSParagraphStyle {
    static func mutable() -> NSMutableParagraphStyle {
        NSMutableParagraphStyle()
    }
}

public extension NSMutableParagraphStyle {
    
    @discardableResult
    func lineSpace(_ spacing: CGFloat) -> Self {
        lineSpacing = spacing
        return self
    }
    
    @discardableResult
    func paragraphSpace(_ spacing: CGFloat) -> Self {
        paragraphSpacing = spacing
        return self
    }
    
    @discardableResult
    func paragraphSpaceBefore(_ spacing: CGFloat) -> Self {
        paragraphSpacingBefore = spacing
        return self
    }
    
    @discardableResult
    func align(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }
}

extension NSUnderlineStyle {
    public static let disabled = NSUnderlineStyle([])
}

