//
//  UILabel+attributed.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit
extension UILabel
{
    func setBold(word:String)
    {
        let range = (self.text! as NSString).range(of: word, options: NSString.CompareOptions.caseInsensitive)
        let attributes:Dictionary = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: self.font.pointSize)]
        let myString:NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        myString.addAttributes(attributes, range: range)
        self.attributedText = myString
    }
    
    func setColor(word:String, color:UIColor)
    {
        let range = (self.text! as NSString).range(of: word, options: NSString.CompareOptions.caseInsensitive)
        let myString:NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        myString.addAttribute(NSAttributedStringKey.foregroundColor,value: color, range: range)
        self.attributedText = myString
    }
    
    
}

