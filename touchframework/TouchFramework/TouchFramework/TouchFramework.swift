//
//  TouchFramework.swift
//  TouchFramework
//
//  Created by Das on 10/8/19.
//  Copyright © 2019 Arunabh Das. All rights reserved.
//

import UIKit

open class TouchFramework: NSObject {
    var subtotal: Double = 0.0
    var amountDiscount: Double = 0.0
    var percentageDiscount: Double = 0.0
    var totalDiscount: Double = 10.0
    
    
    public static let sharedInstance = TouchFramework()
    
    private override init() {
        super.init()
    }
    
    
    open class func logToConsole(message msg: String) {
        print(msg);
    }

    
    public func addToSubtotal(amount price: Double) -> Double {
        self.subtotal = subtotal + price
        return self.subtotal
    }
    
    public func deductFromSubtotal(amount price: Double) -> Double {
        self.subtotal = subtotal - price
        return self.subtotal
    }
    
    public func calculateTotalDiscount() -> Double {
        return totalDiscount
    }
    
    public func set(amountDiscount amount: Double) {
        self.amountDiscount = amount
    }
}

public extension String {
    func toFloat() -> Float? {
        return Float.init(self)
    }

    func toDouble() -> Double? {
        return Double.init(self)
    }
    
    func removeFormatAmount() -> Double {
        let formatter = NumberFormatter()

        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.decimalSeparator = ","

        return formatter.number(from: self) as! Double? ?? 0
     }
    

}


public extension Double {
    func formatAmount(number:NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: number)!
    }
}
