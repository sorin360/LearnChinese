//
//  SearchTableViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 13/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
