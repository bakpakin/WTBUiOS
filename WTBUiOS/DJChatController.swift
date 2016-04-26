//
//  DJChatController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import SwiftyJSON
import Alamofire

class DJChatController : AllViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageView: UITableView!
    
    var token: String?
    var name: String = ""
    var timer: NSTimer = NSTimer()
    
    var messages = [Message]()
    
    func beginChat(token: String, name: String) {
        self.token = token
        self.name = name
        timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(DJChatController.getMessages), userInfo: nil, repeats: true)
        getMessages()
    }
    
    func endChat() {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add padding
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, inputText.frame.height))
        inputText.leftView = paddingView
        inputText.leftViewMode = UITextFieldViewMode.Always
        
        // Register notifications for observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DJChatController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DJChatController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        getMessages()
        timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(DJChatController.getMessages), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getMessages()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        bottomConstraint.constant = keyboardSize.height - self.tabBarController!.tabBar.frame.height - 1
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func sendMessage(message: String) {
        let parameters = [
            "token": self.token!,
            "message": message
        ]
        Alamofire.request(.GET, "https://gaiwtbubackend.herokuapp.com/sendChatMessage", parameters: parameters).responseJSON {
            response in
            if let jsonNative = response.result.value {
                let json = JSON(jsonNative)
                if let status = json["status"].string {
                    if status == "success" {
                        log.debug("Successful message send")
                    } else {
                        log.debug("Successful message send")
                    }
                }
                self.getMessages()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            if text.characters.count > 0 {
                if (self.token != nil) {
                    sendMessage(text)
                }
                log.debug("Failed message send")
                (self.parentViewController as! MainChatController!).logOut()
            }
            textField.text = ""
        }
        return true
    }
    
    func getMessages() {
        Alamofire.request(.GET, "https://gaiwtbubackend.herokuapp.com/getMessages").responseJSON {
            response in
            if let jsonNative = response.result.value {
                let json = JSON(jsonNative)
                if let messages = json.array {
                    self.messages.removeAll(keepCapacity: true)
                    for messageJson in messages {
                        if let sender = messageJson["sender"].string {
                            if let body = messageJson["message"].string {
                                if let timestamp = messageJson["timestamp"].int64 {
                                    self.messages.append(Message(sender: sender, text: body, timestamp: timestamp))
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.messageView.reloadData()
                    })
                }
            } else {
                log.debug("Response not received.")
            }
        }
    }
    
    // Table View Delegate and Datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "chatcell"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: id)
        }
        let message = messages[indexPath.row]
        cell.textLabel!.text = message.sender
        cell.detailTextLabel!.text = message.text
        cell.selectionStyle = .None
        return cell!
        
    }
    
}