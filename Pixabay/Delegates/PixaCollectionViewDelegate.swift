//
//  PixaCollectionViewDelegate.swift
//  Pixabay
//
//  Created by Nour on 04/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



class PixaCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
   
    var viewModel: CollectionViewModel!
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.Cell.rawValue, for: indexPath) as? PixaViewCell
        if viewModel.photos[indexPath.item].previewURL != nil {
            cell?.imageUrl = viewModel.photos[indexPath.item].previewURL
        }
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifiers.Header.rawValue, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    
    /*func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PixaViewCell {
             if viewModel.photos[indexPath.item].previewURL != nil {
                    cell.imageUrl = viewModel.photos[indexPath.item].previewURL
           }
        }
    }*/
    
}


extension PixaCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 150)
        
    }
    
    
    
    
    
    
    
}



