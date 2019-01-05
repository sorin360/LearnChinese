//
//  HomeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import GameplayKit


class HomeViewController: UIViewController, UITabBarControllerDelegate{

    
    @IBOutlet weak var knownWordsCounterButton: UIButton!
    
    @IBOutlet weak var pinyinLabel: UILabel!

    @IBOutlet weak var hanziButton: UIButton!
    
    @IBOutlet weak var translationLabel: UILabel!
    
    var knownWords: [Words] = []
    
    
 
    override func viewDidLoad() {
      //  self.tabBarController?.delegate = self
        updateKnownWords()
        setCharacterOfTheDay()
        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateKnownWords()
      //  navigationController?.popToRootViewController(animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

/*
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if viewController is HomeViewController {
            print("First tab")
        } else if viewController is PracticeTableViewController {
            print("Second tab")
        }
        if tabBarIndex == 0 {
            self.updateKnownWords()
        }
    }
    */
   
    func updateKnownWords(){
        knownWords = Words.getKnownWords()
        knownWordsCounterButton.setAttributedTitle(NSAttributedString(string: String(knownWords.count)), for: .normal)
       // knownWordsCounterButton.setAttributedTitle(NSAttributedString(string: String(Sentences.retrieveData())), for: .normal)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "knownWords" {
            let flashcadsCollectionController = segue.destination as? FlashcardsCollectionViewController
            flashcadsCollectionController?.words = knownWords
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func setCharacterOfTheDay(){
        
        //TO DO add this in same function with updateView
        let wordOfTheDay = Words.getTheWordOfTheDay()
        pinyinLabel.text = wordOfTheDay?.pinyin
        hanziButton.setTitle(wordOfTheDay?.chinese, for: .normal)
        translationLabel.text = wordOfTheDay?.english
    }
    
}
