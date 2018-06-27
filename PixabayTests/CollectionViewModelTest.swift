//
//  CollectionViewModelTest.swift
//  PixabayTests
//
//  Created by Nour on 17/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Pixabay

class CollectionViewModelTest: XCTestCase {
    
    var viewModel: CollectionViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        //viewModel = CollectionViewModel(collectionView: nil, type: .Editor, data: nil)
        viewModel = CollectionViewModel()
        viewModel.model = EditorCollectionModel()
        viewModel.model.data = nil
        scheduler = ConcurrentDispatchQueueScheduler.init(qos: .default)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
   
    func testLoadPhotos() {
        viewModel.pageNumber = 1 //HTTP should pass
        let observable = viewModel.loadPhotos().subscribeOn(scheduler)
        var lodedItemsIndexPathes: [IndexPath] = []
        
        for x in 0..<PixaBayAPI.MaxFetchPerPage {
            lodedItemsIndexPathes.append(IndexPath(item: x, section: 0))
        }
        
        for _ in 0...1 {
        do {
            let response = observable.toBlocking(timeout: 3.0).materialize()
            switch response {
            case .completed(elements: let responses):
                XCTAssertEqual(responses.first!, ResponseStatus.Start)
                XCTAssertEqual(viewModel.loadedItems, lodedItemsIndexPathes)
                XCTAssertEqual(viewModel.loadedItemsUrl.count, 150)
                break
            case .failed(elements: let response, error: _):
                XCTAssertEqual(response.first!, ResponseStatus.Failed(PixaApiError.HttpResponseError("error")))
                break
            }
        }
             viewModel.pageNumber = -1 //-> HTTP response error
        
       }
       
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
