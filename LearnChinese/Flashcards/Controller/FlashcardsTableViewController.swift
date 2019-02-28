//
//  FlashcardsTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 03/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class FlashcardsTableViewController: UITableViewController {
    

    var myFlshcardsBunchList: [MyLibraries] = []
    var hskFlshcardsBunchList: [HskLibraries] = []
   
    var segmentedControl: UISegmentedControl!
    var addButton: UIBarButtonItem!
    
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hskFlshcardsBunchList = HskLibraries.getHskLibraries()

        
        // setup segmentedControl
        let items = ["My Libraries", "HSKs"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        
        // setup addButton
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        addButton.tintColor = UIColor.green
        navigationItem.rightBarButtonItem = addButton
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         myFlshcardsBunchList = MyLibraries.retrieveData()
         self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return myFlshcardsBunchList.count
        default:
            return hskFlshcardsBunchList.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "flashcardsBunchCell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "flashcardsBunchCell")
        }
        var knownCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var unknownCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var inLibCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            cell!.textLabel?.text = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"

            inLibCountersAttributedString = NSMutableAttributedString(string: "  " + String(myFlshcardsBunchList[indexPath.row].words?.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
          
        default:
            cell!.textLabel?.text = hskFlshcardsBunchList[indexPath.row].level ?? "Unknown"
            knownCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).veryKnown == true }.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)])
            unknownCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).veryKnown == false && ($0 as! Words).myLibraries == nil}.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
            inLibCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).myLibraries != nil }.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }
        
        
        let countersAttributedString = unknownCountersAttributedString
        
        
        countersAttributedString.append(inLibCountersAttributedString)
        countersAttributedString.append(knownCountersAttributedString)
        cell!.detailTextLabel?.attributedText = countersAttributedString
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                MyLibraries.delete(myFlashcards: myFlshcardsBunchList[indexPath.row])
                myFlshcardsBunchList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = FlashcardsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                destination.selectedSegmentIndex = 0
                destination.selectedIndex = indexPath.row
                destination.navigationItem.title = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"
            default:
                destination.selectedSegmentIndex = 1
                destination.selectedIndex = indexPath.row
                destination.navigationItem.title = hskFlshcardsBunchList[indexPath.row].level ?? "Unknown"
                
            }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.pushViewController(destination, animated: true)

    }

    @objc func addButtonAction() {
        showInputDialog(title: "Add library",
                        subtitle: "Please enter the name below.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Name",
                        inputKeyboardType: .alphabet)
        { (input:String?) in
            
                _ = MyLibraries.addLibrary(with: input ?? "Unknown")
                self.myFlshcardsBunchList = MyLibraries.retrieveData()
                self.tableView.reloadData()
        }
    }
    

    
    @objc func segmentChanged() {
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
            addButton.isEnabled = true
        default:
            tableView.reloadData()
            addButton.isEnabled = false
        }
    }
    
}
