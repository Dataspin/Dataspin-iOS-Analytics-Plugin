//
//  DataspinWebRequest.swift
//  AnalyticsSwiftSDK
//
//  Created by Rafal on 04.05.2015.
//  Copyright (c) 2015 Rafal. All rights reserved.
//

import Foundation

struct Properties {
    var URL : NSURL
    var httpMethod: HttpMethod
    var dataspinMethod: DataspinMethod
    var parameters: [String: AnyObject]? = nil
    var optionalUrl: String? = nil
    var responseCode : Int? = nil
    var response: NSDictionary? = nil
    var error: NSError? = nil
}

public class DataspinWebRequest {
    var properties : Properties
    
    init (httpMethod: HttpMethod, dsMethod: DataspinMethod, parameters: [String: AnyObject]? = nil, optionalUrl: String? = nil) {
        properties = Properties(URL: NSURL(string: DataspinManager.Instance.config!.GetURL(dsMethod))!, httpMethod: httpMethod, dataspinMethod: dsMethod, parameters: parameters, optionalUrl: optionalUrl, responseCode: nil, response: nil, error: nil)
        
        DataspinManager.Instance.Log("New request: "+self.ToString())
    }
    
    public func Fire(completion: ((error: NSError?, response: NSDictionary?) -> Void)) {
        DataspinManager.Instance.Log("Firing \(self.properties.dataspinMethod.rawValue) request")
     
        if(self.properties.httpMethod == HttpMethod.GET) {
            var strUrl = DataspinManager.Instance.config!.GetURL(self.properties.dataspinMethod)
            strUrl += parametersToURLSuffix()
            self.properties.URL = NSURL(string: strUrl)!
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: properties.URL)
        mutableURLRequest.HTTPMethod = self.properties.httpMethod.rawValue
        mutableURLRequest.setValue("Token \(DataspinManager.Instance.config!.ApiKey)", forHTTPHeaderField: "Authorization")
        
        let requestConvertible : URLRequestConvertible = ParameterEncoding.JSON.encode(mutableURLRequest, parameters: self.properties.parameters).0
        
        let requestBody = self.properties.httpMethod == HttpMethod.GET ? mutableURLRequest : requestConvertible
        
        request(requestBody).responseJSON{ (request, response, data, error) in
            println("Request: \(request), Error: \(error), Response Code: \(response?.statusCode), Response: \(data)")
            var dict : NSDictionary = NSDictionary()
            if(data != nil) {
                dict = (data as? NSDictionary)!
            }
            
            self.properties.responseCode = response?.statusCode
            self.properties.response = dict
            self.properties.error = error
            
            if(self.properties.error == nil && !(self.properties.responseCode >= 200 && self.properties.responseCode < 300)) {
                println("Adding error infomation...")
                self.properties.error = NSError(domain: "Something went wrong with Client<->Server communication", code: self.properties.responseCode!, userInfo: (self.properties.response as! [NSObject : AnyObject]))
            }
            
            DataspinManager.Instance.Log("Request \(self.properties.dataspinMethod.rawValue) completed with code \(self.properties.responseCode), Response: \(self.properties.response)")
            completion(error: self.properties.error, response: self.properties.response)
            
        }
    }
    
    private func parametersToURLSuffix() -> String{
        let urlParamsDict = self.properties.parameters! as NSDictionary
        var iterator : Int = 0
        var urlSuffix : String = ""
        for(key, value) in urlParamsDict {
            if(iterator == 0)  { urlSuffix += "?\(key)=\(value)" }
            else { urlSuffix += "&\(key)=\(value)" }
            iterator++
        }
        
        return urlSuffix
    }
    
    public func ToString() -> String {
        let stringData = "[Request] URL: \(properties.URL.absoluteString!), DSMethod: \(properties.dataspinMethod.rawValue), HttpMethod: \(properties.httpMethod.rawValue), \(properties.parameters?.debugDescription)"
        return stringData
    }
    
    public func Result() -> String {
        let stringData = "[Request] Error: \(properties.error), Response: \(properties.response)"
        return stringData
    }
}