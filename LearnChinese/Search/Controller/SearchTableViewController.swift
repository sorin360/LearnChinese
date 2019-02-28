//
//  SearchTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 27/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate{

    private var filtered:[Words] = []
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = Constants.searchPlaceholder.rawValue
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.keyboardDismissMode = .onDrag
 
        self.navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = UIColor.green
        self.view.backgroundColor = UIColor.white

    }

    // MARK: - Table view data source

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = Words.search(with: searchText)
        self.tableView.reloadData()
        
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1	
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.hanziLabel.text = filtered[indexPath.row].chinese
        cell.pinyinLabel.text =  filtered[indexPath.row].pinyin
        cell.englishLabel.text = filtered[indexPath.row].english
        
        return cell;
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let destination = FlashcardDetailsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
        destination.words = filtered
        destination.indexPath = indexPath
        navigationController?.pushViewController(destination, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
}
