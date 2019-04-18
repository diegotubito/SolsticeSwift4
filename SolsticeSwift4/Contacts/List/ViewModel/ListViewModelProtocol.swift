//
//  ListViewModelProtocol.swift
//  Solstice
//
//  Created by iMac on 11/04/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewModelProtocol {
    init(withView view: ListViewProtocol)
    var items : [ProfileViewModelItem] {get set}
    func loadData()
    func loadImage(_ url: String, success:  @escaping (UIImage?) -> Void, fail:  @escaping (String) -> Void)
}

protocol ListViewProtocol {
    func showError(_ value: String)
    func showList()
    func showLoading()
    func hideLoading()
}

enum ProfileViewModelItemType {
    case favorite
    case nonFavorite
}

protocol ProfileViewModelItem {
    var rowCount : Int {get}
    var type : ProfileViewModelItemType {get}
    var titleSection : String {get}
}
