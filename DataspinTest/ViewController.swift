//
//  ViewController.swift
//  DataspinTest
//
//  Created by Rafal on 03.05.2015.
//  Copyright (c) 2015 dataspin.io All rights reserved.
//

import UIKit
import AnalyticsSwiftSDK

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var domainLabel: UITextField!
    @IBOutlet weak var apiKeyLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var facebookIdLabel: UITextField!
    @IBOutlet weak var gamecenterIdLabel: UITextField!
    @IBOutlet weak var apnTokenLabel: UITextField!
    @IBOutlet weak var advertisingIdLabel: UITextField!
    @IBOutlet weak var appVersionLabel: UITextField!
    
    @IBOutlet weak var endDeviceUUIDLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    @IBOutlet weak var debugSwitch: UISwitch!
    @IBOutlet weak var forceUpdateSwitch: UISwitch!
    
    
    @IBOutlet weak var registerUserLoading: UIActivityIndicatorView!
    @IBOutlet weak var registerDeviceLoading: UIActivityIndicatorView!
    @IBOutlet weak var sessionStartLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var startSessionBlur: UIVisualEffectView!
    @IBOutlet weak var registerDeviceBlur: UIVisualEffectView!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    let swiftBlogs = ["dywan z jelonkiem"]
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Index path \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = swiftBlogs[indexPath.row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(swiftBlogs[row])
    }
    // -- END TABLE --
    
    
    @IBAction func onDataspinStarted(sender: AnyObject) {
        DataspinManager.Instance.Start(domainLabel.text, apiKey: apiKeyLabel.text, debugMode: debugSwitch.on, appVersion: appVersionLabel.text)
    }
    
    @IBAction func registerUser(sender: AnyObject) {
        registerUserLoading.startAnimating()
        DataspinManager.Instance.RegisterUser(userName: nameLabel.text!, surname: surnameLabel.text!, email: emailLabel.text!, facebookId: facebookIdLabel.text!, gamecenterId: gamecenterIdLabel.text!, forceUpdate: forceUpdateSwitch.on) { (error) in
            if(error == nil) {
                // User registered succesfully. Your code goes here.
                self.registerUserLoading.stopAnimating()
                self.registerDeviceBlur.hidden = true
                self.uuidLabel.text = "UUID: \(DataspinManager.Instance.userUUID!)"
            }
            else {
                // Error while registering user
                
            }
        }
    }
    
    @IBAction func registerDevice(sender: AnyObject) {
        DataspinManager.Instance.RegisterDevice(applePushNotificationsToken: apnTokenLabel.text!, advertisingId: advertisingIdLabel.text!) { (error) in
            if(error == nil) {
                self.endDeviceUUIDLabel.text = "End_device: \(DataspinManager.Instance.deviceUUID!)"
            }
            else {
                
            }
        }
    }
    
    @IBAction func startSession(sender: AnyObject) {
        DataspinManager.Instance.StartSession() { (error) in
            if(error == nil) {
                
            }
            else {
                
            }
        }
    }
    
    @IBAction func endSession(sender: AnyObject) {
        
    }
    
    @IBAction func getItems(sender: AnyObject) {
        
    }

    @IBAction func purchaseItem(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(itemsTableView != nil) {
            itemsTableView.delegate = self
            itemsTableView.dataSource = self
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
