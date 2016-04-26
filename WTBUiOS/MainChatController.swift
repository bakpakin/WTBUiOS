//
//  MainChatController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class MainChatController : AllViewController {
    
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var chatContainer: UIView!
    
    weak var loginController: DJLoginController!
    weak var chatController: DJChatController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        if controller is DJLoginController {
            loginController = controller as! DJLoginController
        } else {
            chatController = controller as! DJChatController
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    func loginIn(name: String, token: String) {
        UIView.animateWithDuration(0.5, animations: {
            self.loginContainer.alpha = 0
            self.chatContainer.alpha = 1
        })
        loginContainer.userInteractionEnabled = false
        chatContainer.userInteractionEnabled = true
        chatController.beginChat(token, name: name)
    }
    
    func logOut() {
        UIView.animateWithDuration(0.5, animations: {
            self.loginContainer.alpha = 0
            self.chatContainer.alpha = 1
        })
        loginContainer.userInteractionEnabled = true
        chatContainer.userInteractionEnabled = false
        chatController.endChat()
    }
    
}
