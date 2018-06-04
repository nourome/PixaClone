//
//  PixaBayAPI.swift
//  Pixabay
//
//  Created by Nour on 29/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RxSwift

struct PixaBayAPI {
    static private let api = "https://pixabay.com/api/"
    static private let key = "9186145-a30a2be1c35b6d8267cab481e"
    public enum Keys: String {
        case key = "key"
        case q = "q"
        case category = "category"
        case editors_choice = "editors_choice"
        case safesearch = "safesearch"
        case order = "order"
        case page = "page"
    }
    
   
    
    static func buildRequestURL(with parameters: [Keys:String], latest: Bool = false) -> URL? {
        
        guard let requestUrl = URL(string: api), var requestComponents = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true) else {
            return nil
        }
        

        requestComponents.queryItems =  parameters.map { param -> URLQueryItem in
                return URLQueryItem(name: param.key.rawValue, value: param.value)
        }

        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.key.rawValue, value: key))
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.safesearch.rawValue, value: "true"))
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.order.rawValue, value: (latest) ?  "latest" : "popular"))
       
        guard let finalRequestUrl = requestComponents.url else {
            return nil
        }
        
        return finalRequestUrl
      
    }
    
    
  
}
