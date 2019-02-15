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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("astaDidLoad\(Date())")
        self.collectionView.register(FlashcardDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "detailsCell")
        
        
        
        self.collectionView.backgroundColor = UIColor.white
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 30
            flowLayout.minimumLineSpacing = 30
        }
        self.collectionView.isPagingEnabled = true
      //
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
  
        self.collectionView.layoutIfNeeded()

    }
    /*(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }*/
    
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
        return CGSize(width: view.frame.width , height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("celll1111\(Date())")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as! FlashcardDetailsCollectionViewCell
        // if let flashcardCell = cell as? FlashcardCollectionViewCell {
       // cell.hanziLabelCollectionCell?.text = words[indexPath.row].chinese ?? ""
        
        
        
        
        if words[indexPath.row].veryKnown{
            cell.layer.borderColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)])
        }
        else if words[indexPath.row].myLibraries != nil {
            cell.layer.borderColor = UIColor.red.cgColor
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        } else {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        }
        
        
        
        
        cell.pinyinLabelCollectionCell.text = words[indexPath.row].pinyin ?? ""
        cell.translationLabelColectionCell.text = words[indexPath.row].english ?? ""
        cell.word = words[indexPath.row]
        if words[indexPath.row].veryKnown {
            cell.iKnowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I don't know it"), for: .normal)
        }
        else {
            cell.iKnowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I know it"), for: .normal)
        }
        if words[indexPath.row].myLibraries != nil {
            cell.addToLibraryButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "Remove from library"), for: .normal)
        }
        else {
            cell.addToLibraryButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "Add to library"), for: .normal)
        }
        cell.layer.cornerRadius = 25.0
        cell.layer.borderWidth = 1.0
       // cell.layer.borderColor = UIColor.blue.cgColor
        // cell.backgroundColor = UIColor.blue
        // }
        // Configure the cell
        print("celll222\(Date())")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         print("astacollectionView\(Date())")
        return 0
    }

  
  //  override func viewDidLayoutSubviews() {
   //     super.viewDidLayoutSubviews()
  //      collectionView.reloadData()
  //  }

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
