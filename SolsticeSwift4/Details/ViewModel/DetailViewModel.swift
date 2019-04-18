//
//  DetailViewModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 17/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel: NSObject {
   
    func getAddressSecondLabelFormat(_ data: GeneralInfo.Address) -> String {
        var result = String()
        result.append(data.city ?? "")
        result.append(", ")
        result.append(data.state ?? "")
        result.append(" ")
        result.append(data.zipCode ?? "")
        result.append(", ")
        result.append(data.country ?? "")
        return result
    }
    
    func getBirthdateFormat(_ value: String) -> String {
        var result : String = ""
        if let date = value.toDate(formato: "yyyy-MM-dd") {
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let year = Calendar.current.component(.year, from: date)
            let monthName = MonthNames[month]
            result.append(monthName!)
            result.append(" ")
            result.append(String(day))
            result.append(", ")
            result.append(String(year))
        }
        
        return result
    }
}
