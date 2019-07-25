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
    
    var totalHeight: CGFloat = 0.0
    var cellSize: CGFloat = 0.0
    let numOfTiles: Int = 5
    
    override func prepare() {
        super.prepare()
        // calculations required to determine the collection view’s size
        if let collectionView = self.collectionView {
            if UIDevice.current.orientation.isLandscape { // Handling device orientation
                cellSize = collectionView.bounds.height / CGFloat(numOfTiles)
            } else {
                cellSize = collectionView.bounds.width / CGFloat(numOfTiles)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()
        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                let numberOfSectionItems = collectionView.numberOfItems(inSection: section)
                for item in 0 ..< numberOfSectionItems {
                    let indexPath = IndexPath(item: item, section: section)
                    // Get the updated attribute and look for items in the rect
                    if let layoutAttr = layoutAttributesForItem(at: indexPath), layoutAttr.frame.intersects(rect) {
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
        get { // Need to return the total content size of the collection view
            if let collectionView = self.collectionView {
                return CGSize(width: collectionView.bounds.width, height:max(totalHeight, collectionView.bounds.height))
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
    
    func updateCollectionViewInsets(collectionView: UICollectionView) {
        for section in 0 ..< collectionView.numberOfSections {
            let numOfItems = collectionView.numberOfItems(inSection: section)
            
            // Getting the total height of the content
            totalHeight = ceil(CGFloat(numOfItems) / CGFloat(numOfTiles)) * cellSize
            
            // We manipulate content inset and offset based on the number of items in the collection view
            let differenceInHeight = totalHeight - collectionView.bounds.height
            if differenceInHeight > 0 {
                collectionView.contentInset = UIEdgeInsets(top: differenceInHeight, left: 0, bottom: -differenceInHeight, right: 0)
                collectionView.setContentOffset(CGPoint(x: 0, y: -differenceInHeight), animated: true)
            } else { // Reset the content inset and offset if number of items is visible in screen
                collectionView.contentInset = UIEdgeInsets.zero
                collectionView.setContentOffset(CGPoint.zero, animated: false)
            }
        }
    }

}
