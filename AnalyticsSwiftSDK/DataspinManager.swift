//
//  DataspinManager.swift
//  An iOS library for communication with Dataspin.io
//
//  Created by Rafal on 03.05.2015.
//  Copyright (c) 2015 Dataspin.io All rights reserved.
//

import Foundation

private let _SomeManagerSharedInstance = DataspinManager()

public class DataspinManager {
    
    private var LogTag : String = "[Dataspin]";
    
    public static let Instance = DataspinManager()
    var config: Config?
    
    init() {
        config = Config()
    }
    
    struct Config {
        private var DomainName = "hyperbees"
        private var ApiKey = "api key not provided"
        private var DebugMode = true
        
        func GetURL() -> String {
            return "http://"+DomainName+".dataspin.io/"
        }
    }
    
    private func Log(message: String) {
        if(config!.DebugMode) { println("\(LogTag) :\(message)") }
    }
    
    //! Use for Dataspin initialization at the game start
    public func Start(domainName: String, apiKey: String, debugMode:Bool) {
        config = Config(DomainName: domainName, ApiKey: apiKey, DebugMode: debugMode)
        
        Log("DataspinSDK started with \(self.config!.GetURL()) URL and key \(self.config!.ApiKey), Debug: \(debugMode)")
    }
    
    public func RegisterUser(userName: String?=nil, surname: String?=nil, email: String?=nil, facebook_id: String?=nil, gamecenter_id: String?=nil, forceUpdate: Bool?=false) {
        
        if let dataspinDefaults = NSUserDefaults.standardUserDefaults().objectForKey("dataspin_uuid") as? [NSString] {
            
        }
        else {
            let parameters = [
                "name": userName!,
                "surname": surname!,
                "email": email!,
                "facebook_id": facebook_id!,
                "gamecenter_id": gamecenter_id!
            ]
            
            var url : String = self.config!.GetURL()
            
            let URL = NSURL(string: url)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("Token \(self.config!.ApiKey)", forHTTPHeaderField: "Authorization")
            
            ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            
            request(.GET, url, parameters: parameters, encoding: .JSON).response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
            }

        }
    }
}
