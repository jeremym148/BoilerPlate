//
//  LocalizeUtils.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit

class LocalizeUtils{
    
    static var localizedBundle:Bundle = Bundle()
    static var localizedLocal:String = ""
    
    static func getBundleForLanguage(salesForceLang :String)->Bundle{
        var pathForLang:String = ""
        
        switch salesForceLang {
        case "fr","ja","de","es","ko":
            pathForLang = salesForceLang
            break
        case "pt_BR":
            pathForLang = "pt-BR"
            break
        case "zh_TW":
            pathForLang = "zh-Hant"
            break
        case "zh_CN":
            pathForLang = "zh-Hans"
            break
        default:
            pathForLang = "Base"
            break
        }
        
        if let bundlePath = Bundle.main.path(forResource: pathForLang, ofType: "lproj"){
            let bundle = Bundle(path: bundlePath)
            return bundle!
        }
        
        return Bundle.main
    }
    
    
    static func setupLocalizedBundle(salesForceLang :String){
        if localizedLocal != salesForceLang{
            
            localizedLocal = salesForceLang
            localizedBundle = getBundleForLanguage(salesForceLang: salesForceLang)
            
            /*
            if let displayOnboarding = UserDefaultUtils.getItem(key: .displayOnboarding) as? Bool, displayOnboarding == false{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setupRootViewController(isConnectedToLV: true)
            }*/
        }
        
    }
    
}

