//
//  PracticeTranslateSentenceViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeTranslateSentenceViewController: PracticeViewController,   UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
   
    
 
    
    var practiceTranslateSentence: PracticeTranslateSentence? //model

    
    
    var contentCollectionOne:[WordPracticeModel] = [] {
        didSet {
            if !contentCollectionOne.isEmpty {
                checkButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                checkButton.isEnabled = true
                
            } else {
                checkButton.isEnabled = false
                checkButton.backgroundColor = .clear
            }
        }
    }
  

    var contentCollectionTwo:[WordPracticeModel] = []
   
    var colectionViewOne: UICollectionView! {
        didSet{
            colectionViewOne.dataSource = self
            colectionViewOne.delegate = self
            colectionViewOne.dragDelegate = self
            colectionViewOne.dragInteractionEnabled = true
            colectionViewOne.dropDelegate = self
            let pressGesture = UITapGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
           // let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
           // swipeGesture.direction = .down
            pressGesture.numberOfTapsRequired = 1
            colectionViewOne.addGestureRecognizer(pressGesture)
            pressGesture.delegate = self
            let alignedFlowLayout = LeftAlignedCollectionViewFlowLayout()
            alignedFlowLayout.minimumInteritemSpacing = 1
            alignedFlowLayout.minimumLineSpacing = 1.5
            colectionViewOne.collectionViewLayout = alignedFlowLayout
            let backgroundView = StripedView()
            colectionViewOne.backgroundView = backgroundView
            //colectionViewOne.backgroundColor = UIColor.red
        }
    }
    
    var colectionViewTwo: UICollectionView! {
        didSet{
            colectionViewTwo.dataSource = self
            colectionViewTwo.delegate = self
            let pressGesture = UITapGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
           // let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
          //  swipeGesture.direction = .up
            pressGesture.numberOfTapsRequired = 1
            colectionViewTwo.addGestureRecognizer(pressGesture)
            colectionViewTwo.backgroundColor = UIColor.white
            pressGesture.delegate = self
        }
    }
    
    @objc func checkButtonAction() {
        
        var givenAnswer = [String]()
        for index in contentCollectionOne.indices {
            givenAnswer += [contentCollectionOne[index].chinese ]
        }
       
        
        let checkResult = practiceTranslateSentence?.check(theAnswer: givenAnswer)
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
  // self.colectionViewZero.text = ""
              
                    self.navigationController?.popViewController(animated: false)
            
            }
            
        } else {
           // self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
               lifeStatus -= 1
            practiceTranslateSentence?.practice?.lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                   
                
                        self.contentCollectionOne = []
                        self.colectionViewOne.reloadData()
                        self.navigationController?.popViewController(animated: false)
                    
                default:
                    //update progress and score (retry)
                    self.progressView.progress = self.practiceTranslateSentence?.practice?.progressStatus ?? 0.0
                    
                    self.scoreButton.title = "score: " + (self.practiceTranslateSentence?.getScore() ?? "00")
                    
                    self.contentCollectionTwo.append(contentsOf: self.contentCollectionOne)
                    self.contentCollectionOne = []
                    self.colectionViewOne.reloadData()
                    self.colectionViewTwo.reloadData()
                }
            }
            
         
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? PracticeManagerViewController)?.practiceTranslateSentence = practiceTranslateSentence // Here you pass the to your original view controller
    }

    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        

        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
      
     
        if Int((self.practiceTranslateSentence?.practice?.progressStatus)!) == 1 {
            /*
            self.showMessageDialog(title: "Congratulations!!!",
                                   subtitle: "Your score is \(self.practiceTranslateSentence?.getScore() ?? "0")",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
                let score = Int(self.practiceTranslateSentence?.getScore() ?? "0") ?? 0
                let date = Date().stripTime()
                
                Scores.update(with: score, at: date)
                self.navigationController?.popViewController(animated: true)
            }*/
        } else {
            if (practiceTranslateSentence?.sentences.count)! > 0 {
                loadModel()

            } else {

                    self.navigationController?.popViewController(animated: false)
                
            }
        }
    }
    
    @objc func speakerButtonAction() {
        
            let utterance = AVSpeechUtterance(string: practiceTranslateSentence?.getChineseTextOrCorectAnswer() ?? " ")
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            utterance.rate = 0.5
            
            self.synthesizer.stopSpeaking(at: .immediate)
            synthesizer.speak(utterance)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        checkButton.addTarget(self, action: #selector(self.checkButtonAction), for: UIControl.Event.touchDown)
        speakerButton.addTarget(self, action: #selector(self.speakerButtonAction), for: UIControl.Event.touchDown)
        
        self.colectionViewOne = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        self.colectionViewOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colectionViewOne)
        colectionViewOne.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        colectionViewOne.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8.0).isActive = true
        colectionViewOne.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        colectionViewOne.topAnchor.constraint(equalTo: colectionViewZero.bottomAnchor, constant: 8.0).isActive = true
        colectionViewOne.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
        
       // colectionViewZero.bottomAnchor.constraint(equalTo: colectionViewOne.topAnchor, constant: 8.0).isActive = true
       // colectionViewOne.topAnchor.constraint(equalTo: colectionViewZero.bottomAnchor).isActive = true
        self.colectionViewTwo = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        colectionViewTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colectionViewTwo)
        colectionViewTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        colectionViewTwo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        colectionViewTwo.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4).isActive = true
       // constraint.priority = UILayoutPriority(rawValue: 750)
   
        
        colectionViewTwo.topAnchor.constraint(equalTo: colectionViewOne.bottomAnchor, constant: 8.0).isActive = true
        colectionViewTwo.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
        
        view.addSubview(checkButton)
        checkButton.topAnchor.constraint(equalTo: colectionViewTwo.bottomAnchor, constant: 8.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
      //  constraintBottom.priority = UILayoutPriority(rawValue: 1000)
 
        
      
    }
    // MARK: - Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        
        switch collectionView {
        case colectionViewOne:
            if !chineseSentence {
                label.text = contentCollectionOne[indexPath.row].pinyin
                return CGSize(width: label.intrinsicContentSize.width + 10, height: 45)
            } else {
                label.text = contentCollectionOne[indexPath.row].chinese
                return CGSize(width: label.intrinsicContentSize.width + 10, height: 30)
            }
        case colectionViewTwo:
            if !chineseSentence {
                label.text = contentCollectionTwo[indexPath.row].pinyin
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 45)
            } else {
                label.text = contentCollectionTwo[indexPath.row].chinese
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 30)
            }
        default:
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView == colectionViewOne {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let attributedText = item.dragItem.localObject as? NSMutableAttributedString {
                        var texts = attributedText.string.split(separator: "/")
                        let word = WordPracticeModel(chinese: String(texts[0]), pinyin: String(texts[1]))
                        collectionView.performBatchUpdates({
                            contentCollectionOne.remove(at: sourceIndexPath.item)
                            contentCollectionOne.insert(word, at: destinationIndexPath.item)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        })
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }
    
    func dragItem(at indexpath: IndexPath) -> [UIDragItem]{
        if let cell = (colectionViewOne.cellForItem(at: indexpath) as? PracticeTranslateSentenceCellCollectionViewCell){
            let attributedText1 =  cell.chineseLabel.attributedText ?? NSAttributedString(string: "")
            let attributedText2 = cell.pinyinLabel.attributedText ?? NSAttributedString(string: "")
            let attributedTextLim = NSAttributedString(string: "/")
            
            let attributedText = NSMutableAttributedString()
            attributedText.append(attributedText1)
            attributedText.append(attributedTextLim)
            attributedText.append(attributedText2)
            
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedText))
            dragItem.localObject = attributedText
            return [dragItem]
        }
        else  {
            return []
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case colectionViewOne:
            return contentCollectionOne.count
        case colectionViewTwo:
            return contentCollectionTwo.count
        default:
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case colectionViewOne:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
            if chineseSentence {
                cell.chineseLabel.text = contentCollectionOne[indexPath.row].chinese
                cell.pinyinLabel.text = " "
            } else {
                cell.chineseLabel.text = contentCollectionOne[indexPath.row].chinese
                cell.pinyinLabel.text = contentCollectionOne[indexPath.row].pinyin
            }
            // cell.cellTextLabel.text = contentCollectionOne[indexPath.row]
            cell.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
            
            return cell
        case colectionViewTwo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
            if chineseSentence {
                cell.chineseLabel.text = contentCollectionTwo[indexPath.row].chinese
                cell.pinyinLabel.text = " "
            } else {
                cell.chineseLabel.text = contentCollectionTwo[indexPath.row].chinese
                cell.pinyinLabel.text = contentCollectionTwo[indexPath.row].pinyin
            }
            cell.isUserInteractionEnabled = true
            cell.chineseLabel.sizeToFit()
            cell.pinyinLabel.sizeToFit()
            cell.backgroundColor = #colorLiteral(red: 0.867922463, green: 0.867922463, blue: 0.867922463, alpha: 1)
            // cell.chineseLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // cell.pinyinLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell
        default:
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
    }

 
    @objc func swipeUp(_ recognizer: UITapGestureRecognizer)  {
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewTwo)
            if let tapIndexPath = self.colectionViewTwo.indexPathForItem(at: tapLocation) {
                
                if !chineseSentence {
                    let utterance = AVSpeechUtterance(string: contentCollectionTwo[tapIndexPath.item].chinese )
                    utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
                    utterance.rate = 0.5
 
                     self.synthesizer.stopSpeaking(at: .immediate)
                    synthesizer.speak(utterance)
                }
                contentCollectionOne.insert(contentCollectionTwo[tapIndexPath.item], at: IndexPath(item: contentCollectionOne.count, section: 0).item)
                colectionViewOne.reloadData()
                contentCollectionTwo.remove(at: tapIndexPath.item)
                colectionViewTwo.deleteItems(at: [tapIndexPath])
            }
        }
    }
    
    @objc func swipeDown(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewOne)
            if let tapIndexPath = self.colectionViewOne.indexPathForItem(at: tapLocation) {
                  
                    contentCollectionTwo.insert(contentCollectionOne[tapIndexPath.item], at: IndexPath(item: contentCollectionTwo.count, section: 0).item)
                    colectionViewTwo.reloadData()
                    contentCollectionOne.remove(at: tapIndexPath.item)
                    colectionViewOne.deleteItems(at: [tapIndexPath])
                
                practiceTranslateSentence?.updateScore(with: -10)
                self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
            }
        }
    }

    func loadModel(){
      //  textForTranslation.text = practiceDragDrop?.getSentence().english ?? "missing sentence"
        progressView.progress = practiceTranslateSentence?.practice?.progressStatus ?? 0.0
      
        self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
        
        contentCollectionOne = []
        self.colectionViewOne.reloadData()
        if Bool.random() {
            chineseSentence = true
            contentCollectionZero = practiceTranslateSentence?.getChineseSentence() ?? []
            contentCollectionTwo = practiceTranslateSentence?.getShuffledEnglishWords() ?? []
        } else {
            chineseSentence = false
            contentCollectionZero = practiceTranslateSentence?.getEnglishSentence() ?? []
            contentCollectionTwo = practiceTranslateSentence?.getShuffledChineseWords() ?? []
        }
        self.colectionViewTwo.reloadData()
        self.colectionViewZero.reloadData()
       // contentCollectionTwo = practiceDragDrop?.getShuffledWords() ?? []
        
        
    }
}
