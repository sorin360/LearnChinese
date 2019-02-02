//
//  PracticeTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 14/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTableViewController: UITableViewController, UINavigationControllerDelegate {

    var myFlshcardsBunchList: [MyFlashcards] = []
    var hskBunchList: [HskFlashcards] = []

    var startPracticeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           navigationController?.delegate = self
        self.tableView.register(PracticeTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        hskBunchList = HskFlashcards.retrieveData() 

        startPracticeButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.startPracticeAction))
        
        navigationItem.rightBarButtonItem = startPracticeButton
    
       
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Select libraries for practice"
        
        navigationController?.navigationBar.tintColor = UIColor.green


    }
    override func viewWillAppear(_ animated: Bool) {
        let newData = MyFlashcards.retrieveData()
        self.hidesBottomBarWhenPushed = false
        if newData != myFlshcardsBunchList {
            myFlshcardsBunchList = newData
            self.tableView.reloadData()
            
        }
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
  /*  override var prefersStatusBarHidden: Bool {
        return true
    }
    */
    // MARK: - Table view data source


    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return myFlshcardsBunchList.count
        default:
            return hskBunchList.count
        }

    }

 
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
            cell.titleLabel.text = hskBunchList[indexPath.row].level ?? "Unknown"
            cell.selectionSwitch.isOn = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
            cell.titleLabel.text = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"
            cell.selectionSwitch.isOn = false
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.backgroundColor = #colorLiteral(red: 0.7261344178, green: 0.9914394021, blue: 1, alpha: 1)
        switch section {
        case 0:
            if myFlshcardsBunchList.count == 0 {
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
        let allCells = tableView.visibleCells
        var myFlashcardsSelected:[MyFlashcards] = []
        var hskFlashcardsSelected:[HskFlashcards] = []
        
        for item in myFlshcardsBunchList.indices {
            let cell = allCells[item] as! PracticeTableViewCell
            if cell.selectionSwitch.isOn {
                myFlashcardsSelected.append(myFlshcardsBunchList[item])
                //do something with myflashcards[item] (add in a list and use it to search in db
            }
        }
        for item in hskBunchList.indices {
            let cell = allCells[item+myFlshcardsBunchList.count] as! PracticeTableViewCell
            if cell.selectionSwitch.isOn {
                hskFlashcardsSelected.append(hskBunchList[item])
                //do something with hskBunchList[item]
            }
        }
        let destination = PracticeManagerViewController()
 
     
        destination.practiceTranslateSentence = PracticeTranslateSentence(myFlashcards: myFlashcardsSelected, hskFlashcards: hskFlashcardsSelected)

        destination.practiceTranslateWord = PracticeTranslateWord(myFlashcards: myFlashcardsSelected, hskFlashcards: hskFlashcardsSelected)
        
        self.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
   
    
}