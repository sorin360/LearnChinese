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
    
    @IBOutlet weak var pinyinLabel: UILabel!

    @IBOutlet weak var hanziButton: UIButton!
    
    @IBOutlet weak var translationLabel: UILabel!
    

    var knownWords: [Words] = []
  
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet weak var chart: Chart!
    
    let sideSelectorHeight: CGFloat = 0
    
   
    override func viewDidLoad() {
      
   
        let lastDaysScores = Scores.getLast7DaysScores()
        var data: [(x: Double, y: Double)] = []
        for index in 0...6 {
            data += [(x: Double(index), y: Double(lastDaysScores[6 - index].value))]
        }

        let series = ChartSeries(data: data)
        series.area = true

        chart.xLabels = [6, 0, 1, 2, 3, 4, 5]
        
        var labelsAsString: [String] = []
       
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        for index in 0...6 {
            labelsAsString += [formatter.string(from:  Calendar.current.date(byAdding: .day, value: index, to: Date())!).prefix(3).description]
        }
  
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
      

        chart.backgroundColor = UIColor.white
        chart.add(series)
        
      //  self.view.addSubview(chart.view
        
      
    
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateKnownWords()
         setCharacterOfTheDay()
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
        
        if segue.identifier == "wordOfTheDay" {
            if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                destination.words = [Words.getTheWordOfTheDay()!]
            }
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
