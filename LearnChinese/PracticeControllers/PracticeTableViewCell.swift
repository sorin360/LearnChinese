//
//  PracticeTableViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 15/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
