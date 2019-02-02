//
//  PracticeTranslateWordViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 31/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeTranslateWordViewController: PracticeViewController, UITableViewDelegate, UITableViewDataSource {
    
    var practiceTranslateWord: PracticeTranslateWord?
    
    var selectedIndex: Int = 0
    
    var tableViewContent: [String] = []
    
    var tableView: UITableView! {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    func loadModel(){
        //  textForTranslation.text = practiceDragDrop?.getSentence().english ?? "missing sentence"
        tableViewContent = []
        if Bool.random() {
            textForTranslation.text = practiceTranslateWord?.getChineseWord()
            tableViewContent = practiceTranslateWord?.getShuffledEnglishWords() ?? [" "]
            
        } else {
            textForTranslation.text = practiceTranslateWord?.getEnglishWord()
            tableViewContent = practiceTranslateWord?.getShuffledChineseWords() ?? [" "]
        }
        self.tableView.reloadData()
        // contentCollectionTwo = practiceDragDrop?.getShuffledWords() ?? []
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = tableViewContent[indexPath.row] 
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableViewContent[indexPath.row].containsChineseCharacters {
            let utterance = AVSpeechUtterance(string:tableViewContent[indexPath.row])
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            utterance.rate = 0.5
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
        checkButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        checkButton.isEnabled = true
        
        selectedIndex = indexPath.row
    }
    
    @objc func checkButtonAction() {
        

        
        let checkResult = practiceTranslateWord?.check(theAnswer: tableViewContent[selectedIndex])
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
                
              //  self.scoreButton.title = "score: " + (self.practiceTranslateWord?.getScore() ?? "00")
                if self.practiceTranslateWord?.practice?.progressStatus == 1.0 {
                    
                    self.showMessageDialog(title: "Congratulations!!!",
                                           subtitle: "Your score is \(self.practiceTranslateWord?.getScore() ?? "0")",
                        actionTitle: "OK", cancelActionTitle: nil)
                    { () in
                        
                        let score = Int(self.practiceTranslateWord?.getScore() ?? "0") ?? 0
                        let date = Date().stripTime()
                        
                        Scores.update(with: score, at: date)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                else {
                    /*
                    self.loadModel()
                    self.tableView.reloadData()
                    self.tableView.reloadData()*/
                    self.navigationController?.popViewController(animated: false)
                }
            }
            
        } else {
           // self.scoreButton.title = "score: " + (practiceTranslateWord?.getScore() ?? "00")
            lifeStatus -= 1
            practiceTranslateWord?.practice?.lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                    if self.practiceTranslateWord?.practice?.progressStatus == 1.0 {
                        self.showMessageDialog(title: "Congratulations!!!",
                                               subtitle: "Your score is \((checkResult?.1)!)",
                            actionTitle: "OK", cancelActionTitle: nil)
                        { () in
                            let score = Int(self.practiceTranslateWord?.getScore() ?? "0") ?? 0
                            let date = Date().stripTime()
                            
                            Scores.update(with: score, at: date)
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                    else {
                        self.navigationController?.popViewController(animated: false)

                    }
                default:
                    self.progressView.progress = self.practiceTranslateWord?.practice?.progressStatus ?? 0.0
                    
                    self.scoreButton.title = "score: " + (self.practiceTranslateWord?.getScore() ?? "00")
                    
                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
        
        
        
        progressView.progress = (practiceTranslateWord?.practice?.progressStatus) ?? 0
        self.scoreButton.title = "score: " + (practiceTranslateWord?.getScore() ?? "00")
        
        if (practiceTranslateWord?.words.count)! > 0 {
            loadModel()
            if !(textForTranslation.text?.containsChineseCharacters)! {
                speakerButton.isHidden = true
            } else {
                speakerButton.isHidden = false
            }
        } else {
            showMessageDialog(title: "Not sentences found",
                              subtitle: "Please select more libraries for prctice",
                              actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       // navigationController?.delegate = self
        checkButton.addTarget(self, action: #selector(self.checkButtonAction), for: UIControl.Event.touchDown)
        
        
        
        self.tableView = UITableView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8.0).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        tableView.topAnchor.constraint(equalTo: textForTranslation.bottomAnchor, constant: 8.0).isActive = true
        
       
        
        view.addSubview(checkButton)
        checkButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        
        
        
    }
  

}
