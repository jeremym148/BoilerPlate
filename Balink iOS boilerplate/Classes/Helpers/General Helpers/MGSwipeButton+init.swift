//
//  MGSwipeButton+init.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import MGSwipeTableCell

extension MGSwipeButton{
    public convenience init(lvTitle: String, icon: UIImage?, backgroundColor color: UIColor?, buttonWidth: CGFloat, titleColor :UIColor){
        self.init(title: lvTitle, icon: icon, backgroundColor: color)
        self.buttonWidth = CGFloat(buttonWidth)
        self.setAttributedTitle(NSAttributedString(string: lvTitle, attributes: [ NSAttributedStringKey.foregroundColor: titleColor]), for: .normal)
        self.centerIconOverText()
    }
}
