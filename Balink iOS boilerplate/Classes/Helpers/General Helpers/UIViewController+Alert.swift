//
//  UIViewController+Alert.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func alertYesNo(message: String, title: String, cancelText: String, okText: String, okAction:((_ alertAction: UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let CancelAction = UIAlertAction(title: cancelText, style: .default, handler: nil)
        alertController.addAction(CancelAction)
        
        
        let OKAction = UIAlertAction(title: okText, style: .default, handler: okAction)
        alertController.addAction(OKAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmationAlert(message: String?, title: String?, okText: String, okAction:((_ alertAction: UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: okText, style: .default, handler: okAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithManyActions(message: String?,title: String?, actions: [(title:String,action:((_ alertAction: UIAlertAction) -> ()))], cancelText: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        for item in actions
        {
            let action = UIAlertAction(title: item.0, style: .default, handler: item.1)
            alertController.addAction(action)
        }
        
        let CancelAction = UIAlertAction(title: cancelText, style: .default, handler: nil)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithNoActions(message: String?,title: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithActions(message: String?,title: String?, actionsTitle: [String], cancelText: String,action: @escaping ((Int) -> ()))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0  ..< actionsTitle.count
        {
            let alertAction = UIAlertAction(title: actionsTitle[i], style: .default, handler: { (alertAction) in
                action(i)
            })
            alertController.addAction(alertAction)
        }
        
        let CancelAction = UIAlertAction(title: cancelText, style: .default, handler: nil)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Action sheets functions
    
    func actionSheetWithManyActions(title: String? = nil, message: String? = nil, actions: [(title:String,action:((_ alertAction: UIAlertAction) -> ()))]){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        for item in actions
        {
            let action = UIAlertAction(title: item.0, style: .default, handler: item.1)
            alertController.addAction(action)
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(CancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func actionSheetWithActions(title: String?, actionsTitle: [String], sender : Any? = nil, popOverDir : UIPopoverArrowDirection = .up, action: @escaping ((Int) -> ()))
    {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for i in 0  ..< actionsTitle.count
        {
            let alertAction = UIAlertAction(title: actionsTitle[i], style: .default, handler: { (alertAction) in
                action(i)
            })
            alertController.addAction(alertAction)
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(CancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            if let sender = sender as? UIView{
                popoverController.sourceView = sender
                switch popOverDir{
                case .up:
                    popoverController.sourceRect = CGRect(x: sender.bounds.size.width/2, y: 0, width: 0, height: 0)
                default:
                    popoverController.sourceRect = CGRect(x: sender.bounds.size.width/2, y: sender.bounds.size.height, width: 0, height: 0)
                }
            }
            
            if let sender = sender as? UIBarButtonItem{
                popoverController.barButtonItem = sender
            }
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    func checkWSError(error: (title:String?, description:String?)?){
        if let error = error{
            Utils.delay(1, closure: {
                self.confirmationAlert(message: error.description, title: error.title, okText: "OK")
            })
        }
        
    }
    
    func isModal() -> Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}

