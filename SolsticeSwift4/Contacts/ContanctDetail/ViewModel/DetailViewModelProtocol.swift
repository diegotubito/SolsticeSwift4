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
    init(withView view: DetailViewProtocol, interactor: ServiceManagerProtocol, senderObject: GeneralInfo)
    func loadBigPicture(response: @escaping (UIImage) -> Void) 
    
    func getPhoneFormat(_ data: String) -> String?
    func getAddressSecondLabelFormat(_ data: GeneralInfo.Address) -> String?
    func getBirthdateFormat(_ value: String) -> String?
    
    func getReceivedContact() -> GeneralInfo
    func getOldIsFavorite() -> Bool
    func getCurrentIsFavorite() -> Bool
    func toggleIsFavorite()
    func isFavoriteDifferent() -> Bool
    
    
}

protocol DetailViewProtocol {
    func showError(_ value: String)
    func showLoading()
    func hideLoading()
}
