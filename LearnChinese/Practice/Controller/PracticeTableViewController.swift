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
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
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

        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)

    }
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let newData = MyFlashcards.retrieveData()
        self.hidesBottomBarWhenPushed = false
        if newData != myFlshcardsBunchList {
            myFlshcardsBunchList = newData
            self.tableView.reloadData()
            
        }
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
         cell.selectionSwitch.isOn = false
        if indexPath.section > 0 {
           // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
            cell.titleLabel.text = hskBunchList[indexPath.row].level ?? "Unknown"
            if hskFlashcardsSelected.contains(hskBunchList[indexPath.row]) {
                cell.selectionSwitch.isOn = true
            }
          //  return cell
        }
        else {
            //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PracticeTableViewCell
            cell.titleLabel.text = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"
            if myFlashcardsSelected.contains(myFlshcardsBunchList[indexPath.row]) {
                cell.selectionSwitch.isOn = true
            }
           
           // return cell
        }
        cell.selectionSwitch.addTarget(self, action: #selector(toggel(_:)), for: .valueChanged)
       // cell.selectionSwitch.addTarget(self, action: #selector(self.startPracticeAction), for: UIControl.Event.allTouchEvents)
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
                    myFlashcardsSelected.append(self.myFlshcardsBunchList[(indexpath?.row)!])
                    //do something with myflashcards[item] (add in a list and use it to search in db
                } else {
                    myFlashcardsSelected.removeAll(where: {$0.id == self.myFlshcardsBunchList[(indexpath?.row)!].id })
                }
            case 1:
                if cell.selectionSwitch.isOn {
                    hskFlashcardsSelected.append(self.hskBunchList[(indexpath?.row)!])
            
                } else {
                    hskFlashcardsSelected.removeAll(where: {$0.level == self.hskBunchList[(indexpath?.row)!].level})
                }
            default:
                break
            }
        }
        
    }
    var myFlashcardsSelected:[MyFlashcards] = []
    var hskFlashcardsSelected:[HskFlashcards] = []
    
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
       
        present(alert, animated: true, completion: nil)
      
    
        /*
            let allCells = self.tableView.visibleCells
            var myFlashcardsSelected:[MyFlashcards] = []
            var hskFlashcardsSelected:[HskFlashcards] = []
            
            for item in self.myFlshcardsBunchList.indices {
                let cell = allCells[item] as! PracticeTableViewCell
                if cell.selectionSwitch.isOn {
                    myFlashcardsSelected.append(self.myFlshcardsBunchList[item])
                    //do something with myflashcards[item] (add in a list and use it to search in db
                }
            }
            for item in self.hskBunchList.indices {
                let cell = allCells[item + self.myFlshcardsBunchList.count] as! PracticeTableViewCell
                if cell.selectionSwitch.isOn {
                    hskFlashcardsSelected.append(self.hskBunchList[item])
                    //do something with hskBunchList[item]
                }
            }*/
        DispatchQueue.global(qos: .background).async {
            
          
            DispatchQueue.main.async {
                let destination = PracticeManagerViewController()
                
                
                destination.practiceTranslateSentence = PracticeTranslateSentence(myFlashcards: self.myFlashcardsSelected, hskFlashcards: self.hskFlashcardsSelected)
                
                destination.practiceTranslateWord = PracticeTranslateWord(myFlashcards: self.myFlashcardsSelected, hskFlashcards: self.hskFlashcardsSelected)
                
                
                self.hidesBottomBarWhenPushed = true
                destination.practiceTranslateWordViewController = PracticeTranslateWordViewController()
                destination.practiceTranslateSentenceViewController = PracticeTranslateSentenceViewController()
                self.dismiss(animated: true) {
                    self.navigationController?.pushViewController(destination, animated: true)
            
                }
            }
        }
       
       
        
    }
    
   
    
}
