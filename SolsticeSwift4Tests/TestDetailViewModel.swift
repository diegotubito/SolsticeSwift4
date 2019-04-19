//
//  TestDetailViewModel.swift
//  SolsticeSwift4Tests
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import XCTest
@testable import SolsticeSwift4

class TestDetailViewModel: XCTestCase {

    func test_getPhoneFormat() {
        let phone = "12adfs3-123-2332"
        
        let viewModel = DetailViewModel()
        
        let newFormat = viewModel.getPhoneFormat(phone)
        
        XCTAssertEqual(newFormat, "(12adfs3) 123-2332")
    }
    
    func test_getBirthdateFormat_nil() {
        let stringDate = "1977-12-32"
        
        let viewModel = DetailViewModel()
        let newStringDate = viewModel.getBirthdateFormat(stringDate)
        
        XCTAssertNil(newStringDate)
    
    }

    func test_getBirthdateFormat() {
        let stringDate = "1977-12-31"
        
        let viewModel = DetailViewModel()
        let newStringDate = viewModel.getBirthdateFormat(stringDate)
        
         XCTAssertEqual(newStringDate, "December 31, 1977")
    }

}
