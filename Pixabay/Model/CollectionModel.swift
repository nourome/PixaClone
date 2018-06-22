//
//  CollectionModel.swift
//  Pixabay
//
//  Created by Nour on 18/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation


enum CollectionType{
    case Editor
    case Categoru
    case Search
}

protocol PixaCollectionModelProtocol{
    var data:Any? {get set}
    var parameters: [PixaBayAPI.Keys:String] {get set}
}

struct EditorCollectionModel: PixaCollectionModelProtocol {
    var parameters: [PixaBayAPI.Keys : String] = [
        .q: "",
        .category:"",
        .editors_choice:"false",
        .page:""
    ]
    
    var data: Any? {
        get {
            return nil
        } set(newValue) {
            parameters[.editors_choice] = "true"
        }
    }
    
}

struct SearchCollectionModel: PixaCollectionModelProtocol {
    var parameters: [PixaBayAPI.Keys : String] = [
        .q: "",
        .category:"",
        .editors_choice:"false",
        .page:""
    ]
    
    var data: Any? {
        get {
            return nil
        }
        set(newData) {
            if let keyword = newData as? String {
                parameters[.q] = keyword
            }
        }
    }
    
}

struct CategoryCollectionModel: PixaCollectionModelProtocol {
    
    var parameters: [PixaBayAPI.Keys : String] = [
        .q: "",
        .category:"",
        .editors_choice:"false",
        .page:"1"
    ]
    
    var data: Any? {
        get {return nil}
        set(newData) {
            if let category = newData as? PhotosCategory {
                parameters[.category] = category.rawValue
            }
        }
    }
    
}
