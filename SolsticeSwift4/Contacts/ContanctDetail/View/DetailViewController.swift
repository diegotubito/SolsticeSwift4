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
    
    var viewModel : DetailViewModelProtocol!
    
    var starButton : UIBarButtonItem!

    @IBOutlet var tableView: UITableView!
   
     
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //initialization
        tableViewInit()
        starButtonInit()
     
        //load cells with selected contact information
        loadCells()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //when return to contact list view, if favorite status had changed then it runs delegete protocol method
        if viewModel.isFavoriteDifferent() {
            self.delegate?.starDidChangedDelegate(viewModel.getCurrentIsFavorite())
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
    
   
    
    func loadCells() {
        let userInfo : GeneralInfo? = viewModel.getReceivedContact()
        
        //Header cell
        headerCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellDetailHeader.identifier) as? TableViewCellDetailHeader
        headerCell.title.text = userInfo?.name
        headerCell.subTitle.text = userInfo?.companyName
        
        //load image in background
        viewModel.loadBigPicture { (image) in
            self.headerCell.contactImage.image = image
        }
        cells.append(headerCell)
        
        //Home Phone Cell
        if let phone = userInfo?.phone, let home = phone.home, home != "" {
            homePhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            homePhoneCell.titleLabel.text = "PHONE"
            homePhoneCell.leftLabel.text = viewModel.getPhoneFormat(home)
            homePhoneCell.rightLabel.text = "Home"
            cells.append(homePhoneCell)
        }
        //Mobile Phone Cell
        if let phone = userInfo?.phone, let mobile = phone.mobile, mobile != "" {
            mobilePhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            mobilePhoneCell.titleLabel.text = "PHONE"
            mobilePhoneCell.leftLabel.text = viewModel.getPhoneFormat(mobile)
            mobilePhoneCell.rightLabel.text = "Mobile"
            cells.append(mobilePhoneCell)
        }
        
        //Work Phone Cell
        if let phone = userInfo?.phone, let work = phone.work, work != "" {
            workPhoneCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            workPhoneCell.titleLabel.text = "PHONE"
            workPhoneCell.leftLabel.text = viewModel.getPhoneFormat(work)
            workPhoneCell.rightLabel.text = "Work"
            cells.append(workPhoneCell)
        }
        
        //Address Cell
        if let address = userInfo?.address, let displayAddress = viewModel.getAddressSecondLabelFormat(address) {
            addressCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellThreeLabel.identifier) as? TableViewCellThreeLabel
            addressCell.titleLabel.text = "ADDRESS"
            addressCell.leftSecondLabel.isHidden = false
            addressCell.rightLabel.isHidden = true
            addressCell.leftLabel.text = address.street
            addressCell.leftSecondLabel.text = displayAddress
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
    
    @objc func starButtonHandler() {
        viewModel.toggleIsFavorite()
        starButton.image = getStarImage()
    }
    
    func getStarImage() -> UIImage {
        let isFavorite = viewModel.getCurrentIsFavorite()
        
        var image = #imageLiteral(resourceName: "Favorite — True").withRenderingMode(.alwaysOriginal)
        if !isFavorite {
            image = #imageLiteral(resourceName: "Favorite — False").withRenderingMode(.alwaysOriginal)
        }
        
        return image
    }
    
}


extension DetailViewController: DetailViewProtocol {
    func showLoading() {
        DispatchQueue.main.async {
            self.headerCell.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.headerCell.activityIndicator.stopAnimating()
        }
    }
    
    func showError(_ value: String) {
        let alert = UIAlertController.init(title: title, message: value, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
}
