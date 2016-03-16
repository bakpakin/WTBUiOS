//
//  Message.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 3/15/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

class Message {
    
    var by = ""
    var text = ""
    
    init(BY : String, TEXT : String)
    {
       self.by = BY
        self.text = TEXT
    
    }
    
    func getBy() -> String
    {
        return by
    }
    
    func getText() -> String
    {
        return text
    }
    
    
}