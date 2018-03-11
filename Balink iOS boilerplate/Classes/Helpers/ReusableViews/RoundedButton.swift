//
//  RoundedButton.swift
//  Berluti
//
//  Created by elie buff on 09/01/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//

import Foundation
import Foundation
import UIKit


@IBDesignable class RoundedButton: UIButton {
    
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
    
    @IBInspectable var ShadowColor: UIColor? = nil
    
    @IBInspectable var ShadowOffset: Int = 0
    
    @IBInspectable var ShadowRadius: Int = 0
    
    @IBInspectable var ShadowOpacity: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initButton(){
        self.layer.shadowColor = ShadowColor?.cgColor
        self.layer.shadowOffset = CGSize(width: ShadowOffset, height: ShadowOffset)
        self.layer.shadowRadius = CGFloat(ShadowRadius)
        self.layer.shadowOpacity = ShadowOpacity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initButton()
    }
}
