//
//  UICollectionViewEdgeLayout.swift
//  Pixabay
//
//  Created by Nour on 14/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import UIKit


class UICollectionViewEdgeLayout: UICollectionViewFlowLayout {
    
    var cache: [IndexPath:UICollectionViewLayoutAttributes] = [:]
    var cellSizerDelegate : CellSizerDelegate?
    let  defaultSize =  CGSize(width: 150, height: 150)
    var onLoad = true
    override init() {
        super.init()
        self.sectionHeadersPinToVisibleBounds = true
        self.minimumInteritemSpacing = 3.0
        self.minimumLineSpacing = 3.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        var first = true
        if let items = collectionView?.numberOfItems(inSection: 0) {
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: 0)
                if !cache.keys.contains(indexPath) {
                    let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    if item == 0 {
                        let headerHeight = 50.0 + minimumLineSpacing
                        let cellSize = cellSizerDelegate?.sizeForCell(with: indexPath) ?? defaultSize
                        attrs.frame = CGRect(x: 0, y: headerHeight, width: cellSize.width, height: cellSize.height)
                        first = !first
                    }else {
                        let previousIndexPath = IndexPath(item: indexPath.item-1, section: 0)
                        let previousAttrs = cache[previousIndexPath]!
                        if  !first {
                            let width = collectionView!.frame.width - previousAttrs.frame.width - self.minimumInteritemSpacing
                            let rightPv = previousAttrs.frame.origin.x + previousAttrs.size.width + self.minimumInteritemSpacing
                            attrs.frame.origin.x = rightPv
                            attrs.frame.origin.y = previousAttrs.frame.origin.y
                            attrs.frame.size = CGSize(width: width, height: previousAttrs.frame.height)
                            first = !first
                        } else {
                            attrs.frame.size =  cellSizerDelegate?.sizeForCell(with: indexPath) ?? defaultSize
                            attrs.frame.origin.y = previousAttrs.frame.height + previousAttrs.frame.origin.y + self.minimumLineSpacing
                            first = !first
                        }
                    }
                    cache[indexPath] = attrs
                }
            }
            
        }
        
    }
    
    func resetLayout() {
        onLoad = true
    }
    
    func invalidateCells(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if cache.keys.contains(indexPath) {
                cache.removeValue(forKey: indexPath)
            }
        }
        prepare()
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
          var layoutAttributes =  [UICollectionViewLayoutAttributes]()
        
        if onLoad {
            onLoad = false
            let attrs = super.layoutAttributesForElements(in: rect)!
            let supplementaryAttrs = attrs.filter {$0.representedElementCategory == .supplementaryView}
            if !supplementaryAttrs.isEmpty {
                  layoutAttributes.append(contentsOf: supplementaryAttrs)
            }
        }
      
        let cachedAttributes = cache.flatMap { attrs ->  [UICollectionViewLayoutAttributes] in
            return [attrs.value]
            }.filter{rect.intersects($0.frame)}
        layoutAttributes.append(contentsOf: cachedAttributes)
        return layoutAttributes
        
    }
    
}


