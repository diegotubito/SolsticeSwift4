//
//  ContactListModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class ContactListModel {
    var itemsSections = [[GeneralInfo]]()
    var itemSectionTitle = ["FAVORITE CONTACTS", "OTHER CONTACTS"]
    
    var rawList = [GeneralInfo]()
    
    init?(data: [[String : Any]]) {
        var aux = [GeneralInfo]()
        data.forEach { (contact) in
            aux.append(GeneralInfo(json: contact))
        }
        self.rawList = aux
        adaptData()
    }

    func adaptData() {
        var favorites = [GeneralInfo]()
        var nonFavorites = [GeneralInfo]()
        rawList.forEach { (contact) in
            contact.isFavorite! ? favorites.append(contact) : nonFavorites.append(contact)
        }
        favorites = favorites.sorted(by: { $0.name! < $1.name! })
        nonFavorites = nonFavorites.sorted(by: { $0.name! < $1.name! })
        
        itemsSections.removeAll()
        itemsSections.append(favorites)
        itemsSections.append(nonFavorites)
    }
    
      
}

class GeneralInfo {
    var name : String?
    var id : String?
    var companyName : String?
    var isFavorite : Bool?
    var smallImageURL : String?
    var smallImage : UIImage?
    var largeImageURL : String?
    var emailAddress : String?
    var birthday : String?
    
    var address : Address?
    var phone : Phone?
    
    init(json: [String : Any]) {
        name = json[Keys.name] as? String
        id = json[Keys.id] as? String
        companyName = json[Keys.companyName] as? String
        isFavorite = json[Keys.isFavorite] as? Bool
        smallImageURL = json[Keys.smallImageURL] as? String
        largeImageURL = json[Keys.largeImageURL] as? String
        emailAddress = json[Keys.emailAddress] as? String
        birthday = json[Keys.birthdate] as? String
        
        phone = Phone(phoneJson: json[Keys.phone] as? [String:Any])
        address = Address(addessJson: json[Keys.address] as? [String:Any])
    }
    
    
    struct Phone {
        var work : String?
        var home : String?
        var mobile : String?
        
        init(phoneJson : [String : Any]?) {
            work = phoneJson?[Keys.PhoneKeys.work] as? String
            home = phoneJson?[Keys.PhoneKeys.home] as? String
            mobile = phoneJson?[Keys.PhoneKeys.mobile] as? String
        }
    }
    struct Address {
        var street : String?
        var city : String?
        var state : String?
        var country : String?
        var zipCode : String?
        
        init(addessJson: [String : Any]?) {
            street = addessJson?[Keys.AddressKeys.street] as? String
            city = addessJson?[Keys.AddressKeys.city] as? String
            state = addessJson?[Keys.AddressKeys.state] as? String
            country = addessJson?[Keys.AddressKeys.country] as? String
            zipCode = addessJson?[Keys.AddressKeys.zipCode] as? String
        }
    }
}

struct Keys {
    static let name = "name"
    static let id = "id"
    static let companyName = "companyName"
    static let isFavorite = "isFavorite"
    static let smallImageURL = "smallImageURL"
    static let largeImageURL = "largeImageURL"
    static let emailAddress = "emailAddress"
    static let birthdate = "birthdate"
    static let phone = "phone"
    static let address = "address"
    
    struct PhoneKeys {
        static let work = "work"
        static let home = "home"
        static let mobile = "mobile"
    }
    
    struct AddressKeys {
        static let street = "street"
        static let city = "city"
        static let state = "state"
        static let country = "country"
        static let zipCode = "zipCode"
    }
}
