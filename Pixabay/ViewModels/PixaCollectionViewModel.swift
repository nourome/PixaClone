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

enum CollectionType{
    case Editor
    case Categoru
    case Search
}

protocol PixaCollectionModel{
    var data:Any? {get set}
    func loadPhotos(pageNumber:Int, latest: Bool)
}


struct EditorCollectionModel: PixaCollectionModel {
    var data: Any?
    func loadPhotos(pageNumber:Int, latest: Bool) {
        let parameters: [PixaBayAPI.Keys:String] = [
            .q: "",
            .category:"",
            .editors_choice:"true",
            .page:String(pageNumber)
        ]
        
        // let request = PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
        //URLSession.shared.rx.response(request: request)
        
    }
    
}

struct SearchCollectionModel: PixaCollectionModel {
    var data: Any?
    
    func loadPhotos(pageNumber:Int, latest: Bool) {
        if let keyword = data as? String {
            let parameters: [PixaBayAPI.Keys:String] = [
                .q: keyword,
                .category:"",
                .editors_choice:"false",
                .page:String(pageNumber)
            ]
        }
        
        // let request = PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
        //URLSession.shared.rx.response(request: request)
        
    }
    
}

struct CategoryCollectionModel: PixaCollectionModel {
    var data: Any?
    
    func loadPhotos(pageNumber:Int, latest: Bool) {
        if let category = data as? PhotosCategory {
            let parameters: [PixaBayAPI.Keys:String] = [
                .q: "",
                .category:category.rawValue,
                .editors_choice:"false",
                .page:String(pageNumber)
            ]
        }
        
        // let request = PixaBayAPI.buildRequestURL(with: parameters, latest: latest)
        
        //URLSession.shared.rx.response(request: request)
        
    }
    
}

struct PixaCollectionViewModel {
    var model: PixaCollectionModel!
    var pageNumber:Int = 0
    var collectionViewWidth: CGFloat = 375.0
    var previewWidth: CGFloat = 150.0
    var previewHeight: CGFloat = 84.0
    var imageSize = CGSize(width: 150.0, height: 84.0)
    var cellSize = BehaviorRelay<[CGSize]>(value: [])
    
    init(collectionViewWidth: CGFloat, type: CollectionType, data: Any?) {
        
        self.collectionViewWidth = collectionViewWidth
        
        switch type {
        case .Editor:
            model = EditorCollectionModel(data: data)
        default:
           break
        }
        
        let fullSize = CGSize(width: collectionViewWidth - 2.0, height: 84.0)
        let tempSizes:[CGSize] = Array(repeating: fullSize, count: 10)
            //AVMakeRect(aspectRatio: imageSize, insideRect: <#T##CGRect#>)
        cellSize.accept(tempSizes)
    }
    
   
    func loadPhotos(latest: Bool = false) {
        model.loadPhotos(pageNumber: pageNumber, latest: latest)
    }
    
   
}
