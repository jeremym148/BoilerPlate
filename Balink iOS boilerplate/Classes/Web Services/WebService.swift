//
//  WebService.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
import os
import CoreData
import SalesforceSDKCore
import ReSwift

class WebService{
    static let WS_ENDPOINT = "/services/apexrest/"
    
    static let WS_ATTEMPT_NUMBER = 3
    
    static func SOQLExecuter(query:String,
                             onFailure: @escaping ((_: CustomError?) -> ()),
                             onSuccess: @escaping ((_ records:[[String: AnyObject]]) -> ()) ){
        var totalRecords = [[String: AnyObject]]()
        func GetNextRecordsURL(nextRecordsUrl :String){
            
            let request = SFRestRequest(method: .GET, path: nextRecordsUrl, queryParams: nil)
            
            
            SFRestAPI.sharedInstance().send(request, fail: { (err, urlResp) in
                os_log(err as! StaticString, log: OSLog.default, type: .error)
                onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
            }) { (response, urlResp) in
                let response1 = response as AnyObject
                
                guard let records = response1["records"] as? [[String: AnyObject]] else{
                    return
                }
                if let nextRecordsUrl = response1["nextRecordsUrl"] as? String{
                    DispatchQueue.main.async {
                        print("nextRecordsUrl2",nextRecordsUrl)
                        print("nextRecordsUrl2records2",records.count)
                        GetNextRecordsURL(nextRecordsUrl: nextRecordsUrl)
                    }
                } else{
                    onSuccess(totalRecords)
                }
            }
        }
        
        func performSOQLQuery(numOfTry :Int){
            SFRestAPI.sharedInstance().performSOQLQuery(query, fail: { (err, urlResp) in
                print(err ?? "")
                if numOfTry < WS_ATTEMPT_NUMBER{
                    performSOQLQuery(numOfTry: numOfTry + 1)
                }
                else{
                    onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
                }
            })
            {(response, urlResp) in
                guard let records = response!["records"] as? [[String: AnyObject]] else{
                    return
                }
                if let nextRecordsUrl = response!["nextRecordsUrl"] as? String{
                    DispatchQueue.main.async {
                        print("nextRecordsUrl1",nextRecordsUrl)
                        print("nextRecordsUrl1records2",records.count)
                        GetNextRecordsURL(nextRecordsUrl: nextRecordsUrl)
                    }
                }
                    onSuccess(records)

            }
        }
        
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        if query == ""{
            return
        }
        print(query)
        performSOQLQuery(numOfTry: 1)
        
    }
    
    static func SOSLExecuter(query:String,
                             onFailure: @escaping ((_: CustomError?) -> ()),
                             onSuccess: @escaping ((_ records:[[String: AnyObject]]) -> ()) ){
        
        
        func performSOSLQuery(numOfTry :Int){
            var request = SFRestAPI.sharedInstance().request(forSearch: query)
            
            SFRestAPI.sharedInstance().send(request,fail: { (err, urlResp) in
                os_log(err as! StaticString, log: OSLog.default, type: .error)
                onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
            }) { (response, urlResp) in
                if let  result = response as? [String:AnyObject], let results = result["searchRecords"] as? [[String:AnyObject]]{
                    onSuccess(results)
                } else{
                    onFailure(nil)
                }
            }
        }
        
        if query == ""{
            return
        }
        print(query)
        performSOSLQuery(numOfTry: 1)
        
    }
    
    
    static func delete(objectName:String, id:String,
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()) )
    {
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        SFRestAPI.sharedInstance().performDelete(withObjectType: objectName, objectId: id, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }){ (records, urlResponse) in
            onSuccess(records)
        }
    }
    
    
    static func upsert(objectName:String, objectId:String?, fields:[String:AnyObject],
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()) )
    {
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        if let objectId = objectId{
            self.update(objectName: objectName, objectId: objectId, fields: fields,
                        onFailure: onFailure, onSuccess: onSuccess)
        }
        else{
            self.insert(objectName: objectName, fields: fields, onFailure: onFailure,
                        onSuccess: onSuccess)
        }
    }
    
    
    static func insert(objectName:String, fields:[String:AnyObject],
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()) )
    {
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        SFRestAPI.sharedInstance().performCreate(withObjectType: objectName, fields: fields, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }){ (records, urlResponse) in
            onSuccess(records)
        }
    }
    
    
    static func update(objectName:String, objectId:String?, fields:[String:AnyObject],
                       onFailure: @escaping ((_: CustomError?) -> ()),
                       onSuccess: @escaping ((_ records:[AnyHashable: Any]?) -> ()) )
    {
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        var newFields = fields
        newFields.removeValue(forKey: "Id")
        SFRestAPI.sharedInstance().performUpdate(withObjectType: objectName, objectId: objectId!, fields: newFields, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }){ (records, urlResponse) in
            onSuccess(records)
        }
    }
    
    static func ExecuteWS(restMethod: SFRestMethod, wsName :String, queryParams:[String: String]?, body:[String: AnyObject]?, onFailure: @escaping (CustomError?)->Void, onComplete: @escaping (_ records:Any?) -> ()){
        
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        let request = SFRestRequest(method: restMethod, path: wsName, queryParams: queryParams)
        request.endpoint = self.WS_ENDPOINT
        
        if let body = body, restMethod == .POST{
            request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        }
        
        SFRestAPI.sharedInstance().send(request, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }){ (records, urlResponse) in
            onComplete(records)
        }
    }
    
    static func UploadUserProfile(imageData :Data,
                                  onFailure: @escaping (CustomError?)->Void,
                                  onComplete: @escaping (_ profileUrl : String?) -> ()){
        
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        let apiVersion = SFRestAPI.sharedInstance().apiVersion
        let currentUserId = SFUserAccountManager.sharedInstance().currentUserIdentity?.userId
        
        
        let path = "/\(apiVersion)/connect/user-profiles/\(currentUserId)/photo"
        let params = [String : String]()
        
        
        let request = SFRestRequest(method: .POST, path: path, queryParams: params)
        request.addPostFileData(imageData, paramName: "", description: "fileUpload", fileName: "My Profile", mimeType: "image/jpeg")
        
        SFRestAPI.sharedInstance().send(request, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }, complete: { (response, urlResp) in
            print(response!)
            if let response = response as? [String: Any]{
                onComplete(response["largePhotoUrl"] as! String?)
            }
        })
    }
    
    static func GetAttachmentBody(attachmentId :String,
                                  onFailure: @escaping (CustomError?)->Void,
                                  onComplete: @escaping (_ imageData : Any?) -> ()){
        if !checkWSCallValidity(isInvalid: onFailure){
            return
        }
        
        let apiVersion = SFRestAPI.sharedInstance().apiVersion
        
        let path = "/\(apiVersion)/sobjects/Attachment/\(attachmentId)/body"
        
        let request = SFRestRequest(method: .GET, path: path, queryParams: nil)
        request.endpoint = "/services/data/"
        request.parseResponse = false
        SFRestAPI.sharedInstance().send(request, fail: { (err, urlResp) in
            print(err ?? "")
            onFailure(CustomError(localizedTitle: "Error", localizedDescription: getErrorDescription(err: err), code: 1))
        }){ (records, urlResponse) in
            onComplete(records)
        }
    }
    
    static func checkWSCallValidity(isInvalid: @escaping ((_: CustomError?) -> ())) -> Bool{
        /*if !Utils.isAllowedSSID(){
            let alertMsg = Utils.SSIDAlertMessage()
            isInvalid(CustomError(localizedTitle: alertMsg.title, localizedDescription: alertMsg.description, code: 1))
            return false
        }*/
        return true
    }
    
    static func getErrorDescription(err :Error?) ->String{
        var errorDescription = err?.localizedDescription ?? ""
        /*if let underlyingError = (err! as NSError).userInfo["NSUnderlyingError"] as? NSError{
         errorDescription = underlyingError.localizedDescription
         }*/
        
        return errorDescription
    }
    
    
    //    func performSOSLQuery(query:String,
    //                          onFailure: @escaping ((_: Error?) -> ()),
    //                          onSuccess: @escaping ((_ records:[[String: AnyObject]]) -> ()) )
    //    {
    //        SFRestAPI.sharedInstance().performSOSLSearch(query, fail: { (err, urlResp) in
    //            print(err ?? "")
    //            onFailure(err)
    //        }, complete: {(response, urlResp) in
    //            guard let records = response!["records"] as? [[String: AnyObject]] else{
    //                return
    //            }
    //
    //            if let nextRecordsUrl = response!["nextRecordsUrl"] as? String{
    //                DispatchQueue.main.async {
    //                    print("nextRecordsUrl1",nextRecordsUrl)
    //                    print("nextRecordsUrl1records2",records.count)
    //                    GetNextRecordsURL(nextRecordsUrl: nextRecordsUrl)
    //                }
    //            }
    //
    //            onSuccess(records)
    //        })
    //    }

}
