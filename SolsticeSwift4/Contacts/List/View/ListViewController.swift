//
//  ViewController.swift
//  Solstice
//
//  Created by iMac on 11/04/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, ListViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : ListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items[section].rowCount ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.section]
        switch item!.type {
        case .favorite:
            if let item = item as? ProfileViewModelFavoriteItem, let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellRegisterList.identifier, for: indexPath) as? TableViewCellRegisterList {
                let favorite = item.favorites[indexPath.row]
                showCell(cell: cell, rowData: favorite, index: indexPath.row)
                return cell
            }
        case .nonFavorite:
            if let item = item as? ProfileViewModelNonFavoriteItem, let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellRegisterList.identifier, for: indexPath) as? TableViewCellRegisterList {
                let nonFavorite = item.nonFavorites[indexPath.row]
                showCell(cell: cell, rowData: nonFavorite, index: indexPath.row)
                return cell
            }
        }
        return UITableViewCell()

    }
    
    func showCell(cell: TableViewCellRegisterList, rowData: GeneralInfo, index: Int) {
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
        return viewModel?.items[section].titleSection
    }
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel?.items[indexPath.section]
        var selectedRowData : GeneralInfo?
        if let item = selectedItem as? ProfileViewModelFavoriteItem {
            selectedRowData = item.favorites[indexPath.row]
        }
        if let item = selectedItem as? ProfileViewModelNonFavoriteItem {
            selectedRowData = item.nonFavorites[indexPath.row]
        }
        if selectedRowData != nil {
            performSegue(withIdentifier: "segue_to_detail", sender: selectedRowData)
        }
    }

}


extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: nil)
        
        if let controller = segue.destination as? DetailViewController {
            controller.delegate = self
            if let object = sender as? GeneralInfo {
                controller.userInfo = object
            }
        }
   }
}


extension ListViewController: DetailViewControllerDelegate {
    func starDidChangedDelegate(_ value: Bool) {
        print("new value of star: \(value)")
    }
    
    
}

