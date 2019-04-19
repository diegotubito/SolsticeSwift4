//
//  HomeViewController.swift
//  Solstice
//
//  Created by iMac on 11/04/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitle: UIButton!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //Loader init, used when loading from the internet.
        loaderInitialization()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Home"
        
        titleLabel.alpha = 1
        let titleFrom = view.frame.width
        let titleTo = titleLabel.frame.origin.x
        titleLabel.slide(fromX: titleFrom, toX: titleTo, duration: 0.7)
        
        subTitle.alpha = 1
        let subFrom = -subTitle.frame.width*2
        let subTo = subTitle.frame.origin.x
        subTitle.slide(fromX: subFrom, toX: subTo, duration: 0.7)
    }
    
    func loaderInitialization() {
        //Just change bar colors to blue
        DDBarLoader.color = .blue
    }
    
    @IBAction func startTestButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segue_to_list", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ContactListViewController {
            controller.viewModel = ContactListViewModel(withView: controller, interactor: ServiceManager())
        }
    }
}

