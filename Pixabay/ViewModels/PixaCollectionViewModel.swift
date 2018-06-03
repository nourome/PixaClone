//
//  PixaCollectionViewModel.swift
//  Pixabay
//
//  Created by Nour on 28/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import AVFoundation



struct PixaCollectionViewModel {
    
    var width: CGFloat = 375.0
    var previewWidth: CGFloat = 150.0
    var previewHeight: CGFloat = 84.0
    var imageSize = CGSize(width: 150.0, height: 84.0)
   
    var cellSize = BehaviorRelay<[CGSize]>(value: [])
    
    init() {
        let fullSize = CGSize(width: width, height: 84.0)
        let halfSize = CGSize(width: (width/2.0) - 2.0, height: 84)
        var tempSizes:[CGSize] = Array(repeating: CGSize(width: 1.0, height: 1.0), count: 10)
        var counter = 0
        for item in 0..<10 {
            if item % 2 == 0 {
                if counter < 10 {
                    tempSizes[counter] = fullSize
                     counter += 1
                }
               
            }else {
                if counter < 10 {
                    tempSizes[counter] = halfSize
                    counter += 1
                }
                if counter < 10 {
                    tempSizes[counter] = halfSize
                    counter += 1
                }
            }
            
           
            //AVMakeRect(aspectRatio: imageSize, insideRect: <#T##CGRect#>)
            
        }
        cellSize.accept(tempSizes)
    }
    
    
    
    func loadEditorPhotos(pageNumber: Int, latest: Bool = false) {
        
        var parameters: [PixaBayAPI.Keys:String] = [
            .q: "",
            .category:"",
            .editors_choice:"true",
            .page:String(pageNumber)
        ]
        
        
        let request = PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
        //URLSession.shared.rx.response(request: request)
        
    }
    
    func loadCategoryPhotos(category: PhotosCategory, pageNumber: Int, latest: Bool = false) {
        
        var parameters: [PixaBayAPI.Keys:String] = [
            .q: "",
            .category:category.rawValue,
            .editors_choice:"false",
            .page:String(pageNumber)
        ]
        
        //PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
    }
    
    func searchPhotos(keyword: String, pageNumber: Int, latest: Bool = false) {
        
        var parameters: [PixaBayAPI.Keys:String] = [
            .q: keyword,
            .category:"",
            .editors_choice:"false",
            .page:String(pageNumber)
        ]
        
        //PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
    }
    
    
   
}
