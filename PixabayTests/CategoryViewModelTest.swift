//
//  CategoryViewModelTest.swift
//  PixabayTests
//
//  Created by Nour on 03/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import XCTest
@testable import Pixabay

class CategoryViewModelTest: XCTestCase {
    var viewModel : CategoryViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CategoryViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCellSize() {
        viewModel.collectionSize = CGSize(width: 500, height: 600)
        XCTAssertEqual(Int(viewModel.cellSize.width),  164)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
