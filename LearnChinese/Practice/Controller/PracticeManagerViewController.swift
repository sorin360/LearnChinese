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
    var practiceTranslateWordViewController: PracticeTranslateWordViewController!
    var practiceTranslateSentenceViewController: PracticeTranslateSentenceViewController!
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        let curentIndex = Float((practiceTranslateWord?.curentWordIndex ?? 0) + (practiceTranslateSentence?.curentSentenceIndex ?? 0))
        let totalCounter = Float((practiceTranslateWord?.words.count ?? 0) + (practiceTranslateSentence?.sentences.count ?? 0))
        practice.progressStatus = curentIndex / totalCounter
        
        practiceTranslateWord?.practice = practice
        practiceTranslateSentence?.practice = practice
        
        practiceTranslateWordViewController.lifeStatus = practice.lifeStatus
        practiceTranslateSentenceViewController.lifeStatus = practice.lifeStatus
        
        practiceTranslateWordViewController.practiceTranslateWord = practiceTranslateWord
        practiceTranslateSentenceViewController.practiceTranslateSentence = practiceTranslateSentence
        
        
      //  destination.practiceTranslateWord = practiceTranslateWord
        
       // navigationController?.pushViewController(destination, animated: true)
        
        if (practiceTranslateSentence?.sentences.count)! > 0 && (practiceTranslateSentence?.sentences.count)! > (practiceTranslateSentence?.curentSentenceIndex)! {
            if (practiceTranslateWord?.words.count)! > 0 && (practiceTranslateWord?.words.count)! > (practiceTranslateWord?.curentWordIndex)!{
                if Bool.random() {
                   navigationController?.pushViewController(practiceTranslateSentenceViewController, animated: false)
                } else {
                    navigationController?.pushViewController(practiceTranslateWordViewController, animated: false)
                }
            } else {
                navigationController?.pushViewController(practiceTranslateSentenceViewController, animated: false)
            }
        } else {
            if (practiceTranslateWord?.words.count)! > 0 && (practiceTranslateWord?.words.count)! > (practiceTranslateWord?.curentWordIndex)!{
                navigationController?.pushViewController(practiceTranslateWordViewController, animated: false)
            } else {
                self.showMessageDialog(title: "Congratulations!!!",
                                       subtitle: "Your score is \(self.practiceTranslateWord?.getScore() ?? "0")",
                    actionTitle: "OK", cancelActionTitle: nil)
                { () in
                    
                    let score = Int(self.practiceTranslateSentence?.getScore() ?? "0") ?? 0
                    let date = Date().stripTime()
                    
                    Scores.update(with: score, at: date)
                    self.navigationController?.popToRootViewController(animated: true)
                }
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
