//
//  Double+currency.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation

extension Double{
   
    func toCurrency(currencyCode:String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        //formatter.locale = Locale(identifier: localeIdentifier)
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

