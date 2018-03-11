//
//  RoundedView.swift
//  ICON
//
//  Created by Yossi Sud on 31/01/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class RoundedView: UIView {
    
    fileprivate var regularBackgroundColor : UIColor?
    
    @IBInspectable var CornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(CornerRadius)
        }
    }
    
    @IBInspectable var RegularBackgroundColor: UIColor? = nil {
        didSet {
            if let color = RegularBackgroundColor{
                self.backgroundColor = color
                self.regularBackgroundColor = color
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
