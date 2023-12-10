//
//  Formatter.swift
//  Presentation
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation

open class Formatter {
    public init(maximumFractionDigits: Int? = nil) {
        defaultNumberFormatter = makeNumberFormatter(
            fractionDigits: maximumFractionDigits ?? Formatter.maximumFractionDigits
        )
    }
    
    public static let shared = Formatter()
    
    // MARK: Formatters
    public lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,###"
        formatter.currencySymbol = "₫"
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        return formatter
    }()
    
    public lazy var currencyFormatterWithSymbol: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,###¤"
        formatter.currencySymbol = "₫"
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        return formatter
    }()
    
    static var maximumFractionDigits: Int {
        return 3
    }
    
    static var decimalSeparator: String {
        return "."
    }
    
    private typealias CachedFormatterIdentifier = String
    
    private var cachedFormatter: [CachedFormatterIdentifier: NumberFormatter] = [:]
    
    private func makeNumberFormatter(fractionDigits: Int = Formatter.maximumFractionDigits,
                                     useZeroPadding: Bool = false) -> NumberFormatter {
        
        let id = "\(fractionDigits)_\(useZeroPadding)"
        if let formatter = cachedFormatter[id] {
            return formatter
        }
        
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = Formatter.decimalSeparator
        formatter.maximumFractionDigits = fractionDigits
        
        if fractionDigits > 0, useZeroPadding {
            var format = fractionDigits > 0 ? "#,###." : "#,###"
            for _ in 0..<fractionDigits {
                format += "0"
            }
            
            formatter.positiveFormat = format
            formatter.negativeFormat = format
        }
        
        cachedFormatter[id] = formatter
        
        return formatter
    }
    
    public private(set) var defaultNumberFormatter: NumberFormatter!
    
    // MARK: Currency
    public func currencyString(from number: Double, withSymbol: Bool = false) -> String? {
        return (withSymbol ? currencyFormatterWithSymbol : currencyFormatter).string(from: NSNumber(value: number))
    }
    
    public func currencyString(from number: Decimal, withSymbol: Bool = false) -> String? {
        return (withSymbol ? currencyFormatterWithSymbol : currencyFormatter).string(from: number as NSDecimalNumber)
    }
    
    public func currencyString(from number: NSDecimalNumber, withSymbol: Bool = false) -> String? {
        return (withSymbol ? currencyFormatterWithSymbol : currencyFormatter).string(from: number)
    }
    
    // MARK: Number
    public func string(from number: Double,
                maxFractionDigits: Int? = nil,
                keepTrailingZeros: Bool = false) -> String? {
        string(from: NSDecimalNumber(value: number),
               maxFractionDigits: maxFractionDigits,
               keepTrailingZeros: keepTrailingZeros)
    }
    
    public func string(from number: Decimal,
                maxFractionDigits: Int? = nil,
                keepTrailingZeros: Bool = false) -> String? {
        string(from: number as NSDecimalNumber,
               maxFractionDigits: maxFractionDigits,
               keepTrailingZeros: keepTrailingZeros)
    }
    
    public func string(from number: NSDecimalNumber,
                maxFractionDigits: Int? = nil,
                keepTrailingZeros: Bool = false) -> String? {
        
        guard let maxFractionDigits = maxFractionDigits else {
            return defaultNumberFormatter.string(from: number)
        }
        
        let formatter = makeNumberFormatter(fractionDigits: maxFractionDigits,
                                            useZeroPadding: keepTrailingZeros)
        let string = formatter.string(from: number)
        return string
    }
    
    public func stringNoDecimal(from number: Double) -> String? {
        string(from: number, maxFractionDigits: 0)
    }
    
    public func number(from string: String?) -> Double {
        parseNumber(from: string, using: defaultNumberFormatter)
    }
    
    public func number(from string: String?, maxFractionDigits: Int) -> Double {
        parseNumber(from: string, using: makeNumberFormatter(fractionDigits: maxFractionDigits))
    }
    
    private func parseNumber(from string: String?, using formatter: NumberFormatter) -> Double {
        guard let string = string else {
            return 0
        }
        
        guard let number = formatter.number(from: string) else {
            return 0
        }
        
        // Round number with max fraction digits and convert to string
        guard let numberString = formatter.string(from: number) else {
            return 0
        }
        
        // Return rounded number
        return formatter.number(from: numberString)?.doubleValue ?? 0
    }
}
