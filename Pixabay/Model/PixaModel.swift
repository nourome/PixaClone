//
//  PixaModel.swift
//  Pixabay
//
//  Created by Nour on 29/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//  Fore more info abour pixaby API visit https://pixabay.com/api/docs/
//

import Foundation
import CoreGraphics

enum PhotosCategory:(String) {
    case Fashion = "fashion"
    case Nature = "nature"
    case Backgrounds = "backgrounds"
    case Science = "science"
    case Education = "education"
    case People = "people"
    case Feelings = "feelings"
    case Religion = "religion"
    case Health = "health"
    case Places = "places"
    case Buildings = "buildings"
    case Animals = "animals"
    case Industry = "industry"
    case Food = "food"
    case Computer = "computer"
    case Sports = "sports"
    case Transportation = "transportation"
    case Travel = "travel"
    case Business = "business"
    case Music = "music"
    
    
    static let list: [PhotosCategory] = [Fashion, Nature, Backgrounds, Science, Education,  People, Feelings, Religion, Health, Places, Buildings, Animals, Industry, Food, Computer, Sports, Transportation, Travel, Business, Music]
    
}



enum ResponseStatus: Equatable {
    static func == (lhs: ResponseStatus, rhs: ResponseStatus) -> Bool {
        
        switch (lhs,rhs) {
        case (.Start, .Start):
            return true
        case (.Success, .Success):
            return true
        case (.Cached, .Cached):
            return true
        case (.Failed(_),.Failed(_)):
            return true
        default:
            return false
        }
    }
       
    case Start
    case Success
    case Cached
    case Failed(Error)
}

enum ReuseIdentifiers: String {
    case Cell = "cell"
    case Header = "HeaderCell"
}

struct PixaResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [PixaPhotoModel]?
}

struct PixaPhotoModel: Decodable {
    let id: Int
    let tags: String?
    let previewURL: URL?
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: URL?
    let webformatWidth: Int
    let webformatHeight: Int

}
