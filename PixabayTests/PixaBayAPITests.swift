//
//  PixaBayAPITests.swift
//  PixabayTests
//
//  Created by Nour on 29/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import XCTest
@testable import Pixabay

class PixaBayAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKeyUrlComponents() {
        
        let params: [PixaBayAPI.Keys: String] = [
            .q :  "",
            .editors_choice : "true",
            .category: ""
        ]
        
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: params))
 
        let request = try! PixaBayAPI.buildRequestURL(with: params)
        
        let components = URLComponents(url: request, resolvingAgainstBaseURL: true)
        guard let key_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.key.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(key_item.value, "9186145-a30a2be1c35b6d8267cab481e")
        
    }
    
    func testRequestEditorUrl() {
        
        let params: [PixaBayAPI.Keys: String] = [
            .q :  "",
            .editors_choice : "true",
            .category: ""
        ]
        
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: params))
        
        let request = try! PixaBayAPI.buildRequestURL(with: params)
        
        let components = URLComponents(url: request, resolvingAgainstBaseURL: true)
        guard let editor_choice_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.editors_choice.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(editor_choice_item.value, "true")
        
        guard let q_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.q.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(q_item.value, "")
        
        guard let category_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.category.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(category_item.value, "")
        
    }
    
    func testRequestCategoryUrl() {
        
        let params: [PixaBayAPI.Keys: String] = [
            .q :  "",
            .editors_choice : "false",
            .category: "nature"
        ]
        
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: params))
        let request = try! PixaBayAPI.buildRequestURL(with: params)
        
        let components = URLComponents(url: request, resolvingAgainstBaseURL: true)
        
        guard let category_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.category.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(category_item.value, "nature")
        
        guard let editor_choice_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.editors_choice.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(editor_choice_item.value, "false")
        
        guard let q_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.q.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(q_item.value, "")
    }
    
    func testRequestSearchUrl() {
        
        let params: [PixaBayAPI.Keys: String] = [
            .q :  "red",
            .editors_choice : "false",
            .category: ""
        ]
        
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: params))
        
        let request = try! PixaBayAPI.buildRequestURL(with: params)
        
        let components = URLComponents(url: request, resolvingAgainstBaseURL: true)
        
        guard let q_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.q.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(q_item.value, "red")
        
        guard let category_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.category.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(category_item.value, "")
        
        guard let editor_choice_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.editors_choice.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(editor_choice_item.value, "false")
        
        
        guard let order_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.order.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(order_item.value, "popular")
        
      
    }
    
    func testIsValidResponse(){
        let httpErrorUrlResponse = HTTPURLResponse(url: URL(fileURLWithPath: "transparent"), statusCode: 400, httpVersion: nil, headerFields: nil)
    
        let data: Data = "input".data(using: .utf8)!
        let responseError: (HTTPURLResponse, Data) = (httpErrorUrlResponse!, data)
        
         XCTAssertThrowsError(try PixaBayAPI.isValid(response: responseError))
        
        let httpOkUrlResponse = HTTPURLResponse(url: URL(fileURLWithPath: "transparent"), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let responseOk: (HTTPURLResponse, Data) = (httpOkUrlResponse!, data)
    
        XCTAssertTrue(try! PixaBayAPI.isValid(response: responseOk))

    }
    
    func testDecodeResponse() {
        let responseFileUrl = Bundle.main.url(forResource: "response", withExtension: "json")
        
        let responseData = try! Data(contentsOf: responseFileUrl!)
        
       let photoModels =  try! PixaBayAPI.decode(response: responseData)
        
        XCTAssertEqual(photoModels.first!.id, 3489394)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
