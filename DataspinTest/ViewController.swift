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
    @IBOutlet weak var eventIdLabel: UITextField!
    @IBOutlet weak var eventExtraData: UITextField!
    
    @IBOutlet weak var currentItemLabel: UILabel!
    @IBOutlet weak var endDeviceUUIDLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var sessionId: UILabel!
    
    @IBOutlet weak var debugSwitch: UISwitch!
    @IBOutlet weak var forceUpdateSwitch: UISwitch!
    
    @IBOutlet weak var purchaseItemLoading: UIActivityIndicatorView!
    @IBOutlet weak var getItemsLoading: UIActivityIndicatorView!
    @IBOutlet weak var registerUserLoading: UIActivityIndicatorView!
    @IBOutlet weak var registerDeviceLoading: UIActivityIndicatorView!
    @IBOutlet weak var sessionStartLoading: UIActivityIndicatorView!
    @IBOutlet weak var eventRegisterLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var startSessionBlur: UIVisualEffectView!
    @IBOutlet weak var registerDeviceBlur: UIVisualEffectView!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    let items = ["dywan z jelonkiem"]
    var currentlySelectedItem = "tab"
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Index path \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(items[row])
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
                self.registerDeviceBlur.hidden = true
                self.uuidLabel.text = "UUID: \(DataspinManager.Instance.userUUID!)"
            }
            else {
                // Error while registering user
                
            }
            self.registerUserLoading.stopAnimating()
        }
    }
    
    @IBAction func registerDevice(sender: AnyObject) {
        registerDeviceLoading.startAnimating()
        DataspinManager.Instance.RegisterDevice(applePushNotificationsToken: apnTokenLabel.text!, advertisingId: advertisingIdLabel.text!) { (error) in
            if(error == nil) {
                self.endDeviceUUIDLabel.text = "End_device: \(DataspinManager.Instance.deviceUUID!)"
            }
            else {
                
            }
            self.registerDeviceLoading.stopAnimating()
        }
    }
    
    @IBAction func startSession(sender: AnyObject) {
        sessionStartLoading.startAnimating()
        DataspinManager.Instance.StartSession() { (error) in
            if(error == nil) {
                self.sessionId.text = "Session ID: \(DataspinManager.Instance.sessionId!)"
            }
            else {
                
            }
            
            self.sessionStartLoading.stopAnimating()
        }
    }
    
    @IBAction func endSession(sender: AnyObject) {
        sessionStartLoading.startAnimating()
        DataspinManager.Instance.EndSession() { (error) in
            if(error == nil) {
                self.sessionId.text = "Session ID: \(DataspinManager.Instance.sessionId!)"
            }
            else {
                
            }
            
            self.sessionStartLoading.stopAnimating()
        }
    }
    
    @IBAction func getItems(sender: AnyObject) {
        getItemsLoading.startAnimating()
        DataspinManager.Instance.GetItems() { (error) in
            if(error == nil) {
                println("Items received!")
            }
            else {
                
            }
            
            self.getItemsLoading.stopAnimating()
        }
    }

    @IBAction func purchaseItem(sender: AnyObject) {
        purchaseItemLoading.startAnimating()
        DataspinManager.Instance.PurchaseItem(currentlySelectedItem) { (error) in
            if(error == nil) {
                println("Item purchased!")
            }
            else {
                
            }
            
            self.purchaseItemLoading.stopAnimating()
        }
    }
    
    @IBAction func registerEvent(sender: AnyObject) {
        eventRegisterLoading.startAnimating()
        DataspinManager.Instance.RegisterEvent(eventIdLabel.text!, extraData: eventExtraData.text!) { (error) in
            if(error == nil) {
                println("Event registered!")
            }
            else {
                
            }
            
            self.eventRegisterLoading.stopAnimating()
        }
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
