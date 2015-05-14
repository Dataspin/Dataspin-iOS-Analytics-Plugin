# Dataspin for iOS

*Version 0.1*

The Dataspin iOS SDK is the cornerstone of the Dataspin Analytics. It
provides the functionality for tracking events, item purchases, sessions and much more. 


### Usage

Integrating Dataspin takes two easy steps:

 1. Add the *DataspinSDK.framework* into your Xcode project's Frameworks folder.

 2. Instantiate the Dataspin SDK in your application AppDelegate.m, like this:
    
```objective-c
 
     #import <DataspinSDK/DataspinSDK.h>
     
     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions       
     {
         // initialize the Dataspin library

         // TO BE ADDED
           
     }
```

If you're using Swift, it will look like this:
```swift
    import DataspinSDK
    
    override func viewDidLoad() {
        DataspinManager.Instance.Start(domainLabel.text, apiKey: apiKeyLabel.text, debugMode: debugSwitch.on, appVersion: appVersionLabel.text)
    }
```
It is shown as is for example purposes only.

### Dive deeper

For more common use cases, visit our [online documentation](https://github.com/Dataspin/Dataspin-iOS-Analytics-Plugin/wiki).

Check out our documentation for the full API
specification.

If you encounter any issues, do not hesitate to contact our happy support team
at [rafal@dataspin.io](mailto:rafal@dataspin.io).
