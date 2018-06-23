//
//  PageViewModel.swift
//  Pixabay
//
//  Created by Nour on 31/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation

public enum Pages: String {
    case Photos = "photos"
    case Search = "search"
    case Category = "category"
    
    static let all = [Photos, Search, Category]
    
    static func rawValueFrom(hashValue: Int) ->  String? {
        if hashValue < 0 || hashValue >= all.count { return nil }
        for page in Pages.all {
            if page.hashValue == hashValue {
                print(page.rawValue)
                return page.rawValue
            }
        }
        return nil
    }
}

struct PageCoordinator, UIPageViewControllerDelegate,  UIPageViewControllerDataSource {
    
    func indexOfViewControllerWith(_ identifier: String?) -> Int {
        
        if identifier == nil { return NSNotFound }
        
        for page in Pages.all {
            if page.rawValue == identifier {
                return page.hashValue
            }
        }
        
        return NSNotFound
    }
    
    func viewControllerNextTo(identifier: String?, nextId:(Int, Int)-> Int) -> String?  {
        
        let indexOfVisibleViewController = self.indexOfViewControllerWith(identifier)
        
        if  indexOfVisibleViewController < 0  || indexOfVisibleViewController == NSNotFound
        { return nil }
        
        return Pages.rawValueFrom(hashValue: nextId(indexOfVisibleViewController, 1))
    }
    
    
}
