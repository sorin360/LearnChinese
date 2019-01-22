//
//  SearchTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 27/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate{

    

    let searchController = UISearchController(searchResultsController: nil)
    var filtered:[Words] = []
    
    override func viewDidLoad() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Chinese/English"
         searchBar.showsCancelButton = false
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        super.viewDidLoad()
      
       // tableView.backgroundView = UIImageView(image: image)

    }

    // MARK: - Table view data source

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = Words.search(with: searchText)
            /*data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText)
            return range.location != NSNotFound
        })*/
  
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1	
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filtered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        

            cell.chineseLabel.text = filtered[indexPath.row].chinese
            cell.pinyinLabel.text =  filtered[indexPath.row].pinyin
            cell.englishLabel.text = filtered[indexPath.row].english
        
        return cell;
    }
  
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
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
        if let selectedCell = sender as? UITableViewCell {
            if let selectedCellIndex = tableView.indexPath(for: selectedCell) {
                if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                    destination.words = filtered
                    destination.indexPath = selectedCellIndex
                }
            }
        }
    }
}
