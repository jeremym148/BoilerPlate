//
//  NSManagedObjectParent.swift
//  Berluti
//
//  Created by elie buff on 12/11/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//


import CoreData

protocol NSManagedObjectParent {
    static var entityName: String {get}
    static var SFObjectName: String {get}
    static var salesforceMapping: [String: (salesforceName:String, mapToServer:Bool)] {get}
    static func executeBeforeDelete(_ managedObj :NSManagedObject)
    static func isReadyForDelete(_ managedObj :NSManagedObject) ->Bool
}

extension NSManagedObjectParent{
    static func Upsert(_ records: [Dictionary<String, AnyObject>],
                       in context: NSManagedObjectContext,
                       deleteAllNotIn: Bool = false,
                       onItemUpsert: ((NSManagedObjectContext, NSManagedObject, Dictionary<String, AnyObject> ) -> Void)? = nil){
        context.performAndWait { () -> Void in
            var recordsValues = CoreDataUtils.getRecordsKeyValues(records, keys: ["Id"])
            if recordsValues.count == 0{
                if deleteAllNotIn {
                    DeleteAllNotIN([])
                }
                return;
            }
            
            var itemMap = CoreDataUtils.findOrCreateItems(context, records: records, recordsValues: recordsValues["Id"]!, entity: entityName, key: "Id", attribute: "id")
            
            for var record in records {
                let itemId = record["Id"] as! String
                let item = itemMap[itemId]
                let managedObject = self.populateItem(record: record, item:item!!)
                if let onItemUpsert = onItemUpsert{
                    onItemUpsert(context, managedObject, record)
                }
            }
            CoreDataUtils.sharedInstance.saveContext(context: context, withParent: true)
            
            if let recordIds = recordsValues["Id"], deleteAllNotIn{
                DeleteAllNotIN(recordIds)
            }
        }
    }
    
    
    static func DeleteAllNotIN(_ itemsIds: Set<String>){
        
        let context = CoreDataUtils.sharedInstance.context!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "NOT( id IN %@)", itemsIds)
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            for nsObj in fetchResults!{
                executeBeforeDelete(nsObj)
                
                if isReadyForDelete(nsObj){
                    context.delete(nsObj)
                }
            }
            CoreDataUtils.sharedInstance.saveContext()
        } catch let fetchError as NSError {
            print("\r\n\r\nERROR - Delete Object: \(fetchError)\r\n\r\n")
        }
    }
    
    static func isReadyForDelete(_ managedObj :NSManagedObject) ->Bool{
        return true
    }
    
    static func executeBeforeDelete(_ managedObj :NSManagedObject){}
    
    static func populateItem(record: [String : AnyObject], item:NSManagedObject) -> NSManagedObject
    {
        let attributes = item.entity.attributesByName
        
        for (name, attDescription) in attributes {
            if let newRecord = getRecord(record: record, attribute: name){
                CoreDataUtils.ParseValue(attrDescription: attDescription, obj: item, value: newRecord)
            }
        }
        return item
    }
    
    
    static func getObjectBySFID(context: NSManagedObjectContext, id: String?) -> NSManagedObject?
    {
        var result: NSManagedObject?
        if id != nil && id != ""{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "id = %@", id!)
            
            do {
                let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
                if (fetchResults?.count)! > 0 {
                    result = fetchResults![0]
                }
            } catch let err as NSError {
                print("\r\n\r\nERROR - Execute Fetch: \(err)\r\n\r\n")
                result = nil
            }
        }
        return result
    }
    
    
    static func getById(context: NSManagedObjectContext, id: NSManagedObjectID) -> NSManagedObject? {
        return context.object(with: id)
    }
    
    
    static func delete(context: NSManagedObjectContext, id: NSManagedObjectID)
    {
        if let itemToDelete = getById(context: context, id: id){
            context.delete(itemToDelete)
        }
    }
    
    
    static func performFetchRequest(context: NSManagedObjectContext, withPredicate: NSPredicate?, andSortBy: [NSSortDescriptor]?) -> [NSManagedObject]?
    {
        var result: [NSManagedObject]?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = withPredicate
        fetchRequest.sortDescriptors = andSortBy
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            result = fetchResults
        } catch let err as NSError {
            print("\r\n\r\nERROR - Execute Fetch: \(err)\r\n\r\n")
            result = nil
        }
        return result
    }
    
    
    func ParseValueToValidJSONValue(attrDescription: NSAttributeDescription, value: AnyObject?)
        -> String?
    {
        
        if let val = value {
            switch attrDescription.attributeType {
            case .booleanAttributeType:
                return "\((val as! Bool) ? "true" : "false")"
            case .dateAttributeType:
                return nil
            default:
                return "\(val)"
            }
        }
        
        return nil
    }
    
    
    static func getRecord(record: [String : AnyObject], attribute:String)-> AnyObject?
    {
        
        let sfPath = salesforceMapping[attribute]?.salesforceName.components(separatedBy: ".")
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
    
    static func getEntityFields(salesforceMapping: [String: (salesforceName:String, mapToServer:Bool)]) -> String
    {
        let preFields = (salesforceMapping.reduce("") {text, name in "\(text) \(name.value.salesforceName),"})
        return preFields.substring(to: preFields.index(before: preFields.endIndex))
    }
}

