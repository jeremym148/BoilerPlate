//
//  NSLayoutConstraint + Multiplier.swift
//  Berluti
//
//  Created by elie buff on 29/11/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
