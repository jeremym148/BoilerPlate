//
//  UserDefaultUtils.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation

class UserDefaultUtils{
    
    static func saveItem(key:UserDefaultKey, value:Any){
        if value is NSNull{
            return
        } else{
            UserDefaults.standard.set(value, forKey:key.rawValue)
        }
        
    }
    
    
    static func removeItem(key:UserDefaultKey){
        removeItems(keys: [key])
    }
    
    static func removeItems(keys:[UserDefaultKey]){
        for key in keys{
            if (UserDefaults.standard.object(forKey: key.rawValue) != nil){
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    
    static func getItems(keys: [UserDefaultKey]) -> [UserDefaultKey:Any]{
        var data = [UserDefaultKey:Any]()
        for key in keys{
            data[key] = getItem(key: key)
        }
        return data
    }
    
    static func getItem(key: UserDefaultKey) -> Any?{
        return UserDefaults.standard.object(forKey:key.rawValue)
    }
    
    static func removeAll(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    static func addItems(keys:[UserDefaultKey], values:[String:AnyObject]){
        
        func addSubkeys(key:UserDefaultKey, values:[String:AnyObject], subKeys: String){
            var subKeys = key.rawValue.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true).map{ String($0) }
                if let value = values[subKeys.first!]{
                    if subKeys[1].contains("."){
                        addSubkeys(key: key, values: value as! [String:AnyObject], subKeys: subKeys[1])
                    } else {
                        UserDefaultUtils.saveItem(key: key, value: value[subKeys[1]])
                    }
                }
        }
        
        for key in keys{
            if key.rawValue.contains("."){
               addSubkeys(key: key, values: values, subKeys: key.rawValue)
            } else {
                if values[key.rawValue] is NSNull {
                    continue
                }
                else if let value = values[key.rawValue]{
                    print(key, value)
                    UserDefaultUtils.saveItem(key: key, value: value)
                }
            }
            
        }
        
        
        
    }
    
    
    
}
