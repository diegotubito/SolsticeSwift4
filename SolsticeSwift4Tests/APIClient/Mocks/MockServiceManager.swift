//
//  TestServiceManager.swift
//  SolsticeSwift4Tests
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import XCTest
@testable import SolsticeSwift4

class MockServiceManager: XCTestCase {
   
    var shouldReturnError = false
    var requestRetrieveDataWasCalled = false
    
    enum MockServiceError: Error {
        case requestData
    }
    
    func reset() {
        shouldReturnError = false
        requestRetrieveDataWasCalled = false
        mockData = try? JSONSerialization.data(withJSONObject: mockJson)

    }
    
    var mockData : Data?
    var mockJson = [[
        "name": "Miss Piggy",
        "id": "13",
        "companyName": "Muppets, Baby",
        "isFavorite": false,
        "smallImageURL": "https://s3.amazonaws.com/technical-challenge/v3/images/miss-piggy-small.jpg",
        "largeImageURL": "https://s3.amazonaws.com/technical-challenge/v3/images/miss-piggy-large.jpg",
        "emailAddress": "Miss.Piggy@muppetsbaby.com",
        "birthdate": "1987-05-11",
        "phone": [
            "work": "602-225-9543",
            "home": "602-225-9188",
            "mobile": ""
        ],
        "address": [
            "street": "3530 E Washington St",
            "city": "Phoenix",
            "state": "AZ",
            "country": "US",
            "zipCode": "85034"
        ]
    ]]
    
}

extension MockServiceManager: ServiceManagerProtocol {
    func retrieveData(url: String, result: @escaping (Data?, Error?) -> Void) {
        requestRetrieveDataWasCalled = true
        
        if shouldReturnError {
            result(nil, MockServiceError.requestData)
        } else {
            result(mockData, nil)
        }
        
    }

    func downloadImageFromUrl(url: String, result: @escaping (UIImage?) -> Void, fail: @escaping (Error?) -> Void) {
        
    }
    
    
}
