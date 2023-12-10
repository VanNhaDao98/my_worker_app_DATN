//
//  Number+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation

public extension Decimal {
    func format(maxFractionDigits: Int? = nil) -> String {
        Formatter.shared.string(from: self, maxFractionDigits: maxFractionDigits) ?? ""
    }
    
    func currencyFormat(withSymbol: Bool = false) -> String {
        Formatter.shared.currencyString(from: self, withSymbol: withSymbol) ?? ""
    }
}

public extension NSDecimalNumber {
    func format(maxFractionDigits: Int? = nil,
                keepTrailingZeros: Bool = false) -> String {
        Formatter.shared.string(from: self,
                                maxFractionDigits: maxFractionDigits,
                                keepTrailingZeros: keepTrailingZeros) ?? ""
    }
    
    func currencyFormat(withSymbol: Bool = false) -> String {
        Formatter.shared.currencyString(from: self, withSymbol: withSymbol) ?? ""
    }
}

public extension Double {
    func format(maxFractionDigits: Int? = nil) -> String {
        Formatter.shared.string(from: self, maxFractionDigits: maxFractionDigits) ?? ""
    }
    
    func currencyFormat(withSymbol: Bool = false) -> String {
        Formatter.shared.currencyString(from: self, withSymbol: withSymbol) ?? ""
    }
    
    func percentFormat(maxFractionDigits: Int = 2) -> String {
        "\(format(maxFractionDigits: maxFractionDigits))%"
    }
}

public extension Int {
    func format() -> String {
        Formatter.shared.string(from: Decimal(self)) ?? ""
    }
}

public extension LosslessStringConvertible {
    var string: String { "\(self)" }
}

extension Decimal: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(string: description)
    }
}
