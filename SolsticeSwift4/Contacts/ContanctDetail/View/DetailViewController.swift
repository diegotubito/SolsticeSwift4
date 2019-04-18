//
//  DetailViewController.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 16/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol DetailViewControllerDelegate: class {
    func starDidChangedDelegate(_ value: Bool)
}

class DetailViewController : UIViewController {
    
    weak var delegate : DetailViewControllerDelegate?
    
    var cells = [UITableViewCell]()
    var headerCell : TableViewCellDetailHeader!
    var homePhoneCell : TableViewCellThreeLabel!
    var mobilePhoneCell : TableViewCellThreeLabel!
    var workPhoneCell : TableViewCellThreeLabel!
    var addressCell : TableViewCellThreeLabel!
    var birthdateCell : TableViewCellThreeLabel!
    var emailCell : TableViewCellThreeLabel!
    
    var viewModel : DetailViewModel!
    
    var starButton : UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
  
    private var _userInfo : GeneralInfo?
    var userInfo : GeneralInfo? {
        get {
            return _userInfo
        } set {
            _userInfo = newValue
        }
    }
    
    var oldIsFavorite : Bool!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        oldIsFavorite = userInfo?.isFavorite
        
        viewModel = DetailViewModel()
        
        //initialization
        tableViewInit()
        starButtonInit()
     
        //load cells with selected row
        loadCells()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if oldIsFavorite != userInfo?.isFavorite {
            self.delegate?.starDidChangedDelegate((userInfo?.isFavorite)!)
        }
    }
    
    
    func tableViewInit() {
        //autorisizing rows
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        //register the cell that is going to be used
        tableView.register(TableViewCellDetailHeader.nib, forCellReuseIdentifier: TableViewCellDetailHeader.identifier)
        tableView.register(TableViewCellThreeLabel.nib, forCellReuseIdentifier: TableViewCellThreeLabel.identifier)
    }
    
    func showError(_ value: String) {
        let alert = UIAlertController.init(title: title, message: value, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
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
                if let newImage = image {
                    self.headerCell.contactImage.image = newImage
                } else {
                    self.headerCell.contactImage.image = #imageLiteral(resourceName: "User Icon Small")
                }
            }
         }) { (error) in
            DispatchQueue.main.async {
                self.headerCell.activityIndicator.stopAnimating()
                self.showError(error?.localizedDescription ?? "unknown error")
            }
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
            addressCell.leftSecondLabel.text = viewModel.getAddressSecondLabelFormat(address)
            cells.append(addressCell)
        }
        
        //Birthday Cell
        if let birthdate = userInfo?.birthday {
            birthdateCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            birthdateCell.titleLabel.text = "BIRTHDATE"
            birthdateCell.leftLabel.text = viewModel.getBirthdateFormat(birthdate)
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
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}


//starButton methods
extension DetailViewController {
    func starButtonInit() {
        starButton = UIBarButtonItem(image: getStarImage(), style: .plain, target: self, action: #selector(starButtonHandler))
        navigationItem.rightBarButtonItem = starButton
        
    }
    
    func getStarImage() -> UIImage {
        var image = #imageLiteral(resourceName: "Favorite — True").withRenderingMode(.alwaysOriginal)
        if !(userInfo?.isFavorite)! {
            image = #imageLiteral(resourceName: "Favorite — False").withRenderingMode(.alwaysOriginal)
        }
        
        return image
    }
    
    @objc func starButtonHandler() {
        userInfo?.isFavorite?.toggle()
        starButton.image = getStarImage()
    }
}
