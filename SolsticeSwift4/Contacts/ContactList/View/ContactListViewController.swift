//
//  ContactListViewController.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 18/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewController: UIViewController, ContactListViewProtocol {
    @IBOutlet var tableView: UITableView!
    
    var viewModel : ContactListViewModelProtocol?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //title
        navigationItem.title = "Contacts"
        
        //some init
        tableViewInit()
        
        //load info list from url, then show on table view.
        viewModel?.loadData()
        
    }
    
    func tableViewInit() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.register(TableViewCellRegisterList.nib, forCellReuseIdentifier: TableViewCellRegisterList.identifier)
    }
    
    func showError(_ value: String) {
        
        let alert = UIAlertController.init(title: title, message: value, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            DDBarLoader.showLoading(controller: self, message: "Loading")
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            DDBarLoader.hideLoading()
        }
    }
}


extension ContactListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.model?.itemsSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.itemsSections[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellRegisterList.identifier, for: indexPath) as? TableViewCellRegisterList {
            
            let data = viewModel?.model!.itemsSections[indexPath.section][indexPath.row]
            showCell(cell: cell, rowData: data!, index: indexPath.row)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func showCell(cell: TableViewCellRegisterList, rowData: ContactData, index: Int) {
        cell.nameCell.text = rowData.name
        cell.companyNameCell.text = rowData.companyName
        
        //this line avoid wrong image show
        cell.iconImageCell.image = #imageLiteral(resourceName: "User Icon Small")
        //this solve flickering issue
        cell.tag = index
        
        //load image
        cell.activityIndicator.startAnimating()
        self.viewModel?.loadImage(rowData.smallImageURL ?? "", success: { (image) in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                
                //the if clause avoid flickering
                if image == nil {
                    return
                }
                if cell.tag == index {
                    cell.iconImageCell.image = image
                }
                
            }
            
        }, fail: { (error) in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                //the if clause avoid flickering
                if cell.tag == index {
                    cell.iconImageCell.image = #imageLiteral(resourceName: "User Icon Small")
                }
                self.showError(error)
            }
            
        })
        
        if rowData.isFavorite! {
            cell.starImageCell.image = #imageLiteral(resourceName: "Favorite — True")
            cell.starImageCell.alpha = 1
        } else {
            cell.starImageCell.alpha = 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.model?.itemSectionTitle[section]
    }
}



extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let selectedContact : ContactData?
        selectedContact = viewModel?.model?.itemsSections[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "segue_to_detail", sender: selectedContact)
    }
    
}


extension ContactListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: nil)
        
        if let controller = segue.destination as? ContactDetailViewController, let object = sender as? ContactData {
            controller.delegate = self
            controller.viewModel = DetailViewModel(withView: controller, interactor: ServiceManager(), senderObject: object)
        }
    }
}


extension ContactListViewController: ContactDetailViewControllerDelegate {
    func starDidChangedDelegate(_ value: Bool) {
        //this block is executed only if star status has changed from contact detail.
        
        //Basically I identify the object in rawList, to change isFavorite property with the new value.
        
        let index = tableView.indexPathForSelectedRow
        let selectedItem = viewModel?.model?.itemsSections[(index?.section)!][(index?.row)!]
        
        //get position
        let position = viewModel?.model?.contactList.index(where: { $0.id == selectedItem?.id })
        
        //change isFavorite with new value at position
        viewModel?.model?.contactList[position!].isFavorite = value
        
        //update list where other contacts and favorites are separated
        viewModel?.model?.groupByFavoritism()
        
        //finally reload table view
        showList()
    }
    
}

