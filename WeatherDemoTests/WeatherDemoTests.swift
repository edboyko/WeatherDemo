//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Edwin Boyko on 22/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import XCTest
@testable import WeatherDemo

class WeatherDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testCacheManagerSavesDataToDirectory() {
        let directory = "Test"
        let expectation = XCTestExpectation(description: "File saved successfully")
        
        if let data = "Test data!".data(using: .utf8) {
            
            CacheManager().saveToCache(data, directory: directory) { (success, path) in
                if success == true {
                    
                    // Check file exists at directory
                    
                    if FileManager.default.fileExists(atPath: path) {
                        // Pass the test
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
}
