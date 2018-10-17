//
//  ImageViewerModel.swift
//  Pixabay
//
//  Created by Nour on 03/07/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class ImageViewerModel: ViewModel {
    var contentRect: CGRect = CGRect.zero
    var photoLoaded = BehaviorRelay<Bool>(value: false)
    
    var photo: PixaPhotoModel? {
        didSet {
            photoLoaded.accept(true)
        }
    }
   
    
    var imagViewRect: CGRect{
        get  {
            guard let photo = photo else  { return CGRect.zero }
            let rect =  AVMakeRect(aspectRatio: CGSize(width: photo.webformatWidth, height: photo.webformatHeight), insideRect: contentRect)
            return rect
        }
    }

}
