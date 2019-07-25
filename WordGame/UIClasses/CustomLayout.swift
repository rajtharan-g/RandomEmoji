//
//  InvertedStackLayout.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

// Custom layout to implement data source from bottom right
class CustomLayout: UICollectionViewLayout {
    
    var cellSize: CGFloat = 0.0
    let numOfTiles: Int = 5
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()
        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                let numberOfSectionItems = collectionView.numberOfItems(inSection: section)
                for item in 0 ..< numberOfSectionItems {
                    let indexPath = IndexPath(item: item, section: section)
                    if let layoutAttr = layoutAttributesForItem(at: indexPath) {
                        layoutAttrs.append(layoutAttr)
                    }
                }
            }
        }
        return layoutAttrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // Updating frame from the bottom right for each indexPath
        if let collectionViewBounds = self.collectionView?.bounds {
            let x = collectionViewBounds.width - (cellSize * (CGFloat(indexPath.item % numOfTiles) + 1.0))
            let y = collectionViewBounds.height - (cellSize * (CGFloat(indexPath.item / numOfTiles) + 1.0))
            layoutAttr.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
        }
        return layoutAttr
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            if let collectionViewBounds = self.collectionView?.bounds {
                if UIDevice.current.orientation.isLandscape { // Handling device orientation
                    cellSize = collectionViewBounds.height / CGFloat(numOfTiles)
                } else {
                    cellSize = collectionViewBounds.width / CGFloat(numOfTiles)
                }
                return collectionViewBounds.size
            }
            return CGSize.zero
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds, oldBounds.width != newBounds.width || oldBounds.height != newBounds.height {
            return true // Update layout only when the frame changes
        }
        return false
    }

}
