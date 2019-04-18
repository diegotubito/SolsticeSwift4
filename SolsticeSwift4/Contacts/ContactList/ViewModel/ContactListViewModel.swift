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
    var model: ContactListModel?
    
    required init(withView view: ContactListViewProtocol) {
        _view = view
    
    }
    
    func loadData() {
        //show loading animation
        _view.showLoading()
        
        //load data from endpoint "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
        ServiceManager.retrieveData(onSuccess: { (response) in
            //success, load model and show data in table view
            
            //hide loading animation
            self._view.hideLoading()
            
            //save data to model
            self.model = ContactListModel(data: response)
            
            //show all register in table view
            self._view.showList()
            
        }) { (error) in
            //hide loading animation
            self._view.hideLoading()
            
            //show and error message
            self._view.showError(error.localizedDescription)
        }
    }
    
    func loadImage(_ url: String, success: @escaping (UIImage?) -> Void, fail: @escaping (String) -> Void) {
        ServiceManager.downloadImageFromUrl(url: url, result: { (image) in
            success(image)
        }) { (err) in
            fail(err?.localizedDescription ?? "Error")
            
        }
        
    }
    
    
}
