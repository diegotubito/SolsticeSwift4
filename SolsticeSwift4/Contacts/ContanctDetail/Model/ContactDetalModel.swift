//
//  ContactDetalModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class ContactDetailModel {
    var receivedContact : ContactData!
    var isFavorite_oldValue : Bool!
    
    
    init(receivedContact: ContactData) {
        self.receivedContact = receivedContact
        isFavorite_oldValue = receivedContact.isFavorite
    }
}
