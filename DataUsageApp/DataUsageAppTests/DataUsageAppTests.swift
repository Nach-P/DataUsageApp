//
//  DataUsageAppTests.swift
//  DataUsageAppTests
//
//  Created by Nach on 7/3/20.
//

import XCTest
@testable import DataUsageApp

class DataUsageAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testDataUsageAPI() {
        WebserviceManager.fetchData(urlString: "https://data.gov.sg/api/action/datastore_search?offset=0&limit=4&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f", completion: {
            dict,error in
            if let fetchDataSuccess = dict?["success"] {
                XCTAssertTrue(fetchDataSuccess as! Bool)
            }
        })
    }
    
    func testFailDataUsageAPI() {
        WebserviceManager.fetchData(urlString: "https://data.gov.sg/api/action/datastore_search?offset=-2&limit=4&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f", completion: {
            dict,error in
            if let fetchDataSuccess = dict?["success"] {
                XCTAssertFalse(fetchDataSuccess as! Bool)
            }
        })
    }
    
    func testExceptionDataUsageAPI() {
        let expectation = XCTestExpectation(description: "ExceptionAPI")
        WebserviceManager.fetchData(urlString: "https://data.gov.sg/api/action/datastore_search?offset=2&limit=4&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f", completion: {
            dict,error in
            if let fetchDataSuccess = dict?["success"] {
                XCTAssertTrue(fetchDataSuccess as! Bool)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInternalServerDataUsageAPI() {
        WebserviceManager.fetchData(urlString: "https://data.gov.sg/api/datastore_search?offset=2&limit=4&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f", completion: {
            dict,error in
            if let fetchDataSuccess = dict?["success"] {
                XCTAssertTrue(fetchDataSuccess as! Bool)
            }
        })
    }

}
