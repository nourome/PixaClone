//
//  PixaViewCell.swift
//  Pixabay
//
//  Created by Nour on 28/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit
import Kingfisher

class PixaViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: URL? {
        didSet {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: self.imageUrl!, options: [.transition(.fade(0.3))])
        }
    }
 
}
