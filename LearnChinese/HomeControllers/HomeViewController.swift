//
//  HomeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import GameplayKit
import SwiftChart
import CoreData


class HomeViewController: UIViewController, UITabBarControllerDelegate{

    @IBOutlet weak var knownWordsCounterButton: UIButton!
    
    @IBOutlet weak var pinyinLabel: UILabel!  {
        didSet {
            pinyinLabel.backgroundColor = .clear
            pinyinLabel.layer.cornerRadius = 15
            pinyinLabel.layer.borderWidth = 2
            pinyinLabel.layer.borderColor = UIColor.red.cgColor
        }
    }

    @IBOutlet weak var hanziButton: UIButton! {
        didSet {
            hanziButton.backgroundColor = .clear
            hanziButton.layer.cornerRadius = 15
            hanziButton.layer.borderWidth = 2
            hanziButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @IBOutlet weak var translationLabel: UILabel! 
    
    @IBOutlet weak var chart: Chart!
    
    var knownWords:[Words] = []
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var homeModel = Home()
    
    @IBOutlet weak var settingsButton: UIButton!
        // change background
        // pinyin or hanzi
        // clear score
        //
    
    
    func updateChart(){
        
        let series = homeModel.getChartSeries()
        var weekDays = homeModel.getWeekDaysLabels()
        
        chart.xLabels = [6, 0, 1, 2, 3, 4, 5]
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return weekDays[labelIndex]
        }
        chart.backgroundColor = UIColor.white
        
        chart.add(series)
        
    }
    
    override func viewDidLoad() {
        print("step1")
        setCharacterOfTheDay()
        print("step2")
    
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateChart()
        updateKnownWords()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
   
    func updateKnownWords(){
        knownWords = Words.getKnownWords()
        knownWordsCounterButton.setAttributedTitle(NSAttributedString(string: String(knownWords.count)), for: .normal)
  
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "knownWords" {
            let flashcadsCollectionController = segue.destination as? FlashcardsCollectionViewController
           // flashcadsCollectionController?.words = knownWords
            flashcadsCollectionController?.navigationItem.title = "Well known words"
        }
        
        if segue.identifier == "wordOfTheDay" {
            if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                destination.words = [Words.getTheWordOfTheDay()!]
            }
        }
    }
    
    func setCharacterOfTheDay(){
        
        //TO DO add this in same function with updateView
        let wordOfTheDay = Words.getTheWordOfTheDay()
        pinyinLabel.text = wordOfTheDay?.pinyin
        hanziButton.setTitle(" \(wordOfTheDay?.chinese ?? "--") ", for: .normal)
        translationLabel.text = wordOfTheDay?.english
    }
    
}
