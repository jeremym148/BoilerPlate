//
//  UIButton+SpringAnimation.swift
//  Berluti
//
//  Created by elie buff on 27/11/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit
extension UIButton{
    func addSpringAnimation(onFinish : @escaping (() -> ())){
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.transform = .identity
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
          onFinish()
        }
    }
    
    static func setSelectedButtonTint(selected:UIButton, others:[UIButton],
                               selectedColor:UIColor! = nil,
                               nonSelectedColor:UIColor! = nil){
        for button in others{
            button.isSelected = false
            if let nonSelectedColor = nonSelectedColor{
                button.tintColor = nonSelectedColor
            }
        }
        selected.isSelected = true
        if let selectedColor = selectedColor{
            selected.tintColor = selectedColor
        }
    }
}
