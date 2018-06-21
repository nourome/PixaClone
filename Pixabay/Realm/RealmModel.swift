//
//  RealmModel.swift
//  Pixabay
//
//  Created by Nour on 17/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmError:Error {
    case NewRecordFailed
    case UpdateRecordFailed
    case RealmInstanceIsNil
}
class ApiResponse: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var response: Data?
    @objc dynamic var date: Date = Date()
    @objc dynamic var isValid: Bool = false
    
    override static func primaryKey() -> String? {
        return "url"
    }
}


