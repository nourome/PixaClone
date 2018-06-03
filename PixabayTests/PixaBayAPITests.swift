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
        
        guard let request = PixaBayAPI.buildRequestURL(with: params) else {
            XCTFail()
            return
        }
        
        let components = URLComponents(url: request, resolvingAgainstBaseURL: true)
        guard let key_item = components?.queryItems?.first(where: { item in
            item.name == PixaBayAPI.Keys.key.rawValue
        }) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(key_item.value, "6518569-4d75e16c86e11f24a357edc18")

    }
    
    func testRequestEditorUrl() {
        
        let params: [PixaBayAPI.Keys: String] = [
            .q :  "",
            .editors_choice : "true",
            .category: ""
        ]
        
        guard let request = PixaBayAPI.buildRequestURL(with: params) else {
            XCTFail()
            return
        }
        
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
        
        guard let request = PixaBayAPI.buildRequestURL(with: params) else {
            XCTFail()
            return
        }
        
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
        
        guard let request = PixaBayAPI.buildRequestURL(with: params, latest: true) else {
            XCTFail()
            return
        }
        
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
        
        XCTAssertEqual(order_item.value, "latest")
        
      
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
