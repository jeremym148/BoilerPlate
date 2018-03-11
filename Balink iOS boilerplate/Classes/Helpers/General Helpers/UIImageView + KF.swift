//
//  UIImageView + KF.swift
//  Berluti
//
//  Created by Jeremy Martiano on 13/02/2018.
//  Copyright © 2018 elie buff. All rights reserved.
//

import SalesforceSDKCore
import Kingfisher
import UIKit
import GSImageViewerController


public extension UIImageView {
    func populateImageAttFromSF(photoUrl :String){
        let accessToken = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken
        let url = "https://\(Utils.getPlistValue(for: "SFDCOAuthLoginHost") ?? "berluti.my.salesforce.com")/services/data/v20.0/sobjects/Attachment/\(photoUrl)/Body"
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
            return r
        }
        
        self.kf.setImage(with: URL(string: url)!, placeholder: nil, options: [.requestModifier(modifier)], progressBlock: nil, completionHandler: { (img, err , cache, nil) in
            if let _ = img{
            }
        })
    }
    
    func imageZoom(_ sender: Any){
        let imageInfo   = GSImageInfo(image: self.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender as! UIView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
            return
        }
        window?.rootViewController?.present(imageViewer, animated:true)
    }
    
}
