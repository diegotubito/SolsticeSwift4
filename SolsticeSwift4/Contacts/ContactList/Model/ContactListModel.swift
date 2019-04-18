//
//  ContactListModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

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
