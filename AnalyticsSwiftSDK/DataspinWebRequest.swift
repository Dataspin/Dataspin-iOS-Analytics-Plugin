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
    var response: JSON? = nil
    var error: NSError? = nil
}

public class DataspinWebRequest {
    var properties : Properties
    
    init (httpMethod: HttpMethod, dsMethod: DataspinMethod, parameters: [String: AnyObject]? = nil, optionalUrl: String? = nil, callback: () -> Void) {
        properties = Properties(URL: NSURL(string: DataspinManager.Instance.config!.GetURL(DataspinMethod.RegisterUser))!, httpMethod: httpMethod, dataspinMethod: dsMethod, parameters: parameters, optionalUrl: optionalUrl, response: nil, error: nil)
        
        DataspinManager.Instance.Log("New request: "+self.ToString())
        
        let mutableURLRequest = NSMutableURLRequest(URL: properties.URL)
        mutableURLRequest.HTTPMethod = httpMethod.rawValue
        
        // Authorization header
        mutableURLRequest.setValue("Token \(DataspinManager.Instance.config!.ApiKey)", forHTTPHeaderField: "Authorization")
        
        var requestConvertible : URLRequestConvertible = ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        
        request(requestConvertible).responseJSON{ (request, response, data, error) in
            let dict = data as? NSDictionary
            let json = JSON(data!)
            print(json["uuid"])
            let userName:JSON = json["uuid"]
       }
    }
    
    public func ToString() -> String {
        let stringData = "[Request] URL: \(properties.URL.absoluteString!), DSMethod: \(properties.dataspinMethod.rawValue), HttpMethod: \(properties.httpMethod.rawValue), \(properties.parameters?.debugDescription)"
        return stringData
    }
}
