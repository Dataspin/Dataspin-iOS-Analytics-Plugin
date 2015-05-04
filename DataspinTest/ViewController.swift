//
//  ViewController.swift
//  DataspinTest
//
//  Created by Rafal on 03.05.2015.
//  Copyright (c) 2015 Rafal. All rights reserved.
//

import UIKit
import AnalyticsSwiftSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var domainLabel: UITextField!
    @IBOutlet weak var debugSwitch: UISwitch!
    @IBOutlet weak var apiKeyLabel: UITextField!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var facebookIdLabel: UITextField!
    @IBOutlet weak var gamecenterIdLabel: UITextField!
    @IBOutlet weak var apnTokenLabel: UITextField!
    @IBOutlet weak var advertisingIdLabel: UITextField!
    
    @IBOutlet weak var registerUserLoading: UIActivityIndicatorView!
    @IBOutlet weak var registerDeviceLoading: UIActivityIndicatorView!
    
    
    @IBAction func onDataspinStarted(sender: AnyObject) {
        DataspinManager.Instance.Start(domainLabel.text, apiKey: apiKeyLabel.text, debugMode: debugSwitch.on)
    }
    
    @IBAction func registerUser(sender: AnyObject) {
        DataspinManager.Instance.RegisterUser(userName: nameLabel.text!, surname: surnameLabel.text!, email: emailLabel.text!, facebookId: facebookIdLabel.text!, gamecenterId: gamecenterIdLabel.text!, forceUpdate: false, callback: {
            self.onUserRegistered()
        })
        registerUserLoading.startAnimating()
    }
    
    @IBAction func registerDevice(sender: AnyObject) {
        DataspinManager.Instance.RegisterDevice(applePushNotificationsToken: apnTokenLabel.text!, advertisingId: advertisingIdLabel.text!)
    }
    
    func onUserRegistered() {
        println("User registered!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

