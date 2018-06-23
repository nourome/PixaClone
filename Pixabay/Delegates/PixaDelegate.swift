//
//  CategoryDelegate.swift
//  Pixabay
//
//  Created by Nour on 23/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation

protocol PixaDelegate {
    
}

protocol CategoryDelegate: PixaDelegate {
    func didSelect(_ category: PhotosCategory)
}