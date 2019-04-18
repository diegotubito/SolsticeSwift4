//
//  TableViewCellThreeLabel.swift
//  SolsticeSwift4
//
//  Created by David Diego Gomez on 17/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellThreeLabel: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var leftSecondLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
