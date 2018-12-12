//
//  FlashcardsCollectionViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlashcardsCollectionViewController: UICollectionViewController {


    lazy var words: [Words] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
    //   self.collectionView!.register(FlashcardCollectionViewCell.self, forCellWithReuseIdentifier: "flashcardCell")

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
            destination.words = words
        }
        
        if let selectedCell = sender as? FlashcardCollectionViewCell {
            if let selectedCellIndex = collectionView.indexPath(for: selectedCell) {
                if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                    
                    destination.words = words
                    destination.indexPath = selectedCellIndex
        
                    }
                    // TO DO: do not get all the words
                }
            }
            
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

  
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return words.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flashcardCell", for: indexPath) as! FlashcardCollectionViewCell
       // if let flashcardCell = cell as? FlashcardCollectionViewCell {
        cell.hanziLabelCollectionCell?.text = words[indexPath.row].chinese ?? ""
        cell.pinyinLabelCollectionCell.text = words[indexPath.row].pinyin ?? ""
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blue.cgColor
       // cell.backgroundColor = UIColor.blue
       // }
        // Configure the cell
    
        return cell
    }
    
    
  

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
