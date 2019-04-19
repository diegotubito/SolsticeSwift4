//
//  TestServiceManager.swift
//  SolsticeSwift4Tests
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import XCTest
@testable import SolsticeSwift4

class TestServiceManager: XCTestCase {
    private let endPoint = "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
    
    //testing real APIClient
    //let retrieveApiClient = ServiceManager()
 
    //testing mock APIClient
    let retrieveApiClient = MockServiceManager()
        
    func testRetrieveData() {
        //uncomment the following two lines, when mock test is used.
        retrieveApiClient.reset()
        retrieveApiClient.shouldReturnError = false
        
        let expectation = self.expectation(description: "I expect to receive Data")
        
        retrieveApiClient.retrieveData(url: endPoint) { (data, error) in
            //hide loading animation
            
            XCTAssertNil(error)
            guard let json = data else {
                XCTFail()
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: json, options: []) as? [[String : Any]]
                //save data to model
                let model = ContactListModel(data: jsonData!)
                XCTAssertNotNil(model?.itemsSections)
            
                expectation.fulfill()
                
            } catch{
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
}
