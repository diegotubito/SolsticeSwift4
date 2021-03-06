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
    var itemsSections = [[ContactData]]()
    var itemSectionTitle = ["FAVORITE CONTACTS", "OTHER CONTACTS"]
    var contactList = [ContactData]()
    
    init?(data: [ContactData]) {
        self.contactList = data
        groupByFavoritism()
    }

    func groupByFavoritism() {
        var favorites = [ContactData]()
        var nonFavorites = [ContactData]()
        contactList.forEach { (contact) in
            contact.isFavorite ?? false ? favorites.append(contact) : nonFavorites.append(contact)
        }
        favorites = favorites.sorted(by: { $0.name! < $1.name! })
        nonFavorites = nonFavorites.sorted(by: { $0.name! < $1.name! })
        
        itemsSections.removeAll()
        itemsSections.append(favorites)
        itemsSections.append(nonFavorites)
    }
}

struct ContactData: Decodable {
    var name : String?
    var id : String?
    var companyName : String?
    var isFavorite : Bool?
    var smallImageURL : String?
    var largeImageURL : String?
    var emailAddress : String?
    var birthday : String?
    
    var address : Address?
    var phone : Phone?
    
    struct Phone: Decodable {
        var work : String?
        var home : String?
        var mobile : String?
    }
    
    struct Address : Decodable {
        var street : String?
        var city : String?
        var state : String?
        var country : String?
        var zipCode : String?
    }
}
