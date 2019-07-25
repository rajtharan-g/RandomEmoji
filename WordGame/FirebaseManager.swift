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
    func reloadCollectionView(words: [String]?)
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
            var arrayOfWords = snapshotValue.values.map({$0}) as! [[String: Any]]
            arrayOfWords = arrayOfWords.sorted(by: {($0["timestamp"] as! Double) < ($1["timestamp"] as! Double)})
            let words = arrayOfWords.compactMap({$0["emoji"]}) as! [String]
            self.delegate?.reloadCollectionView(words: words)
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
