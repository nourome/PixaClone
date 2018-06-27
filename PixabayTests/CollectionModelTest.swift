//
//  CollectionModelTest.swift
//  PixabayTests
//
//  Created by Nour on 26/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import XCTest
@testable import Pixabay

class CollectionModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEditorCollectionModel() {
        var model = EditorCollectionModel()
        model.data = nil
        XCTAssertEqual(model.parameters[.editors_choice], "true")
    }
    
    func testSearchModel() {
            var model = SearchCollectionModel()
            model.data = "car"
            XCTAssertEqual(model.parameters[.q], "car")

    }
    
    func testCategoryModel() {
        var model = CategoryCollectionModel()
        model.data = "animals"
        XCTAssertEqual(model.parameters[.category], "")
        model.data = PhotosCategory.Animals
         XCTAssertEqual(model.parameters[.category], "animals")
    }
 
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
