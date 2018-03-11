//
//  BorderedButton.swift
//  Berluti
//
//  Created by Jeremy Martiano on 19/11/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {
        
        @IBInspectable var cornerRadius: CGFloat = 0 {
            didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
            }
        }
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
        @IBInspectable var borderColor: UIColor? = UIColor.clear {
            didSet {
                layer.borderColor = borderColor?.cgColor
            }
        }


}
