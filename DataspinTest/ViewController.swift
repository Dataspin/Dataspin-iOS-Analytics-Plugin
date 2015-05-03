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
    
    @IBAction func onDataspinStarted(sender: AnyObject) {
        DataspinManager.Instance.Start(domainLabel.text, apiKey: apiKeyLabel.text, debugMode: debugSwitch.on)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //var dataspin : DataspinManager = DataspinManager(domainName: "hyperbees", apiKey: "keykey")
        //dataspin.RegisterUser()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

