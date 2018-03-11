//
//  MGSwipeTableCell+AddButton.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import MGSwipeTableCell

enum MGCellPosition{
    case right
    case left
}
extension MGSwipeTableCell{
    func initButtons(){
        self.rightButtons = []
        self.leftButtons = []
    }
    
    func addButton(title: String, image: String, backgroundColor: UIColor, position: MGCellPosition, buttonWidth :CGFloat = 86, titleColor : UIColor = UIColor.white, action: @escaping (()->Void)){
        let newButton = getButton(title: title, image: image, backgroundColor: backgroundColor, buttonWidth :buttonWidth, titleColor : titleColor, action:action)
        
        switch position{
        case .right:
            self.rightButtons.append(newButton)
            self.rightSwipeSettings.transition = .border
        case .left:
            self.leftButtons.append(newButton)
            self.leftSwipeSettings.transition = .border
        }
    }
    
    func insertButton(title: String, image: String, backgroundColor: UIColor, position: MGCellPosition, buttonWidth :CGFloat = 86, titleColor : UIColor = UIColor.white, at: Int, action: @escaping (()->Void)){
        let newButton = MGSwipeButton(lvTitle: title, icon: UIImage(named: image), backgroundColor: backgroundColor, buttonWidth: buttonWidth, titleColor :titleColor)
        
        newButton.callback = {(sender: MGSwipeTableCell) in
            action()
            return true
        }
        
        switch position{
        case .right:
            self.rightButtons.insert(newButton, at: at)
            self.rightSwipeSettings.transition = .border
        case .left:
            self.rightButtons.insert(newButton, at: at)
            self.leftSwipeSettings.transition = .border
        }
    }
    
    func getButton(title: String, image: String, backgroundColor: UIColor, buttonWidth :CGFloat = 86, titleColor : UIColor = UIColor.white, action: @escaping (()->Void)) ->MGSwipeButton{
        let newButton = MGSwipeButton(lvTitle: title, icon: UIImage(named: image), backgroundColor: backgroundColor, buttonWidth: buttonWidth, titleColor :titleColor)
        
        newButton.callback = {(sender: MGSwipeTableCell) in
            action()
            return true
        }
        
        return newButton
    }
}
