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
           let placeHolder = UIImage(named: "transparent")
           imageView.kf.indicatorType = .none
            if self.imageUrl != nil {
            imageView.kf.setImage(with: self.imageUrl!, placeholder: placeHolder, options: [.transition(.fade(0.3)), .backgroundDecode], progressBlock: nil) { (img, error, type, url) in
                self.imageView.isHidden = false
            }
            }
    
        }
    }
 
}
