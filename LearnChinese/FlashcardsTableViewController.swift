//
//  FlashcardsTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 03/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class FlashcardsTableViewController: UITableViewController {

    var flshcardsBunchList = ["list1", "list2", "list3"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flshcardsBunchList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcardsBunchCell", for: indexPath)
        cell.textLabel?.text = flshcardsBunchList[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   performSegue(withIdentifier: "flashCards", sender: tableView)
      //  print(flshcardsBunchList[indexPath.row])
    }
   

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            flshcardsBunchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        if let selectedCell = sender as? UITableViewCell {
            if let selectedCellIndex = tableView.indexPath(for: selectedCell) {
                print(selectedCellIndex.row)
            }
          
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            flshcardsBunchList = ["list1", "list2", "list3"]
            tableView.reloadData()
            addButton.isEnabled = true
        default:
            flshcardsBunchList = ["hsk 1", "hsk 2", "hsk 3"]
            tableView.reloadData()
            addButton.isEnabled = false
        }
    }
    
}
