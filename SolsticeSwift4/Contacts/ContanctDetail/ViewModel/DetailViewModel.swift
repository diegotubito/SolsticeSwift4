//
//  DetailViewModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 17/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel: DetailViewModelProtocol {
   
    
    
    var _view : DetailViewProtocol!
    var _interactor : ServiceManagerProtocol!
    var model : ContactDetailModel!
    
    required init(withView view: DetailViewProtocol, interactor: ServiceManagerProtocol, senderObject: ContactData) {
        _view = view
        _interactor = interactor
        
        model = ContactDetailModel(receivedContact: senderObject)
    }
    
    init() {
        
    }
    
    func loadBigPicture(response: @escaping (UIImage) -> Void) {
        _view.showLoading()
        _interactor.downloadImageFromUrl(url: model.receivedContact.largeImageURL!, result: { (image) in
            self._view.hideLoading()
            
            DispatchQueue.main.async {
                if let newImage = image {
                    response(newImage)
                } else {
                    response(#imageLiteral(resourceName: "User Icon Small"))
                }
                
            }
            
        }) { (error) in
            self._view.hideLoading()
            self._view.showError(error?.localizedDescription ?? "unknown error")
        }
    }

    
    func getPhoneFormat(_ data: String) -> String? {
        if data == "" {return nil}
        
        var result = String()
        
        //get index position of the firt "-"
        let range: Range<String.Index> = data.range(of: "-")!
        let index: Int = data.distance(from: data.startIndex, to: range.lowerBound)
        
        let code = data.prefix(index)
        let number = data.dropFirst(index + 1)
        result.append("(\(code)) " + number)
        
        return result
    }
   
    func getAddressSecondLabelFormat(_ data: ContactData.Address) -> String? {
        var result = String()
        result.append(data.city ?? "")
        result.append(", ")
        result.append(data.state ?? "")
        result.append(" ")
        result.append(data.zipCode ?? "")
        result.append(", ")
        result.append(data.country ?? "")
        if result.count <= 5 {
            return nil
        }
        return result
    }
    
    func getBirthdateFormat(_ value: String) -> String? {
        var result : String?
        if let date = value.toDate(formato: "yyyy-MM-dd") {
            result = ""
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let year = Calendar.current.component(.year, from: date)
            let monthName = MonthNames[month]
            result?.append(monthName!)
            result?.append(" ")
            result?.append(String(day))
            result?.append(", ")
            result?.append(String(year))
        }
        
        return result
    }
    
    func getReceivedContact() -> ContactData {
        return model.receivedContact
    }
    
    func getIsFavorite_oldValue() -> Bool {
        return model.isFavorite_oldValue!
    }
    
    func getIsFavorite_currentValue() -> Bool {
        return (model.receivedContact.isFavorite)!
    }
    
    func toggleIsFavorite() {
       
        (model.receivedContact.isFavorite)!.toggle()
    }
    
    func isFavoriteDifferent() -> Bool {
        let currentValue = model.receivedContact.isFavorite
        
        if model.isFavorite_oldValue != currentValue {
            return true
        }
        return false
    }
}
