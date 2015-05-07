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
    private var ErrorLogTag : String = "[Dataspin Error]";
    
    //! Singleton
    public static let Instance = DataspinManager()
    
    //! Configuration
    var config: Config?
    
    //! User and Session variables
    public var userUUID : String?
    public var deviceUUID : String?
    public var userRegistered : Bool?
    public var deviceRegistered : Bool?
    public var sessionId : Int?
    
    init() {
        config = Config()
        userRegistered = false;
        deviceRegistered = false;
        sessionId = -1;
    }
    
    //! Configuration settings
    struct Config {
        //! Default Domain
        internal var DomainName = "hyperbees"
        //! Datapin iOS Test App secret key
        internal var ApiKey = "22d8f5c1fb0377599084f104682b4a24e47cfc39"
        //! App Version
        internal var AppVersion = "1.0"
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
    
    //! TODO: Extend to log into file and send as dump information
    public func LogError(message: String) {
        if(config!.DebugMode) { println("\(ErrorLogTag): \(message)") }
    }
    
    //! Use for Dataspin initialization at the game start
    public func Start(domainName: String, apiKey: String, debugMode:Bool, appVersion: String) {
        config = Config(DomainName: domainName, ApiKey: apiKey, AppVersion: appVersion, DebugMode: debugMode)
        
        Log("DataspinSDK started with \(self.config!.DomainName) domain and key \(self.config!.ApiKey), Debug: \(debugMode)")
    }
    
    //! Used for registering an user, all parameters are optional, use Bool forceUpdate if you would like to update user data in dataspin.io database
    public func RegisterUser(userName: String?=nil, surname: String?=nil, email: String?=nil, facebookId: String?=nil, gamecenterId: String?=nil, forceUpdate: Bool?=false, completion: ((error: NSError?) -> Void)) {
        
        // Check if user was already registered, if so, don't send request, fire onUserRegistered callback
        if let dataspinDefaults = NSUserDefaults.standardUserDefaults().objectForKey("dataspin_uuid") as? [NSString] {
            Log("User already registered! If you would like to update user data user forceUpdate: Bool parameter.")
            completion(error: nil)
        }
        else {
            let parameters = [
                "name": userName!,
                "surname": surname!,
                "email": email!,
                "facebook_id": facebookId!,
                "gamecenter_id": gamecenterId!
            ]
            
            Log("Registering user...")
            
            let r = DataspinWebRequest(httpMethod: HttpMethod.POST, dsMethod: DataspinMethod.RegisterUser, parameters: parameters).Fire() {(error, response) in
                if(error == nil) {
                    self.userUUID = response!["uuid"] as? String
                    self.userRegistered = true
                    self.Log("User succesfully registered, UUID: \(self.userUUID!)")
                }
                else {
                    self.Log("Failed to register user")
                }
                
                completion(error: error)
            }
        }
    }
    
    //! Used for registering a device, must be called after RegisrerUser and before StartSession
    public func RegisterDevice(applePushNotificationsToken: String?=nil, advertisingId: String?=nil,completion: ((error: NSError?) -> Void)) {
        if let dataspinDefaults = NSUserDefaults.standardUserDefaults().objectForKey("dataspin_device_uuid") as? [NSString] {
            Log("Device already registered!")
        }
        else {
            if(userRegistered!) {
                let parameters = [
                    "end_user": userUUID!,
                    "uuid": UIDevice.currentDevice().identifierForVendor.UUIDString.md5(),
                    "platform": 2,
                    "device": GetDevice()
                ]
                
                Log("Registering device...")
                
                let r = DataspinWebRequest(httpMethod: HttpMethod.POST, dsMethod: DataspinMethod.RegisterDevice, parameters: parameters as? [String : AnyObject]).Fire() {(error, response) in
                    if(error == nil) {
                        self.deviceUUID = response!["uuid"] as? String
                        self.deviceRegistered = true
                        self.Log("Device succesfully registered, UUID: \(self.deviceUUID!)")
                    }
                    else {
                        self.Log("Failed to register device")
                    }
                    
                    completion(error: error)
                }
            }
            else {
                Log("Before calling RegisterDevice call RegisterUser first!")
            }
        }
    }
    
    public func StartSession(completion: ((error: NSError?) -> Void)) {
        if(deviceRegistered!) {
            let parameters = [
                "end_user_device": self.deviceUUID!,
                "app_version": self.config!.AppVersion,
                "connectivity_type": 1
            ]
            
            Log("Registering device...")
            
            let r = DataspinWebRequest(httpMethod: HttpMethod.POST, dsMethod: DataspinMethod.StartSession, parameters: parameters as? [String : AnyObject]).Fire() {(error, response) in
                if(error == nil) {
                    self.sessionId = response!["id"] as? Int
                    self.Log("Session started!")
                }
                else {
                    self.Log("Failed to start session!")
                }
                
                completion(error: error)
            }
        }
    }
    
    private func GetDevice() -> [String: AnyObject] {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let device = [
            "manufacturer": "Apple",
            "model": UIDevice.currentDevice().model,
            "screen_width": screenSize.width,
            "screen_height": screenSize.height,
            "dpi":  401
        ]
        
        return device as! [String : AnyObject]
    }
}