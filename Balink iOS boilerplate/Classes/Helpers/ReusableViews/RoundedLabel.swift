//
//  RoundedLabel.swift
//  Berluti
//
//  Created by Shlomo Ariel on 28/01/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//


import UIKit


@IBDesignable class RoundedLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    @IBInspectable var CornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(CornerRadius)
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var RegularBackgroundColor: UIColor? = nil {
        didSet {
            if let color = RegularBackgroundColor{
                self.backgroundColor = color
                self.layer.backgroundColor = color.cgColor
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
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

