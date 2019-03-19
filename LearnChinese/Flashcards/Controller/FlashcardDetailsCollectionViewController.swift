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
        self.collectionView.register(FlashcardDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "detailsCell")

        self.collectionView.backgroundColor = UIColor.white
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 30
            flowLayout.minimumLineSpacing = 30
        }
        self.collectionView.isPagingEnabled = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
  
        self.collectionView.layoutIfNeeded()
    }
  
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: view.frame.width , height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as! FlashcardDetailsCollectionViewCell
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
