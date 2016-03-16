//
//  DJChatController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Parse 

class DJChatController : AllViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    var MessageInfo = [Message]()
    var oldConst:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        oldConst = constraint.constant
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
       
    }
    
    override func viewDidAppear(animated: Bool) {
        getMessages()
    }
    func getMessages()
    {
        MessageInfo.removeAll(keepCapacity: true)
        let query = PFQuery(className: "Messages")
        query.whereKey("Users", equalTo: "TempUser")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil)
            {
                if let objects = objects
                {
                   for object in objects
                   {
                     self.MessageInfo.append(Message(BY: object.objectForKey("Sender") as! String, TEXT: object.objectForKey("Text") as! String))
                   }
                }
                self.tableView.setContentOffset(CGPointMake(0, 100000000), animated: false)
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageInfo.count
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:
            indexPath) as! MessageCell
    
        myCell.selectionStyle = .None
    
        if(MessageInfo[indexPath.row].getBy() == "TempUser")
        {
                myCell.djText.alpha = 0.0
                myCell.myText.alpha = 1.0
                myCell.myText.text = MessageInfo[indexPath.row].getText()
        }
        else
        {
            myCell.myText.alpha = 0.0
            myCell.djText.alpha = 1.0
            myCell.djText.text = MessageInfo[indexPath.row].getText()

        }
    
        return myCell
    }
    
    
    
    @IBAction func sendClicked(sender: AnyObject) {
        if(inputText.text?.characters.count == 0)
        {
            return
        }
        constraint.constant = oldConst
        inputText.resignFirstResponder()
        let newMessage = PFObject(className: "Messages")
        newMessage["Sender"] = "TempUser"
        newMessage["Receiver "] = "DJ"
        newMessage["Users"] = ["DJ","TempUser"]
        newMessage["Text"]  = inputText.text
        newMessage.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success)
            {   self.inputText.text = ""
                self.getMessages()
            }
        }
        
    }
    
    func keyboardWillShow(notification:NSNotification)
    {
        constraint.constant =  (self.view.center.y) * 0.65
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
         constraint.constant = oldConst
    }

    
}