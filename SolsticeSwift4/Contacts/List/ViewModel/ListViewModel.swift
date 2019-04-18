//
//  ListViewModel.swift
//  Solstice
//
//  Created by iMac on 11/04/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class ListViewModel: ListViewModelProtocol {
    
    
  
    var items = [ProfileViewModelItem]()
    var _view : ListViewProtocol!
    
    required init(withView view: ListViewProtocol) {
        //initialize _view
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
            guard let profile = Profile(data: response) else {
                return
            }
          
            if profile.favorites.count > 0 {
                let favorites = ProfileViewModelFavoriteItem(info: profile.favorites)
                self.items.append(favorites)
            }
            if profile.nonFavorites.count > 0 {
                let nonFavorites = ProfileViewModelNonFavoriteItem(info: profile.nonFavorites)
                self.items.append(nonFavorites)
            }
            
            
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


class ProfileViewModelFavoriteItem: ProfileViewModelItem {
    
    var type: ProfileViewModelItemType {
        return .favorite
    }
    
    var titleSection: String {
        return "FAVORITE CONTACTS"
    }
    
    var rowCount: Int {
        return favorites.count
    }
    
    var favorites: [GeneralInfo]
    
    init(info: [GeneralInfo]) {
        let sortedArray = info.sorted(by: { $0.name! < $1.name! })
        self.favorites = sortedArray
    }
}


class ProfileViewModelNonFavoriteItem: ProfileViewModelItem {
    
    var type: ProfileViewModelItemType {
        return .nonFavorite
    }
    
    var titleSection: String {
        return "OTHER CONTACTS"
    }
    
    var rowCount: Int {
        return nonFavorites.count
    }
    
    var nonFavorites: [GeneralInfo]
    
    init(info: [GeneralInfo]) {
        let sortedArray = info.sorted(by: { $0.name! < $1.name! })
        self.nonFavorites = sortedArray
    }
}


