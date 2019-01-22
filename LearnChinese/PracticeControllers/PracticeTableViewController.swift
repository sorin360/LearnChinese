//
//  PracticeTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 14/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTableViewController: UITableViewController {

    var myFlshcardsBunchList: [MyFlashcards] = []
    var hskBunchList: [HskFlashcards] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // myFlshcardsBunchList = MyFlashcards.retrieveData()
        hskBunchList = HskFlashcards.retrieveData() as! [HskFlashcards]
   //     setupNavigationBarItems()

    }
    override func viewWillAppear(_ animated: Bool) {
        let newData = MyFlashcards.retrieveData() as! [MyFlashcards]
        self.hidesBottomBarWhenPushed = false
        if newData != myFlshcardsBunchList {
            myFlshcardsBunchList = newData
            self.tableView.reloadData()
            
        }
        super.viewWillAppear(animated)
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
        headerLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.2)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
        if let destination = segue.destination as? PracticeDragDropViewController {
            destination.practiceDragDrop = PracticeDragDrop(myFlashcards: myFlashcardsSelected, hskFlashcards: hskFlashcardsSelected)
        }
        self.hidesBottomBarWhenPushed = true
    }
}
