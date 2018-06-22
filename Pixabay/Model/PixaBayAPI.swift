//
//  PixaBayAPI.swift
//  Pixabay
//
//  Created by Nour on 29/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RxSwift



enum PixaApiError: Error {
    case FailedToDecodePhoto(String)
    case HttpResponseError(String)
    case NilResults(String)
    case CachedResultsFailed(String)
    case WrongUrl(String)
}

struct PixaBayAPI {
    static private let api = "https://pixabay.com/api/"
    static private let key = "9186145-a30a2be1c35b6d8267cab481e"
    static let MaxFetchPerPage = 150
    public enum Keys: String {
        case key = "key"
        case q = "q"
        case category = "category"
        case editors_choice = "editors_choice"
        case safesearch = "safesearch"
        case order = "order"
        case page = "page"
        case per_page = "per_page"
    }
    
    
    
    static func buildRequestURL(with parameters: [Keys:String], latest: Bool = false) throws -> URL {
    
        guard let requestUrl = URL(string: api), var requestComponents = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true) else {
            throw PixaApiError.WrongUrl("Wrong URL parameters")
        }
        
        
        requestComponents.queryItems =  parameters.map { param -> URLQueryItem in
            return URLQueryItem(name: param.key.rawValue, value: param.value)
        }
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.key.rawValue, value: key))
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.safesearch.rawValue, value: "true"))
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.per_page.rawValue, value: String(MaxFetchPerPage)))
        
        requestComponents.queryItems?.append(URLQueryItem(name: PixaBayAPI.Keys.order.rawValue, value: (latest) ?  "latest" : "popular"))
        
        guard let finalRequestUrl = requestComponents.url else {
            throw PixaApiError.WrongUrl("Wrong URL parameters")
        }
        
        return finalRequestUrl
        
    }
    
    static func decode(response: Data) throws -> [PixaPhotoModel] {
        
        var photoHits = [PixaPhotoModel]()
        do {
            photoHits = try JSONDecoder().decode(PixaResponse.self, from: response).hits ?? []
        }catch {
            throw PixaApiError.FailedToDecodePhoto(error.localizedDescription)
        }
        return photoHits
    }
    
    @discardableResult
    static func isValid(response: (HTTPURLResponse,Data)) throws -> Bool {
        
        if response.1.count == 0 {
             throw PixaApiError.NilResults("No results from server")
        }
        
        if 200..<300 ~= response.0.statusCode {
            return true
        } else {
            throw PixaApiError.HttpResponseError(response.0.statusCode.description)
        }
    }

    
    
}
