//
//  UIView+Helper.swift
//  Berluti
//
//  Created by Shlomo Ariel on 28/01/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(first:UIColor, second:UIColor, start:CGPoint, end:CGPoint) {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [first.cgColor,second.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
