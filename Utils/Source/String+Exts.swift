//
//  String+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import UIKit

extension String {
    
    @inlinable
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @inlinable
    public func trim(in s: String) -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: s))
    }
    
    public var first: String {
        return String(prefix(1))
    }
    
    public func firstUppercased() -> String {
        first.uppercased() + dropFirst()
    }
    
    @inlinable
    static public func isBlank(_ string: String?) -> Bool {
        isEmpty(string?.trim())
    }
    
    @inlinable
    static public func notBlank(_ string: String?) -> Bool {
        !isEmpty(string?.trim())
    }
    
    @inlinable
    static public func isEmpty(_ string: String?) -> Bool {
        guard let string = string else {
            return true
        }
        
        return string.isEmpty
    }
    
    @inlinable
    static public func ifNotBlank(_ s: String?, else other: String) -> String {
        if let s = s, notBlank(s) {
            return s
        }
        
        return other
    }
    
    public func isValidEmail() -> Bool {
        let pattern = "(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        return matches(pattern)
    }
}

public extension String {
    func prefix(_ maxLenght: Int) -> String {
        return String(prefix(maxLenght) as Substring)
    }
    
    func suffix(_ maxLenght: Int) -> String {
        return String(suffix(maxLenght) as Substring)
    }
}

public extension String {

    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

    var nsRange: NSRange {
        return NSRange(location: 0, length: count)
    }

    func nsRange(of substring: String) -> NSRange? {
        guard let range = range(of: substring) else {
            return nil
        }

        return NSRange(range, in: self)
    }

    func nsRanges(of substring: String) -> [NSRange] {
        return ranges(of: substring).map({ NSRange($0, in: self) })
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index> {
        let lowerBound = index(startIndex, offsetBy: nsRange.location)
        let upperBound = index(lowerBound, offsetBy: nsRange.length)

        return lowerBound ..< upperBound
    }
    
    func substring(from nsRange: NSRange) -> String {
        String(self[range(from: nsRange)])
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Swift.Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }

    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }
}

public extension String {
    func removeAccents() -> String {
        var string = self

        /// `.folding(options:locale:)` won't work for these 2 characters
        if string.contains("đ") {
            string = string.replacingOccurrences(of: "đ", with: "d")
        }
        if string.contains("Đ") {
            string = string.replacingOccurrences(of: "Đ", with: "D")
        }

        /// use `.diacriticInsensitive` to remove diacritic marks
        return string.folding(options: [.diacriticInsensitive], locale: .enUSPOSIX)
    }
}

public extension Locale {
    static let enUSPOSIX = Locale(identifier: "en_US_POSIX")
    static let vi = Locale(identifier: "vi")
}

// MARK: - Validations
public extension String {
    func matches(_ pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES[c] %@", pattern).evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        return matches("^0[0-9]{7,14}$")
    }
    
    func isValidAhaMovePhoneNumber() -> Bool {
        return matches("^0[0-9]{8,14}$")
    }
    
    func isValidVietnamPhoneNumber() -> Bool {
        // Start with 0, length is fixed 10 numbers
        return matches("^0[0-9]{9}$")
    }
    
    mutating func prefixPhoneNumber(prefix: String) -> String {
        if self.first == "0" {
            self.remove(at: self.startIndex)
        }
        return prefix + self
    }
}

public extension String {
    func prefixHttpsIfNeeded() -> String {
        if starts(with: "https://") {
            return self
        }
        
        return "https://\(self)"
    }
}

public extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

public extension Bool {
    mutating func setIfChanged(_ check: Bool) {
        if self != check {
            self = check
        }
    }
}

public extension String {
    static func join(_ components: String?..., separator: String = ", ") -> String {
        join(components, separator: separator)
    }

    static func join(_ components: [String?], separator: String = ", ") -> String {
        components
            .compactMap({ $0?.trim() })
            .filter({ $0.notEmpty })
            .joined(separator: separator)
    }

    static func fallback(_ s: String?) -> String {
        ifNotBlank(s, else: "---")
    }
}

public extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

public extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]+$",
            options: .regularExpression) != nil
    }
}

public extension String {
    var encodedQuery: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
            .replacingOccurrences(of: "&", with: "%26")
        ?? self
    }
    
    var encodedSpace: String {
        replacingOccurrences(of: " ", with: "%20")
    }
}

public extension URL {
    var encodedQuery: URL {
        URL(string: absoluteString.encodedQuery) ?? self
    }
}

extension String {
    public func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z])"
        let normalPattern = "([a-z])([A-Z])"
        return self
            .processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: normalPattern)?
            .lowercased()
        ?? lowercased()
    }
    
    func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}

extension String {
    public func asNumberValue() -> Double {
        Utils.Formatter.shared.number(from: self)
    }
}

