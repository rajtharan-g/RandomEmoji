//
//  GameHelper.swift
//  WordGame
//
//  Created by Rajtharan G on 25/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class GameHelper: NSObject {
    
    class func randomizeAvailableLetters(tileCount: Int) -> Array<String> {
        let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var availableTiles = [String]()
        for _ in 0..<tileCount {
            let rand = Int(arc4random_uniform(26))
            availableTiles.append(alphabet[rand])
        }
        return availableTiles
    }
    
    class func randomEmoji() -> String {
        let range = 0x1F300...0x1F3F0
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }


}
