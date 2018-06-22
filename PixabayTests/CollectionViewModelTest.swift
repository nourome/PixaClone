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
        viewModel = CollectionViewModel(collectionView: nil, type: .Editor, data: nil)
        scheduler = ConcurrentDispatchQueueScheduler.init(qos: .default)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateDummyPhotos() {
        let dummy = viewModel.insertDummyPhotos()
        
        XCTAssertEqual(dummy.count, PixaBayAPI.MaxFetchPerPage)
        
        let dummyUrl = Bundle.main.url(forResource: "transparent", withExtension: "png")!
        XCTAssertEqual(dummy.first!.previewURL, dummyUrl)
    }
    
    func testLoadPhotos() {
        viewModel.pageNumber = 20 //HTTP should pass
        let observable = viewModel.loadPhotos().subscribeOn(scheduler)
        
        for _ in 0...1 {
        do {
            let response = observable.toBlocking(timeout: 1.0).materialize()
            print(response)
            switch response {
            case .completed(elements: let responses):
                XCTAssertEqual(responses.count, 2)
                XCTAssertEqual(responses.first!, ResponseStatus.Dummy)
                XCTAssertEqual(responses[1], ResponseStatus.Success)
                break
            case .failed(elements: let response, error: _):
                XCTAssertEqual(response[1], ResponseStatus.Failed(PixaApiError.HttpResponseError("error")))
                break
            }
        }
             viewModel.pageNumber = 0 //-> HTTP response error
        
        }
       
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
