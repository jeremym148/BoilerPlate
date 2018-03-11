//
//  CoreDataUtils.swift
//  Berluti
//
//  Created by elie buff on 12/11/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//


import CoreData
import SalesforceSDKCore

class CoreDataUtils {
    static let sharedInstance = CoreDataUtils()
    let DBName = "Berluti"
    
    var context:NSManagedObjectContext!
    var psc:NSPersistentStoreCoordinator!
    var model:NSManagedObjectModel!
    var store:NSPersistentStore?
    
    private init() {
        initDB()
    }
    
    func initDB(){
        //1
        let bundle = Bundle.main
        if let modelURL = bundle.url(forResource: DBName, withExtension:"momd") {
            model = NSManagedObjectModel(contentsOf: modelURL)!
            
            //2
            psc = NSPersistentStoreCoordinator(managedObjectModel:model)
            
            //3
            context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            context.persistentStoreCoordinator = psc
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            //4
            let documentsURL = CoreDataUtils.applicationDocumentsDirectory()
            
            let storeURL =
                documentsURL.appendingPathComponent(DBName)
            
            print("\r\n\r\nStoreUrl: \(String(describing: storeURL))\r\n\r\n")
            
            var options = [AnyHashable: Any]()
            options[NSMigratePersistentStoresAutomaticallyOption] = true
            options[NSInferMappingModelAutomaticallyOption] = true
            options["journal_mode"] = "DELETE"
            
            
            var error: NSError? = nil
            do {
                store = try psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: storeURL,
                                                   options: options)
            } catch let error1 as NSError {
                error = error1
                store = nil
            }
            
            if store == nil {
                print("Error adding persistent store: \(String(describing: error))")
                abort()
            }
        }
        
    }
    
    func rollbackContext() {
        if context.hasChanges {
            context.rollback()
        }
    }
    
    func saveContext() {
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save: \(String(describing: error)), \(String(describing: error?.userInfo))")
            }
        }
    }
    
    func saveContext(context :NSManagedObjectContext, withParent: Bool) {
        if context.hasChanges {
            context.performAndWait({
                do {
                    try context.save()
                    if withParent {
                        self.saveContext()
                    }
                } catch let error as NSError {
                    print("Could not save: \(error)")
                }
            })
        }
    }
    
    func createChildContext() -> NSManagedObjectContext{
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        childContext.parent = context
        
        return childContext
    }
    
    class func applicationDocumentsDirectory() -> NSURL {
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        return urls[0] as NSURL
    }
    
    func deleteAllData (excludeObj : [String]) {
        for (entityName, entityDescription) in psc.managedObjectModel.entitiesByName {
            if !excludeObj.contains(entityName){
                deleteAllObjects(entity: entityDescription)
            }
        }
        saveContext()
    }
    
    func deleteAllInstance(of entity: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try psc.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func deleteAllObjects(entity: NSEntityDescription) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        do {
            let result = try context.fetch(fetchRequest)
            for item in result {
                context.delete(item as! NSManagedObject)
            }
        } catch _ {
            
        }
        saveContext()
    }
    
    
    static func getRecordsKeyValues(_ records :[Dictionary<String, AnyObject>], keys : [String]) -> [String: Set<String>]{
        var result = [String: Set<String>]()
        
        for record in records{
            for key in keys{
                if result[key] == nil{
                    result[key] = []
                }
                if let keyvalue = record[key] as? String{
                    result[key]!.insert(keyvalue)
                }
            }
        }
        
        return result
    }
    static func findOrCreateItems(_ context :NSManagedObjectContext, records :[Dictionary<String, AnyObject>], recordsValues : Set<String>, entity : String, key : String, attribute : String) -> [String: NSManagedObject?]{
        
        let existingItems = fetchExistingItems(context, recordsValues: recordsValues, entity: entity, key: key, attribute:attribute)
        let result = createMissingItems(context, existingItemsMap: existingItems, recordsValue: recordsValues, entity: entity, attribute: attribute)
        
        return result
    }
    
    static fileprivate func fetchExistingItems(_ context :NSManagedObjectContext, recordsValues: Set<String>, entity : String, key : String, attribute : String) -> [String: NSManagedObject?]{
        
        var result = [String: NSManagedObject!]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(attribute) IN %@", recordsValues)
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            for fetchResult in fetchResults!{
                if let attr = fetchResult.value(forKey: attribute) as? String{
                    result[attr] = fetchResult
                }
            }
        } catch let fetchError as NSError {
            print("\r\n\r\nERROR - Execute Fetch: \(fetchError)\r\n\r\n")
        }
        return result
    }
    
    static func createNewObject(_ entityName : String) ->NSManagedObject{
        let context = sharedInstance.context
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context!)
    }
    static private func createMissingItems(_ context :NSManagedObjectContext, existingItemsMap: [String: NSManagedObject?], recordsValue: Set<String>, entity : String, attribute : String) -> [String: NSManagedObject?]{
        var existingItemsMap = existingItemsMap
        
        for value in recordsValue {
            guard let _ = existingItemsMap[value] else{
                let newItem = NSEntityDescription.insertNewObject(forEntityName: entity, into:  context)
                newItem.setValue(value, forKey: attribute)
                existingItemsMap[value] = newItem
                continue
            }
        }
        return existingItemsMap
    }
    static func ParseValue(attrDescription: NSAttributeDescription, obj: NSManagedObject, value: AnyObject?)
    {
        guard let val = value else { return }
        switch attrDescription.attributeType {
        case .integer16AttributeType,
             .integer32AttributeType,
             .integer64AttributeType:
            obj.setValue(parseValueAsInt(value: val), forKey: attrDescription.name)
        case .decimalAttributeType,
             .doubleAttributeType,
             .floatAttributeType:
            obj.setValue(parseValueAsDouble(value: val), forKey: attrDescription.name)
        case .booleanAttributeType:
            obj.setValue(parseValueAsBoolean(value: val), forKey: attrDescription.name)
        case .dateAttributeType:
            if let date = parseValueAsDate(value: val) {
                obj.setValue(date, forKey: attrDescription.name)
            }
        default:
            obj.setValue(parseValueAsString(value: val), forKey: attrDescription.name)
        }
    }
    
    
    static func parseValueAsString(value: AnyObject) -> String?
    {
        if value is NSNull {
            return nil
        }
        if let val = value as? String {
            return val
        }
        return nil
    }
    
    
    static func parseValueAsInt(value: AnyObject) -> Int?
    {
        if value is NSNull {
            return nil
        }
        if let val = value as? Int {
            return val
        }
        return nil
    }
    
    
    static func parseValueAsDouble(value: AnyObject) -> Double?
    {
        if value is NSNull {
            return nil
        }
        if let val = value as? Double {
            return val
        }
        return nil
    }
    
    
    static func parseValueAsBoolean(value: AnyObject) -> Bool
    {
        if value is NSNull {
            return false
        }
        if let val = value as? Bool {
            return val
        }
        return false
    }
    
    
    static func parseValueAsDate(value: AnyObject) -> NSDate?
    {
        if let date = parseDateTime(value: value) {
            return date
        }
        return parseDate(value: value)
    }
    
    
    static func parseDateTime(value: AnyObject) -> NSDate?
    {
        if value is NSNull {
            return nil
        }
        if let val = value as? String  {
            let formater = DateFormatter()
            formater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'+0000'" //2017-01-29T15:00:00.000+0000
            
            return formater.date(from: val) as NSDate?
        }
        return nil
    }
    
    
    static func parseDate(value: AnyObject) -> NSDate?
    {
        if value is NSNull {
            return nil
        }
        if let val = value as? String  {
            let formater = DateFormatter()
            formater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formater.dateFormat = "yyyy-MM-dd" //2015-12-22
            
            return formater.date(from: val) as NSDate?
        }
        return nil
    }
    
    
    static func populate(records: [[String : AnyObject]],
                         withMany: String?,
                         for entityName:String,
                         in context: NSManagedObjectContext)
    {
        if let withMany = withMany{
            for record in records{
                self.populate(record: record, withMany:withMany, for:entityName, in: context)
            }
        } else{
            for record in records{
                var _ = self.populate(record: record, for:entityName, in: context)
            }
        }
        
    }
    
    
    static func populate(record: [String : AnyObject],
                         withMany: String,
                         for entityName:String,
                         in context:NSManagedObjectContext)
    {
        // withMany = "values" FOR EXAMPLE
        
        let newProduct=populate(record: record, for: entityName,in:context)
        let items = newProduct.mutableSetValue(forKey: withMany)
        if let values = record[withMany] as? [[String: AnyObject]] {
            for value in values {
                let newValue = populate(record: value, for:withMany, in: context)
                items.add(newValue)
            }
        }
    }
    
    
    static func populate(record: [String : AnyObject],
                         for entityName:String,
                         in context: NSManagedObjectContext)
        -> NSManagedObject
    {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        let attributes = newItem.entity.attributesByName
        
        for (name, attDescription) in attributes {
            if let newRecord = record[name]{
                CoreDataUtils.ParseValue(attrDescription: attDescription, obj: newItem, value: newRecord)
            }
        }
        return newItem
    }
    
}




