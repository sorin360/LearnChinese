//
//  PracticeManagerViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 31/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeManagerViewController: UIViewController  {
    
    var practiceTranslateSentence: PracticeTranslateSentence?
    var practiceTranslateWord: PracticeTranslateWord?
    var practice = Practice()
    let destinationPracticeTranslateWord = PracticeTranslateWordViewController()
    let destinationPracticeTranslateSentence = PracticeTranslateSentenceViewController()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
      
        view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        let curentIndex = Float((practiceTranslateWord?.curentWordIndex ?? 0) + (practiceTranslateSentence?.curentSentenceIndex ?? 0))
        let totalCounter = Float((practiceTranslateWord?.words.count ?? 0) + (practiceTranslateSentence?.sentences.count ?? 0))
        practice.progressStatus = curentIndex / totalCounter
        
        practiceTranslateWord?.practice = practice
        practiceTranslateSentence?.practice = practice
        
        destinationPracticeTranslateWord.lifeStatus = practice.lifeStatus
        destinationPracticeTranslateSentence.lifeStatus = practice.lifeStatus
        
        destinationPracticeTranslateWord.practiceTranslateWord = practiceTranslateWord
        destinationPracticeTranslateSentence.practiceTranslateSentence = practiceTranslateSentence
        
        
      //  destination.practiceTranslateWord = practiceTranslateWord
        
       // navigationController?.pushViewController(destination, animated: true)
        
        if (practiceTranslateSentence?.sentences.count)! > 0 {
            if (practiceTranslateWord?.words.count)! > 0 {
                if Bool.random() {
                   navigationController?.pushViewController(destinationPracticeTranslateSentence, animated: false)
                } else {
                    navigationController?.pushViewController(destinationPracticeTranslateWord, animated: false)
                }
            } else {
                navigationController?.pushViewController(destinationPracticeTranslateSentence, animated: false)
            }
        } else {
            if (practiceTranslateWord?.words.count)! > 0 {
                navigationController?.pushViewController(destinationPracticeTranslateWord, animated: false)
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
