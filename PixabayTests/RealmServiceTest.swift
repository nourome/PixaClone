//
//  RealmServiceTest.swift
//  PixabayTests
//
//  Created by Nour on 17/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Pixabay

class RealmServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSave() {
        
        let parameters: [PixaBayAPI.Keys : String] = [
            .q: "test",
            .category:"testing",
            .editors_choice:"false",
            .page:"10"
        ]
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: parameters))
        
        do {
            let url = try PixaBayAPI.buildRequestURL(with: parameters)
            let jsonResponse = "{\"totalHits\": \"500\"}".data(using: .utf8)!
            RealmService.save(for: url, with: jsonResponse)
            
            let realm = try! Realm()
            let savedRecord =  realm.objects(ApiResponse.self).first!
            
            let cached = ApiResponse()
            cached.isValid = true
            cached.response = jsonResponse
            cached.url = url.absoluteString
            
            XCTAssertEqual(savedRecord.url, cached.url, "failed to match URL")
            XCTAssertEqual(savedRecord.response, cached.response, "failed to match Response")
            XCTAssertEqual(savedRecord.isValid, cached.isValid, "failed to match isValid")
            
        }catch {
            XCTFail(error.localizedDescription)
        }
        
        
        
    }
    
    func testCache() {
        let parameters: [PixaBayAPI.Keys : String] = [
            .q: "test",
            .category:"testing",
            .editors_choice:"false",
            .page:"10"
        ]
        
        XCTAssertNoThrow(try PixaBayAPI.buildRequestURL(with: parameters))
        
        do {
        let url = try PixaBayAPI.buildRequestURL(with: parameters)
        
        var response =  RealmService.cache(for: url)
        XCTAssertNil(response)
        
        let realm = try! Realm()
        let newRecord = ApiResponse()
        newRecord.isValid = true
        newRecord.url = url.absoluteString
        newRecord.response = "test".data(using: .utf8)!
        
        try! realm.write {
            realm.add(newRecord)
        }
        
        response = RealmService.cache(for: url)
        XCTAssertNotNil(response)
        
        
        try! realm.write {
            newRecord.date = Date().addingTimeInterval(-RealmService.lifePeriod)
        }
        
        response = RealmService.cache(for: url)
        XCTAssertNil(response)
        
        try! realm.write {
            newRecord.date = Date()
        }
        
        response = RealmService.cache(for: url)
        XCTAssertNotNil(response)
        }catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
