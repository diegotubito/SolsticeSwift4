//
//  ServiceProtocol.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceManagerProtocol {
    func retrieveData(url: String, result: @escaping(Data?, Error?) -> Void)
    func downloadImageFromUrl(url: String, result: @escaping (UIImage?) -> Void, fail: @escaping (Error?) -> Void)
}
