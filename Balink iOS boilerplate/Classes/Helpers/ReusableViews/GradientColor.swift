//
//  GradientColor.swift
//  Berluti
//
//  Created by elie buff on 07/12/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit

@IBDesignable class GradientColor: UIView {

    var gradientLayer:CAGradientLayer = CAGradientLayer()
    @IBInspectable var startColor:UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable var endColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var GradientStartPoint: CGPoint = CGPoint(x: 0,y: 0)
    @IBInspectable var GradientEndPoint: CGPoint = CGPoint(x: 0,y: 0)
    @IBInspectable var CornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(CornerRadius)
        }
    }
    
    @IBInspectable var RegularBackgroundColor: UIColor? = nil {
        didSet {
            if let color = RegularBackgroundColor{
                self.backgroundColor = color
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
        self.initGradient()
    }
    
    func initGradient(){
        self.gradientLayer.frame.size = self.frame.size
       
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = self.GradientStartPoint
        gradientLayer.endPoint = self.GradientEndPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        /*let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        self.layer.addSublayer(gradientLayer)*/
    }
}

