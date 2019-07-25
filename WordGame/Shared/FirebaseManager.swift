//
//  FirebaseManager.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseManagerDelegate: class {
    func reloadCollectionView(words: [Word]?)
}

class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    weak var delegate: FirebaseManagerDelegate? 
    let totalTileSize: UInt = 25
    
    func listenToFirebaseDB() {
        ref = Database.database().reference()
        refHandle = ref.queryLimited(toLast: totalTileSize).observe(DataEventType.value, with: { (snapshot) in
            self.handleResponse(snapshot: snapshot)
        })
    }
    
    func handleResponse(snapshot: DataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: Any] {
            let arrayOfWords = snapshotValue.values.map({$0}) as! [[String: Any]]
            var words: [Word] = []
            for word in arrayOfWords {
                let wordObject = Word(emoji: word["emoji"] as? String, timestamp: word["timestamp"] as? Double)
                words.append(wordObject)
            }
            self.delegate?.reloadCollectionView(words: words.sorted(by: {$0.timestamp ?? 0 < $1.timestamp ?? 0}))
        } else {
            self.delegate?.reloadCollectionView(words: nil)
        }
    }
    
    func updateEmojiToDB(emoji: String) {
        ref.childByAutoId().setValue(["emoji": emoji, "timestamp": ServerValue.timestamp()])
    }
    
    func deleteAllEmojis() {
        ref.removeValue()
    }

}
