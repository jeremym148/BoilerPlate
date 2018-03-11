//
//  UITabBarController + setVisible.swift
//  Berluti
//
//  Created by elie buff on 03/01/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//

import UIKit

extension UIViewController {
    func setTabBarVisible(visible:Bool) {
        self.tabBarController?.tabBar.isHidden = !visible
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.bottom
    }
    
    func dismissFadeOut(){
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
