//
//  ContactListViewModel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewModel: ContactListViewModelProtocol {
    var _view : ContactListViewProtocol!
    var _interactor : ServiceManagerProtocol!
    var model: ContactListModel?
    
    required init(withView view: ContactListViewProtocol, interactor: ServiceManagerProtocol) {
        _view = view
        _interactor = interactor
    }
    
    func loadData() {
        //show loading animation
        _view.showLoading()
        
        //load data from endpoint "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
        let endPoint = "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
        
        _interactor.retrieveData(url: endPoint) { (data, error) in
            //hide loading animation
            self._view.hideLoading()
            
            guard let json = data else {
                self._view.showError(error?.localizedDescription ?? "unkown error")
                return
            }
            
            do {
                let array = try JSONDecoder().decode([ContactData].self, from: json)
         
                //save data to model
                self.model = ContactListModel(data: array)
               
                //show all register in table view
                self._view.showList()
 
            } catch{
                self._view.showError(error.localizedDescription)
            }
        }
        
    }
    
    func loadImage(_ url: String, success: @escaping (UIImage?) -> Void, fail: @escaping (String) -> Void) {
        _interactor.downloadImageFromUrl(url: url, result: { (image) in
            success(image)
        }) { (err) in
            fail(err?.localizedDescription ?? "Error")
            
        }
        
    }
    
    
}
