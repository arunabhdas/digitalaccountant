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
    var alcoholSubtotal: Double = 0.0
    var subtotalAfterDiscount: Double = 0.0
    var totalAfterDiscountAndTaxes: Double = 0.0
    var amountDiscount: Double = 0.0
    var percentageDiscount: Double = 0.0
    var totalDiscount: Double = 0.0
    
    var totalPercentageTax: Double = 0.0
    
    var percentageTax: Double = 0.13
    var alcoholTaxPercentage: Double = 0.1
    var nonAlcoholTaxAmount: Double = 0.0
    var alcoholTaxAmount: Double = 0.0
    
    
    
    /*
    var subtotal: Double = 0.0 {
        willSet(newValue) {
            print("\(self.subtotal) is going to be renamed as \(newValue)")
        }
        didSet(oldValue) {
            print("\(oldValue) has been renamed as \(self.subtotal)")
        }
    }
    */
    
    public static let sharedInstance = TouchFramework()
    
    private override init() {
        super.init()
    }
    
    
    open class func logToConsole(message msg: String) {
        print(msg);
    }

    
    public func addToSubtotal(amount price: Double) {
        self.subtotal = self.subtotal + price
    }
    
    public func deductFromSubtotal(amount price: Double) {
        self.subtotal = self.subtotal - price
    }
    
    public func addToAlcoholSubtotal(amount price: Double) {
        self.alcoholSubtotal = self.alcoholSubtotal + price
    }
    
    public func deductFromAlcoholSubtotal(amount price: Double) {
        self.alcoholSubtotal = self.alcoholSubtotal - price
    }
    
    public func calculateAll() {
        self.totalDiscount = self.percentageDiscount * self.subtotal + self.amountDiscount
        self.subtotalAfterDiscount = self.subtotal - self.totalDiscount
        self.nonAlcoholTaxAmount = self.subtotalAfterDiscount * self.percentageTax
        self.alcoholTaxAmount = self.alcoholSubtotal * self.alcoholTaxPercentage
        self.totalAfterDiscountAndTaxes = self.subtotalAfterDiscount + self.nonAlcoholTaxAmount + self.alcoholTaxAmount
        print ("Total totalDiscount : \(self.totalDiscount) ")
        print ("----Subtotal After Discount : \(self.subtotalAfterDiscount) ")
        
    }
    

    public func set(amountDiscount amount: Double) {
        self.amountDiscount = amount
    }
    
    public func set(percentageTax tax: Double) {
        self.percentageTax = tax
    }
    
    public func set(alcoholPercentageTax taxPercentage: Double) {
        self.alcoholTaxPercentage = taxPercentage
    }
    
    public func getSubtotal() -> Double {
        return self.subtotal
    }
    
    public func getAlcoholSubtotal() -> Double {
        return self.alcoholSubtotal
    }
    
    public func getAmountDiscount() -> Double {
        return self.amountDiscount
    }
    
    public func getPercentageTax() -> Double {
        return self.percentageTax
    }
    
    
    public func getNonAlcoholTaxAmount() -> Double {
        return self.nonAlcoholTaxAmount
    }
    
    public func getTotalAfterDiscountAndTaxes() -> Double {
        return self.totalAfterDiscountAndTaxes
    }
    
    public func addToPercentageDiscount(percentageDiscount percentage: Double) {
        self.percentageDiscount = self.percentageDiscount + percentage
        self.percentageDiscount = self.percentageDiscount.rounded(toPlaces: 2)
        print ("Total percentageDiscount : \(self.percentageDiscount) ")

    }
    
    public func deductFromPercentageDiscount(percentageDiscount percentage: Double) {
        self.percentageDiscount = self.percentageDiscount - percentage
        self.percentageDiscount = self.percentageDiscount.rounded(toPlaces: 2)
        print ("Total percentageDiscount : \(self.percentageDiscount) ")
    }
    
    public func addToPercentageTax(percentageTax percentage: Double) {
        self.percentageTax = self.percentageTax + percentage
        self.percentageTax = self.percentageTax.rounded(toPlaces: 2)
        print ("PercentageTax : \(self.percentageTax) ")
    }
    
    public func deductFromPercentageTax(percentageTax percentage: Double) {
        self.percentageTax = self.percentageTax - percentage
        self.percentageTax = self.percentageTax.rounded(toPlaces: 2)
        print ("PercentageTax : \(self.percentageTax) ")
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
    
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
