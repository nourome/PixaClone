//
//  extensions.swift
//  Pixabay
//
//  Created by Nour on 06/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RxSwift


extension Reactive where Base: URLSession {
    
    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        
        return Observable.create { observer in
            
            return Disposables.create()
        }
    
    }
}
