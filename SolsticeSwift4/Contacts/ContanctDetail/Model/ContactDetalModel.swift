//
//  ContactDetalModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class DetailModel {
    var contactReceived : GeneralInfo!
    var oldIsFavorite : Bool!
    
    
    init(contactReceived: GeneralInfo) {
        self.contactReceived = contactReceived
        oldIsFavorite = contactReceived.isFavorite
    }
}
