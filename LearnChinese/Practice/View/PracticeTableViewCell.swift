//
//  PracticeTableViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 15/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {

    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectionSwitch: UISwitch = {
        var sSwitch = UISwitch()
        sSwitch.translatesAutoresizingMaskIntoConstraints = false
        return sSwitch
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(titleLabel)
        self.addSubview(selectionSwitch)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       // titleLabel.rightAnchor.constraint(equalTo: selectionSwitch.leftAnchor, constant: 20.0).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
        selectionSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
        selectionSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
