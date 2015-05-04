//
//  DataspinManager.swift
//  An iOS library for communication with Dataspin.io
//
//  Created by Rafal on 03.05.2015.
//  Copyright (c) 2015 Dataspin.io All rights reserved.
//

import Foundation

private let _SomeManagerSharedInstance = DataspinManager()

public enum DataspinMethod : String {
    case RegisterUser = "/register_user/"
    case RegisterDevice = "/register_user_device/"
    case StartSession = "/start_session/"
    case RegisterOldSession = "/register_old_session/"
    case EndSession = "/end_session/"
    case PurchaseItem = "/purchase/"
    case RegisterEvent = "/register_event/"
    case GetItems = "/items/"
    case GetEvents = "/custom_events/"
}

public enum HttpMethod : String {
    case POST = "POST"
    case GET = "GET"
}

public class DataspinManager {
    
    //! Logtag for easier debugging
    private var LogTag : String = "[Dataspin]";
    
    //! Singleton
    public static let Instance = DataspinManager()
    
    //! Configuration
    var config: Config?
    
    //! User and Session variables
    var userUUID : String?
    
    init() {
        config = Config()
    }
    
    //! Configuration settings
    struct Config {
        //! Default Domain
        internal var DomainName = "hyperbees"
        //! Datapin iOS Test App secret key
        internal var ApiKey = "22d8f5c1fb0377599084f104682b4a24e47cfc39"
        //! Determines whether we should log information about what's going on. Should be disabled in production builds
        internal var DebugMode = true
        
        private let ApiVersion : String? = "v1"
        
        func GetURL(method: DataspinMethod) -> String {
            let url : String = "http://"+DomainName+".dataspin.io/api/"+ApiVersion!+method.rawValue
            return url
        }
    }
    
    //! TODO: Extend to log into file and send as dump information
    public func Log(message: String) {
        if(config!.DebugMode) { println("\(LogTag): \(message)") }
    }
    
    //! Use for Dataspin initialization at the game start
    public func Start(domainName: String, apiKey: String, debugMode:Bool) {
        config = Config(DomainName: domainName, ApiKey: apiKey, DebugMode: debugMode)
        
        Log("DataspinSDK started with \(self.config!.DomainName) domain and key \(self.config!.ApiKey), Debug: \(debugMode)")
    }
    
    //! Used for registering an user, all parameters are optional, use Bool forceUpdate if you would like to update user data in dataspin.io database
    public func RegisterUser(userName: String?=nil, surname: String?=nil, email: String?=nil, facebookId: String?=nil, gamecenterId: String?=nil, forceUpdate: Bool?=false, callback: ()->Void) {
        
        // Check if user was already registered, if so, don't send request, fire onUserRegistered callback
        if let dataspinDefaults = NSUserDefaults.standardUserDefaults().objectForKey("dataspin_uuid") as? [NSString] {
            
            //! TODO: Handle it in a nice way
            Log("User already registered! If you would like to update user data user forceUpdate: Bool parameter.")
            callback()
        }
        else {
            
            let parameters = [
                "name": userName!,
                "surname": surname!,
                "email": email!,
                "facebook_id": facebookId!,
                "gamecenter_id": gamecenterId!
            ]
            
            Log("Registering user")
            
            //Consider storing request in variable
            DataspinWebRequest(httpMethod: HttpMethod.POST, dsMethod: DataspinMethod.RegisterUser, parameters: parameters)
        }
    }
    
    //! Used for registering a device, must be called after RegisrerUser and before StartSession
    public func RegisterDevice(applePushNotificationsToken: String?=nil, advertisingId: String?=nil) {
        if let dataspinDefaults = NSUserDefaults.standardUserDefaults().objectForKey("dataspin_device_uuid") as? [NSString] {
            println("Device already registered!")
        }
        else {
            let parameters = [
            "end_user": userUUID!]
        }
    }
    
    private func onRequestExecuted(properties: Properties) {
        if(properties.error != nil) {
            
        }
        else {
            
        }
    }
}
