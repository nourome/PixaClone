//
//  RealmService.swift
//  Pixabay
//
//  Created by Nour on 17/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    static var lifePeriod : TimeInterval = 24 * 60 * 60
    
    static func save(for request: URL, with response: Data) {
        
      
        if let realm = try? Realm() {
            
            guard let record = realm.object(ofType: ApiResponse.self, forPrimaryKey: request.absoluteString) else {
                
                let newRecord = ApiResponse()
                newRecord.url = request.absoluteString
                newRecord.response = response
                newRecord.isValid = true
                
                try? realm.write {
                    realm.add(newRecord)
                }
                return
            }
            
            if !record.isValid {
                try? realm.write {
                    record.response = response
                    record.date = Date()
                    record.isValid = true
                }
            }
            
        }
    }
    
    static func cache(for request: URL) -> Data? {
        
        do {
            let realm = try Realm()
            guard let record = realm.object(ofType: ApiResponse.self, forPrimaryKey: request.absoluteString) else {return nil}
            let period  = Date().timeIntervalSince(record.date)
            if period > lifePeriod {
                try realm.write {
                     record.isValid = false
                }
                return nil
            }
            
            return record.response
            
        }catch {
            return nil
        }
    }
    
    
    
}
