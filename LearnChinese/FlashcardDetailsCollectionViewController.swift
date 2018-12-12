//
//  FlashcardDetailsCollectionViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit


class FlashcardDetailsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    lazy var words: [Words] = []
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidAppear(_ animated: Bool) {
 
        super.viewDidAppear(animated)
        
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //   self.collectionView!.register(FlashcardCollectionViewCell.self, forCellWithReuseIdentifier: "flashcardCell")
        
        // Do any additional setup after loading the view.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
  
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return words.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as! FlashcardDetailsCollectionViewCell
        // if let flashcardCell = cell as? FlashcardCollectionViewCell {
        cell.hanziLabelCollectionCell?.text = words[indexPath.row].chinese ?? ""
        cell.pinyinLabelCollectionCell.text = words[indexPath.row].pinyin ?? ""
        cell.word = words[indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blue.cgColor
        // cell.backgroundColor = UIColor.blue
        // }
        // Configure the cell
        
        return cell
    }
    
  //  override func viewDidLayoutSubviews() {
   //     super.viewDidLayoutSubviews()
  //      collectionView.reloadData()
  //  }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
     //   self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        // Reload here
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
