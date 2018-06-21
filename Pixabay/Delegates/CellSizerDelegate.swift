//
//  CellSizerDelegate.swift
//  Pixabay
//
//  Created by Nour on 20/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol CellSizerDelegate {
    func sizeForCell(with indexPath: IndexPath) -> CGSize
    func fullSize(for collectionView: UICollectionView, width: Int, height: Int) -> CGSize
    func halfSize(for collectionView: UICollectionView, width: Int, height: Int) -> CGSize
}


extension CellSizerDelegate {
    func fullSize(for collectionView: UICollectionView, width: Int, height: Int) -> CGSize {
        
        let cellWidth = collectionView.frame.width - (collectionView.contentInset.right + collectionView.contentInset.left)
        let fullRect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(cellWidth), height: CGFloat(MAXFLOAT))
        let aspectRect =  AVMakeRect(aspectRatio: CGSize(width: Int(width), height: Int(height)), insideRect: fullRect)
        return CGSize(width: aspectRect.width, height: aspectRect.height)
    }
    
    func halfSize(for collectionView: UICollectionView, width: Int, height: Int) -> CGSize {
        
        let cellWidth = (collectionView.frame.width - (collectionView.contentInset.right + collectionView.contentInset.left)) / 2
        let halfRect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        let aspectRect =  AVMakeRect(aspectRatio: CGSize(width: Int(width), height: Int(height)), insideRect: halfRect)
        print("aspectRect\(aspectRect)")
        return CGSize(width: aspectRect.width, height: aspectRect.height)
    }
}
