//
//  DetailViewController.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 16/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    private var _userInfo : GeneralInfo?
    var cells = [UITableViewCell]()
    var headerCell : TableViewCellDetailHeader!
    var homePhoneCell : TableViewCellThreeLabel!
    var mobilePhoneCell : TableViewCellThreeLabel!
    var workPhoneCell : TableViewCellThreeLabel!
    var addressCell : TableViewCellThreeLabel!
    var birthdateCell : TableViewCellThreeLabel!
    var emailCell : TableViewCellThreeLabel!
    
    let height = UIScreen.main.bounds.height
    let widht = UIScreen.main.bounds.width
    
    var starButton : UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    var userInfo : GeneralInfo? {
        get {
            return _userInfo
        } set {
            _userInfo = newValue
        }
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //some init
        tableViewInit()
        starButtonInit()
        
        //load cells with selected row
        loadCells()
        
    }
    
    @objc func starButtonHandler() {
        print("handle star button")
    }
    
    func starButtonInit() {
        
        var image = #imageLiteral(resourceName: "Favorite — True").withRenderingMode(.alwaysOriginal)
        if !(userInfo?.isFavorite)! {
            image = #imageLiteral(resourceName: "Favorite — False").withRenderingMode(.alwaysOriginal)
        }
        starButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(starButtonHandler))
        navigationItem.rightBarButtonItem = starButton
        
    }
    
    func tableViewInit() {
        //autorisizing rows
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = height*0.3
        
        //register the cell that is going to be used
        tableView.register(TableViewCellDetailHeader.nib, forCellReuseIdentifier: TableViewCellDetailHeader.identifier)
        tableView.register(TableViewCellThreeLabel.nib, forCellReuseIdentifier: TableViewCellThreeLabel.identifier)
    }
    
    func loadCells() {
        //Header cell
        headerCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellDetailHeader.identifier) as? TableViewCellDetailHeader
        headerCell.title.text = userInfo?.name
        headerCell.subTitle.text = userInfo?.companyName
        
        
        headerCell.activityIndicator.startAnimating()
        ServiceManager.downloadImageFromUrl(url: (userInfo?.largeImageURL)!, result: { (image) in
            DispatchQueue.main.async {
                self.headerCell.activityIndicator.stopAnimating()
                self.headerCell.contactImage.image = image
            }
         }) { (error) in
            DispatchQueue.main.async {
                self.headerCell.activityIndicator.stopAnimating()
            }
            print("error de algo")
        }
        
        cells.append(headerCell)
        
        //Home Phone Cell
        if let phone = userInfo?.phone, let home = phone.home {
            homePhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            homePhoneCell.titleLabel.text = "PHONE"
            homePhoneCell.leftLabel.text = home
            homePhoneCell.rightLabel.text = "Home"
            cells.append(homePhoneCell)
        }
        //Mobile Phone Cell
        if let phone = userInfo?.phone, let mobile = phone.mobile {
            mobilePhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            mobilePhoneCell.titleLabel.text = "PHONE"
            mobilePhoneCell.leftLabel.text = mobile
            mobilePhoneCell.rightLabel.text = "Mobile"
            cells.append(mobilePhoneCell)
        }
        
        //Work Phone Cell
        if let phone = userInfo?.phone, let mobile = phone.work {
            workPhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            workPhoneCell.titleLabel.text = "PHONE"
            workPhoneCell.leftLabel.text = mobile
            workPhoneCell.rightLabel.text = "Work"
            cells.append(workPhoneCell)
        }
        
        //Address Cell
        if let address = userInfo?.address {
            addressCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            addressCell.titleLabel.text = "ADDRESS"
            addressCell.leftSecondLabel.isHidden = false
            addressCell.rightLabel.isHidden = true
            addressCell.leftLabel.text = address.street
            addressCell.leftSecondLabel.text = getAddressSecondLabelFormat(address)
            cells.append(addressCell)
        }
        
        //Birthday Cell
        if let birthdate = userInfo?.birthday {
            birthdateCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            birthdateCell.titleLabel.text = "BIRTHDATE"
            birthdateCell.leftLabel.text = getBirthdateFormat(birthdate)
            birthdateCell.rightLabel.isHidden = true
      
            cells.append(birthdateCell)
        }
        
        //Email Cell
        if let email = userInfo?.emailAddress {
            emailCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            emailCell.titleLabel.text = "EMAIL"
            emailCell.leftLabel.text = email
            emailCell.rightLabel.isHidden = true
            
            cells.append(emailCell)
        }
        

    }
    
    func getAddressSecondLabelFormat(_ data: GeneralInfo.Address) -> String {
        var result = String()
        result.append(data.city ?? "")
        result.append(", ")
        result.append(data.state ?? "")
        result.append(" ")
        result.append(data.zipCode ?? "")
        result.append(", ")
        result.append(data.country ?? "")
        return result
    }
    
    func getBirthdateFormat(_ value: String) -> String {
        var result : String = ""
        if let date = value.toDate(formato: "yyyy-MM-dd") {
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let year = Calendar.current.component(.year, from: date)
            let monthName = MonthNames[month]
            result.append(monthName!)
            result.append(" ")
            result.append(String(day))
            result.append(", ")
            result.append(String(year))
        }
        
        return result
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension DetailViewController: UITableViewDelegate {
    
}
