//
//  MessageComposerUtils.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer{
    
    static let sharedInstance = MessageComposer()
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(messageViewController:MFMessageComposeViewControllerDelegate) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = messageViewController  //  Make sure to set this property to self, so that the controller can be dismissed!
        return messageComposeVC
    }
    
    func configuredMailComposeViewController(mailViewController:MFMailComposeViewControllerDelegate) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = mailViewController // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        return mailComposerVC
    }
    
    
    func sendSMS(to recipient:String, body:String = "", viewController :UIViewController)
        -> Bool
    {
        let urlStringEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = NSURL(string: "sms:\(recipient)&body=\(urlStringEncoded!)")
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
    
    
    func sendSMSInApp(to recipient:String, body:String = "", viewController :UIViewController, messageViewController:MFMessageComposeViewControllerDelegate)
        -> Bool
    {
        if (self.canSendText()) {
            let messageComposeVC = self.configuredMessageComposeViewController(messageViewController: messageViewController)
            messageComposeVC.body = body
            messageComposeVC.recipients = [recipient]
            viewController.present(messageComposeVC, animated: true, completion: nil)
            
            return true
        }
        return false
    }
    
    
    func sendMail(to ccEmails:[String], bccEmails:[String], subject:String?, body:String?, isBodyHtml:Bool = false,viewController:UIViewController, mailViewController :MFMailComposeViewControllerDelegate)
        -> Bool
    {
        let mailComposerVC = self.configuredMailComposeViewController(mailViewController: mailViewController)
        mailComposerVC.navigationBar.tintColor = #colorLiteral(red: 0.01176470588, green: 0.6392156863, blue: 1, alpha: 1)
        mailComposerVC.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)]
        
        
        if self.canSendMail() {
            mailComposerVC.setCcRecipients(ccEmails)
            mailComposerVC.setBccRecipients(bccEmails)
            if let subject = subject{
                mailComposerVC.setSubject(subject)
            }
            if let body = body{
                mailComposerVC.setMessageBody(body, isHTML: isBodyHtml)
            }
            viewController.present(mailComposerVC, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    
    func sendWhatsapp(message:String = "")
        -> Bool
    {
        let urlStringEncoded = message.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
    
    
    func sendWechat()
        -> Bool
    {
        let url  = NSURL(string: "weixin://dl/chat")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
    
    
    func sendKakao()
        -> Bool
    {
        let url  = NSURL(string: "kakaolink://")
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        return true
    }
    
    
    
    func sendLine()
        -> Bool
    {
        let url  = NSURL(string: "line://")
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil) 
        return true
    }
}
