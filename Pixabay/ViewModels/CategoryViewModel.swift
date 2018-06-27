//
//  CategoryViewModel.swift
//  Pixabay
//
//  Created by Nour on 03/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import CoreGraphics

struct CategoryViewModel: ViewModel {
    let size = PhotosCategory.list.count
    var cellSize = CGSize(width: 100, height: 100)
    
    var collectionSize: CGSize? = nil {
        didSet {
            if let size = collectionSize, size.width > 0 {
                let width = (size.width / 3) - 2
                cellSize = CGSize(width: width, height: width)
            }
        }
    }
    
    var labels: [String] = {
        return PhotosCategory.list.map{ $0.rawValue.capitalized }.sorted()
    }()
    
    var images: [String] = {
        return PhotosCategory.list.map{ $0.rawValue }.sorted()
    }()
    
    func selectedCategory(for indexPath:IndexPath) -> PhotosCategory? {
        if labels.count > indexPath.item {
            let category =  PhotosCategory.list.filter {$0.rawValue.capitalized == labels[indexPath.item]}
            return category.first
        }
        
        return nil
    }

}
