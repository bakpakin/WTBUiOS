//
//  MessageBubble.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class MessageBubble : UIView {
    
    var bubbleCornerRadius: CGFloat
    var tailOnLeft: Bool = false
    var text: String
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented.")
    }
    
    init (text: String) {
        self.text = text
        bubbleCornerRadius = 10
        super.init(frame: CGRectMake(0, 0, 100, 100))
    }
    
}
