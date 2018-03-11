//
//  Utils.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import CoreData
import MessageUI
import SystemConfiguration.CaptiveNetwork

class Utils{
    
    static func compareItems(item1: Any?, item2: Any?) ->Bool{
        
        if let i1 = item1 as? String , let i2 = item2 as? String{
            return i1 > i2
        }
        
        if let i1 = item1 as? Int , let i2 = item2 as? Int{
            return i1 > i2
        }
        
        if let i1 = item1 as? Double , let i2 = item2 as? Double{
            return i1 > i2
        }
        
        if let i1 = item1 as? NSDate , let i2 = item2 as? NSDate{
            return i1.compare(i2 as Date) == ComparisonResult.orderedDescending
        }
        return false
    }
    
    static func adjustStartTime(startTime:NSDate?, endTime:NSDate?) ->NSDate?
    {
        if let startTime = startTime, let endTime = endTime{
            if(endTime.compare(startTime as Date) == .orderedAscending){
                return  endTime
            }
        }
        return startTime
    }
    
    
    static func getEntityFields(entity:NSManagedObject)->[String]{
        let keys = entity.entity.attributesByName
        var fields:[String]!
        for key in keys{
            fields.append(key.key)
        }
        return fields
    }
    
    
    static func removeMapSubLevels( mapping:[String:(salesforceName:String, mapToServer:Bool)])
        -> [String:(salesforceName:String, mapToServer:Bool)]
    {
        var mapping = mapping
        for map in mapping{
            if map.value.salesforceName.contains("."){
                mapping.removeValue(forKey: map.key)
            }
        }
        return mapping
    }
    
    
    static func removeNonServerMapping(mapping:[String:(salesforceName:String, mapToServer:Bool)]) ->[String:(salesforceName:String, mapToServer:Bool)]
    {
        var mapping = mapping
        for map in mapping{
            if map.value.mapToServer == false{
                mapping.removeValue(forKey: map.key)
            }
        }
        return mapping
    }
    
    static func convertWrapperObjectToSFDictionnary(item:GeneralWrapper, mapping:[String:(salesforceName:String, mapToServer:Bool)]) -> [String:AnyObject]?
    {
        
        if item.isLocal(){
            return convertManagedObjectToDictionary(item: item.dbObj!, mapping: mapping)
        }
        var mapping = removeNonServerMapping(mapping: mapping)
        mapping = removeMapSubLevels(mapping: mapping)
        
        var convertedDictionary = [String:AnyObject]() // Holds return dictionary
        var records = item.mapObj
        
        for (_, value) in mapping{
            if records?[value.salesforceName] is NSDate{
                convertedDictionary[value.salesforceName] = (records?[value.salesforceName] as! NSDate).toSfDateTime() as AnyObject?
            }
            else{
                convertedDictionary[value.salesforceName] = records?[value.salesforceName]
            }
        }
        return convertedDictionary
    }
    
    
    static func convertManagedObjectToDictionary(item:NSManagedObject, mapping:[String:(salesforceName:String, mapToServer:Bool)]) -> [String:AnyObject]?
    {
        var mapping = removeNonServerMapping(mapping: mapping)
        mapping = removeMapSubLevels(mapping: mapping)
        
        var convertedDictionary = [String:AnyObject]() // Holds return dictionary
        
        let attributes = item.entity.attributesByName // Holds the entities attributes
        
        let keys = Array(item.entity.attributesByName.keys)
        let dictionaryWithValues = item.dictionaryWithValues(forKeys: keys)
        
        for item in dictionaryWithValues{
            if let SFMappedKey = mapping[item.key]?.salesforceName{
                switch attributes[item.key]!.attributeType {
                case .dateAttributeType:
                    if !(item.value is NSNull){
                        convertedDictionary[SFMappedKey] = (item.value as! NSDate).toSfDateTime() as AnyObject?
                    }
                    
                default:
                    if item.value is NSNull{
                        
                    } else{
                        convertedDictionary[SFMappedKey] = item.value as AnyObject?
                    }
                }
            }
        }
        return convertedDictionary
    }
    
    
    //MARK: Plist functions
    static func getPlistValue(for key:String)->Any?{
        guard  let infoPlist =  Bundle.main.infoDictionary else{
            return nil;
        }
        return infoPlist[key]
    }
    
    
    static func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        do {
            if let data: NSData = jsonString.data(using: String.Encoding.utf8) as NSData?{
                let jsonObj = try JSONSerialization.jsonObject(with: data as Data, options: []) as? Dictionary<String, AnyObject>
                return jsonObj!
            }
            return [String: AnyObject]()
        }
        catch _ as NSError {
            return [String: AnyObject]()
        }
    }
    
    
    static func JSONParseArray(jsonString:String) -> [Dictionary<String,AnyObject>] {
        do {
            if let data: NSData = jsonString.data(using: String.Encoding.utf8) as NSData?{
                let jsonObj = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [Dictionary<String,AnyObject>]
                return jsonObj!
            }
            return [Dictionary<String,AnyObject>]()
        }
        catch _ as NSError {
            return [Dictionary<String,AnyObject>]()
        }
    }
    
    static func printJson(_ data : [String: AnyObject]){
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: data , options: JSONSerialization.WritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData, encoding: String.Encoding.ascii.rawValue)
            print("JSON string = \(theJSONText!)")
        }
        catch (let error) {
            print (error)
        }
    }
    
    
    
    static func getValueFromRecord(record: [String : AnyObject], mappingValue : String?)-> AnyObject?
    {
        
        let sfPath = mappingValue?.components(separatedBy: ".")
        var result = record
        if(sfPath != nil){
            for pathItem in sfPath!{
                if (result[pathItem] as? [String : AnyObject]) != nil{
                    result = (result[pathItem] as? [String : AnyObject])!
                }
                else if let currVal = result[pathItem]{
                    return currVal
                }
            }
        }
        return nil
    }
    
    
    static func arrayOfCommonElements <T, U> (lhs: T, rhs: U) -> [T.Iterator.Element] where T: Sequence, U: Sequence, T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        var returnArray:[T.Iterator.Element] = []
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    returnArray.append(lhsItem)
                }
            }
        }
        return returnArray
    }
    
    
    static func fetchSSIDInfo() ->  String? {
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                
                if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                    return unsafeInterfaceData["SSID"] as? String
                }
            }
        }
        return nil
    }
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
    static func listToSOQLString(list:[String]) -> String {
        let localList = list.filter { $0 != ""}
        
        let SOOQListString = localList.reduce(""){ (prev, item) -> String in
            var prefix = ","
            if prev == ""{
                prefix = ""
            }
            
            return "\(prev)\(prefix) '\(item)'"
        }
        if SOOQListString == ""{
            return "'null'"
        }
        return SOOQListString
    }
    
    static func listToString(list:[String]) -> String {
        let localList = list.filter { $0 != ""}
        
        let ListString = localList.reduce(""){ (prev, item) -> String in
            var prefix = ";"
            if prev == ""{
                prefix = ""
            }
            
            return "\(prev)\(prefix)\(item)"
        }
        return ListString
    }
    
    /*
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }*/  
    
    static func getData(name: String) -> Data? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                return nil
        }
        
        // Validate data
        guard let data = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return data
    }
}
