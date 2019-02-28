//
//  SettingsTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 29/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var options = ["Feedback", "Help", "Terms of use", "About"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch options[indexPath.row] {
        case "Terms of use":
            guard let url = URL(string: Constants.termsOfUseUrl.rawValue) else { return }
            UIApplication.shared.open(url)
        case "Help":
            guard let url = URL(string: Constants.helpUrl.rawValue) else { return }
            UIApplication.shared.open(url)
        case "About":
            guard let url = URL(string: Constants.helpUrl.rawValue) else { return }
            UIApplication.shared.open(url)
        case "Feedback":
            let email = Constants.feedbackEmail.rawValue
            if let url = URL(string: "mailto:\(email)") {
                // open email app
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      
        let footerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.text = "© 2019 Sorin Lica"
        footerView.textAlignment = .center
        footerView.textColor = UIColor.black
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}
