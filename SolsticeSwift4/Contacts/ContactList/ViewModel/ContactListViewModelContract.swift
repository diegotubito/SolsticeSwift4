//
//  ContactListViewModelContract.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol ContactListViewModelProtocol {
    init (withView view: ContactListViewProtocol, interactor: ServiceManagerProtocol)
    var model : ContactListModel? {get}
    func loadData()
    func loadImage(_ url: String, success:  @escaping (UIImage?) -> Void, fail:  @escaping (String) -> Void)
}

protocol ContactListViewProtocol {
    func showError(_ value: String)
    func showList()
    func showLoading()
    func hideLoading()
}
