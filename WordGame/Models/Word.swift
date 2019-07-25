//
//  Word.swift
//  WordGame
//
//  Created by Rajtharan G on 25/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class Word: NSObject {
    
    var emoji: String?
    var timestamp: Double?
    
    init(emoji: String?, timestamp: Double?) {
        self.emoji = emoji
        self.timestamp = timestamp
    }

}
