//
//  WordCollectionViewCell.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!

    // MARK: - Custom methods
    
    func updateCell(word: Word?) {
        if let emoji = word?.emoji {
            wordLabel.text = emoji
        } else {
            wordLabel.text = GameHelper.randomEmoji()
        }
    }
    
}
