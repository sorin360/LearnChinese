//
//  PracticeTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 14/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTableViewController: UITableViewController, UINavigationControllerDelegate {

    private var myLibraries: [MyLibraries] = []
    private var hskLibraries: [HskLibraries] = []

    private var myFlashcardsSelected:[MyLibraries] = []
    private var hskFlashcardsSelected:[HskLibraries] = []
    
    private let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        self.tableView.register(PracticeTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        hskLibraries = HskLibraries.getHskLibraries()

        setUpNavigationBar()

        setUpAlertDialog()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        
        let newData = MyLibraries.retrieveData()
        if newData != myLibraries {
            myLibraries = newData
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return myLibraries.count
        default:
            return hskLibraries.count
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
        cell.selectionSwitch.isOn = false
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = myLibraries[indexPath.row].name ?? "Unknown"
            if myFlashcardsSelected.contains(myLibraries[indexPath.row]) {
                cell.selectionSwitch.isOn = true
            }
        case 1:
            cell.titleLabel.text = hskLibraries[indexPath.row].level ?? "Unknown"
            if hskFlashcardsSelected.contains(hskLibraries[indexPath.row]) {
                cell.selectionSwitch.isOn = true
            }
        default:
            break
        }
        
        cell.selectionSwitch.addTarget(self, action: #selector(toggel(_:)), for: .valueChanged)
        return cell
    }
    
    @objc func toggel(_ sender: UISwitch) {
        let switchInCell = sender
        let cell = switchInCell.superview as? PracticeTableViewCell
        if let cell = cell {
            let indexpath = tableView.indexPath(for: cell)
            switch indexpath?.section {
            case 0:
                if cell.selectionSwitch.isOn {
                    myFlashcardsSelected.append(self.myLibraries[(indexpath?.row)!])
                } else {
                    myFlashcardsSelected.removeAll(where: {$0.id == self.myLibraries[(indexpath?.row)!].id })
                }
            case 1:
                if cell.selectionSwitch.isOn {
                    hskFlashcardsSelected.append(self.hskLibraries[(indexpath?.row)!])
                } else {
                    hskFlashcardsSelected.removeAll(where: {$0.level == self.hskLibraries[(indexpath?.row)!].level})
                }
            default:
                break
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel()
        headerLabel.backgroundColor = #colorLiteral(red: 0.7261344178, green: 0.9914394021, blue: 1, alpha: 1)
        switch section {
        case 0:
            if myLibraries.count == 0 {
                headerLabel.text = " You haven't create your own libraries yet"
            } else {
                headerLabel.text = " My libraries"
            }
        default:
            headerLabel.text = " HSK"
        }
        return headerLabel
    }

    
    @objc func startPracticeAction(){
       
        present(alert, animated: true, completion: nil)
      
        let destination = PracticeManagerViewController()
        
        destination.practiceTranslateSentence = PracticeTranslateSentence(myFlashcards: self.myFlashcardsSelected, hskFlashcards: self.hskFlashcardsSelected)
        destination.practiceTranslateWord = PracticeTranslateWord(myFlashcards: self.myFlashcardsSelected, hskFlashcards: self.hskFlashcardsSelected)
        
        destination.practiceTranslateWordViewController = PracticeTranslateWordViewController()
        destination.practiceTranslateSentenceViewController = PracticeTranslateSentenceViewController()
        
        self.dismiss(animated: true) {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func setUpNavigationBar(){
        
        let startPracticeButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.startPracticeAction))
        
        navigationItem.rightBarButtonItem = startPracticeButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Select libraries for practice"
        
        navigationController?.navigationBar.tintColor = UIColor.green
    }
    
    func setUpAlertDialog() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
    }
}
