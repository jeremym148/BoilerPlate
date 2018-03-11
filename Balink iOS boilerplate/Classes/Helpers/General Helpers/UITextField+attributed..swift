//
//  UITextField+attributed..swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit

extension UITextField
{
    func setColorInRange(_ color:UIColor, ranges:NSArray)
    {
        let myString = NSMutableAttributedString(attributedString: self.attributedText!)
        for value in ranges
        {
            myString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: (value as AnyObject).rangeValue)
        }
        self.attributedText = myString
    }
}

