//
//  GeneralWrapper.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//


import CoreData



class GeneralWrapper :Hashable{
    static func ==(lhs: GeneralWrapper, rhs: GeneralWrapper) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    var hashValue: Int {
        return self.Id?.hashValue ?? 0
    }
    
    
    var Id : String?{
        get{ return self.getDataFor(key: "Id") as? String}
        set{ self.setDataFor(key: "Id", value: newValue)}
    }
    
    var dbObj: NSManagedObject?
    var mapObj: [String: AnyObject]?
    
    required init(managedObject: NSManagedObject){
        self.dbObj = managedObject
    }
    
    required init(map: [String: AnyObject]){
        self.mapObj = map
    }
    
    func isLocal() ->Bool{
        return dbObj != nil
    }
    
    func isCoreDataObject() ->Bool{
        return dbObj != nil
    }
    
    func getDataFor(key :String) -> Any?{
        if let dbObj = dbObj{
            return dbObj.value(forKey: key)
        }

        if let mapObj = mapObj{
            if let mappingKey =  self.getFieldsMapping()[key]?.salesforceName{
                return getRecord(record: mapObj, mappingKey: mappingKey)
            }
            return getRecord(record: mapObj, mappingKey: key)
        }
        
        return nil
    }
    
    func setDataFor(key :String, value : Any?){
        if let dbObj = dbObj, let value = value{
            dbObj.setValue(value, forKey: key)
        }
        
        if let _ = mapObj{
            if let mappingValue = self.getFieldsMapping()[key]?.salesforceName{
                mapObj?[mappingValue] = value as AnyObject?
            }else{
                mapObj?[key] = value as AnyObject?
            }
        }
    }
    
    func getFieldsMapping() -> [String: (salesforceName:String, mapToServer:Bool)]{
        return [:]
    }
    
    //MARK: Private functions
    private func getRecord(record: [String : AnyObject], mappingKey:String)-> AnyObject?
    {
        
        let sfPath = mappingKey.components(separatedBy: ".")
        var result = record
        
        for pathItem in sfPath{
            if (result[pathItem] as? [String : AnyObject]) != nil{
                result = (result[pathItem] as? [String : AnyObject])!
            }
            else if let currVal = result[pathItem]{
                return currVal
            }
        }
        
        return nil
    }
    
    static func fromCoreData<T :GeneralWrapper>(items: [NSManagedObject]) -> [T]{
        var result = [T]()
        
        for item in items{
            result.append(T.init(managedObject: item))
        }
        return result
    }
    
    static func fromSF<T :GeneralWrapper>(items: [[String: AnyObject]]) -> [T]{
        var result = [T]()
        
        for item in items{
            result.append(T.init(map: item))
        }
        return result
    }
    
    static func delete(item:GeneralWrapper){
        if let object = item.dbObj{
            let context = CoreDataUtils.sharedInstance.context
            context?.delete(object)
            CoreDataUtils.sharedInstance.saveContext(context: context!, withParent: true)
        }
    }
}

