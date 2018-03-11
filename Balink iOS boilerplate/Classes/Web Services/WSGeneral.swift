//
//  WSGeneral.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit
import CoreData

protocol WSGeneral{
    static var salesforceObjectName:String {get}
    static var toSalesforceMapping:[String: (salesforceName:String, mapToServer:Bool)] {get}
}
extension WSGeneral{
    
    // MARK: Appointment Method
    static func ExecuteSOQlQuery(query: String,
                                 onFailure: @escaping ((_: CustomError?) -> ()),
                                 onSuccess: @escaping ((_ records:[[String: AnyObject]]) -> ()))
    {
        WebService.SOQLExecuter(query: query ,
                                onFailure: onFailure,
                                onSuccess: onSuccess)
    }
    
    static func ExecuteSOSLQuery(query: String,
                                 onFailure: @escaping ((_: CustomError?) -> ()),
                                 onSuccess: @escaping ((_ records:[[String: AnyObject]]) -> ()))
    {
        WebService.SOSLExecuter(query: query ,
                                onFailure: onFailure,
                                onSuccess: onSuccess)
    }
    
    
    static func delete(objectId: String,
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()))
    {
        WebService.delete(objectName: salesforceObjectName,
                          id: objectId,
                          onFailure: onFailure,
                          onSuccess: onSuccess)
    }
    
    
    static func upsert(managedObj: NSManagedObject,
                       objectId: String?,
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()))
    {
        let convertedObject = Utils.convertManagedObjectToDictionary(item: managedObj, mapping: toSalesforceMapping)
        
        upsertMap(mapObj: convertedObject, objectId: objectId, onFailure: onFailure, onSuccess: onSuccess)
    }
    
    static func upsertWrapper(wrapperObject: GeneralWrapper,
                              onFailure: @escaping ((_: CustomError?) -> ()),
                              onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()))
    {
        let objId = wrapperObject.Id
        let convertedObject = Utils.convertWrapperObjectToSFDictionnary(item: wrapperObject, mapping: toSalesforceMapping)
        
        upsertMap(mapObj: convertedObject, objectId: objId, onFailure: onFailure, onSuccess: onSuccess)
    }
    
    static func upsertMap(mapObj: [String:AnyObject]?,
                          objectId: String?,
                          onFailure: @escaping ((_: CustomError?) -> ()),
                          onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()))
    {
        WebService.upsert(objectName: salesforceObjectName,
                          objectId: objectId,
                          fields: mapObj!,
                          onFailure:onFailure, onSuccess: onSuccess)
    }
}

