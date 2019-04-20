//
//  DetailViewModelContract.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol {
    init(withView view: DetailViewProtocol, interactor: ServiceManagerProtocol, senderObject: ContactData)
    func loadBigPicture(response: @escaping (UIImage) -> Void) 
    
    func getPhoneFormat(_ data: String) -> String?
    func getAddressSecondLabelFormat(_ data: ContactData.Address) -> String?
    func getBirthdateFormat(_ value: String) -> String?
    
    func getReceivedContact() -> ContactData
    func getIsFavorite_oldValue() -> Bool
    func getIsFavorite_currentValue() -> Bool
    func toggleIsFavorite()
    func isFavoriteDifferent() -> Bool
    
    
}

protocol DetailViewProtocol {
    func showError(_ value: String)
    func showLoading()
    func hideLoading()
}
