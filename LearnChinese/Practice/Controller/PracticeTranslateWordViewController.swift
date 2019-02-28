//
//  PracticeTranslateWordViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 31/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTranslateWordViewController: PracticeViewController, UITableViewDelegate, UITableViewDataSource {
    
    var practiceTranslateWord: PracticeTranslateWord?
    
    var selectedIndex: Int = 0
    
    var tableViewContent: [WordPracticeModel] = []
    
    var tableView: UITableView! {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    func loadModel(){
        tableViewContent = []
        if Bool.random() {
            chineseSentence = true
            contentTextForTranslationCollection = [practiceTranslateWord?.getChineseWord() ?? WordPracticeModel(wordText: "", pinyin: "")]
            tableViewContent = practiceTranslateWord?.getShuffledEnglishWords() ?? []
            
        } else {
            chineseSentence = false
            contentTextForTranslationCollection = [practiceTranslateWord?.getEnglishWord() ?? WordPracticeModel(wordText: "", pinyin: "")]
            tableViewContent = practiceTranslateWord?.getShuffledChineseWords() ?? []
        }
        self.tableView.reloadData()
        self.textForTranslationCollectionView.reloadData()
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
        
        cell!.textLabel?.text = tableViewContent[indexPath.row].wordText
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        cell!.textLabel?.textColor = UIColor.blue
        cell!.detailTextLabel?.text = tableViewContent[indexPath.row].pinyin
        cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bgColorView.layer.cornerRadius = 20
        cell!.selectedBackgroundView = bgColorView
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        checkButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        checkButton.isEnabled = true
      
        DispatchQueue.global(qos: .background).async {
            if self.tableViewContent[indexPath.row].wordText.containsChineseCharacters {
                self.tableViewContent[indexPath.row].wordText.speak()
            }
        }
        selectedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    @objc func checkButtonAction() {
        
        let checkResult = practiceTranslateWord?.check(theAnswer: tableViewContent[selectedIndex].wordText)
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
                self.contentTextForTranslationCollection = []
                self.textForTranslationCollectionView.reloadData()
                self.navigationController?.popViewController(animated: false)
                
            }
            
        } else {
           // self.scoreButton.title = "score: " + (practiceTranslateWord?.getScore() ?? "00")
            lifeStatus -= 1
            practiceTranslateWord?.practice?.lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                    self.navigationController?.popViewController(animated: false)
                case "Retry":
                    self.progressView.progress = self.practiceTranslateWord?.practice?.progressStatus ?? 0.0
                    self.scoreButton.title = "score: " + (self.practiceTranslateWord?.getScore() ?? "00")
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
        
        checkButton.backgroundColor = .clear
        checkButton.isEnabled = false
        
        progressView.progress = (practiceTranslateWord?.practice?.progressStatus) ?? 0
        self.scoreButton.title = "score: " + (practiceTranslateWord?.getScore() ?? "00")
        
        loadModel()
    }
    
    @objc func speakerButtonAction() {
        self.practiceTranslateWord?.getCorectAnswerInChinese().speak()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkButton.addTarget(self, action: #selector(self.checkButtonAction), for: UIControl.Event.touchDown)
        
        speakerButton.addTarget(self, action: #selector(self.speakerButtonAction), for: UIControl.Event.touchDown)
        
        self.tableView = UITableView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
       
        tableView.isScrollEnabled = false
       
        
        view.addSubview(checkButton)
        checkButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
