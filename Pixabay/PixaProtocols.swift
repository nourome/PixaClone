//
//  PixaProtocols.swift
//  Pixabay
//
//  Created by Nour on 10/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation

infix operator ->>
func ->><CGize,PhotoModel>(lhs:CGize, rhs:[PhotoModel]) {
    
}



/*
protocol PixaCollectionModelProtocol{
    var data:Any? {get set}
    var parameters: [PixaBayAPI.Keys:String] {get set}
}

extension PixaCollectionModelProtocol {
    var parameters: [PixaBayAPI.Keys : String] {
        get {
            return [
                .q: "",
                .category:"",
                .editors_choice:"false",
                .page:""
            ]
        }
        set(newParameters) {
        }
    }
}
*/
