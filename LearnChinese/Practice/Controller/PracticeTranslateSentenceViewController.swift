//
//  PracticeTranslateSentenceViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeTranslateSentenceViewController: PracticeViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var practiceTranslateSentence: PracticeTranslateSentence? //model

    
    var contentCollectionOne:[String] = [] {
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
  

    var contentCollectionTwo:[String] = []
 
    var colectionViewOne: UICollectionView! {
        didSet{
            colectionViewOne.dataSource = self
            colectionViewOne.delegate = self
            colectionViewOne.dragDelegate = self
            colectionViewOne.dragInteractionEnabled = true
            colectionViewOne.dropDelegate = self
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
            swipeGesture.direction = .down
            colectionViewOne.addGestureRecognizer(swipeGesture)
            swipeGesture.delegate = self
            let alignedFlowLayout = LeftAlignedCollectionViewFlowLayout()
            alignedFlowLayout.minimumInteritemSpacing = 1
            alignedFlowLayout.minimumLineSpacing = 1
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
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
            swipeGesture.direction = .up
            colectionViewTwo.addGestureRecognizer(swipeGesture)
            colectionViewTwo.backgroundColor = UIColor.white
            swipeGesture.delegate = self
        }
    }
    
    @objc func checkButtonAction() {
        
       
        
        let checkResult = practiceTranslateSentence?.check(theAnswer: contentCollectionOne)
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
 
               // self.scoreButton.title = "score: " + (self.practiceTranslateSentence?.getScore() ?? "00")
                if self.practiceTranslateSentence?.practice?.progressStatus == 1.0 {
                    
                    self.showMessageDialog(title: "Congratulations!!!",
                                           subtitle: "Your score is \(self.practiceTranslateSentence?.getScore() ?? "0")",
                        actionTitle: "OK", cancelActionTitle: nil)
                    { () in
                   
                        let score = Int(self.practiceTranslateSentence?.getScore() ?? "0") ?? 0
                        let date = Date().stripTime()
                        
                        Scores.update(with: score, at: date)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    self.navigationController?.popViewController(animated: false)
                    /*
                    self.loadModel()
                    self.colectionViewOne.reloadData()
                    self.colectionViewTwo.reloadData()*/
                }
            }
            
        } else {
           // self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
               lifeStatus -= 1
            practiceTranslateSentence?.practice?.lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                    if self.practiceTranslateSentence?.practice?.progressStatus == 1.0  {
                        self.showMessageDialog(title: "Congratulations!!!",
                                               subtitle: "Your score is \((checkResult?.1)!)",
                            actionTitle: "OK", cancelActionTitle: nil)
                        { () in
                            let score = Int(self.practiceTranslateSentence?.getScore() ?? "0") ?? 0
                            let date = Date().stripTime()
                            
                            Scores.update(with: score, at: date)
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                    else { /*
                        self.loadModel()
                        self.colectionViewOne.reloadData()
                        self.colectionViewTwo.reloadData()
 */                     self.contentCollectionOne = []
                        self.navigationController?.popViewController(animated: false)
                    }
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
        
       
        
        if (practiceTranslateSentence?.sentences.count)! > 0 {
            loadModel()
            if !(textForTranslation.text?.containsChineseCharacters)! {
                speakerButton.isHidden = true
            } else {
                speakerButton.isHidden = false
            }
        } else {

                self.navigationController?.popViewController(animated: false)
            
        }
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
   
        self.colectionViewOne = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        self.colectionViewOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colectionViewOne)
        colectionViewOne.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        colectionViewOne.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8.0).isActive = true
        colectionViewOne.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        colectionViewOne.topAnchor.constraint(greaterThanOrEqualTo: textForTranslation.bottomAnchor, constant: 8.0).isActive = true
        colectionViewOne.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
        

        self.colectionViewTwo = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        colectionViewTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colectionViewTwo)
        colectionViewTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        colectionViewTwo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        colectionViewTwo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        colectionViewTwo.topAnchor.constraint(equalTo: colectionViewOne.bottomAnchor, constant: 8.0).isActive = true
        colectionViewTwo.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
        
        view.addSubview(checkButton)
        checkButton.topAnchor.constraint(equalTo: colectionViewTwo.bottomAnchor, constant: 8.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    
       
        
      
    }
    // MARK: - Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        
        if collectionView == colectionViewOne {
            // return CGSize(width: contentCollectionOne[indexPath.row].count * 15, height: 25)
            label.text = contentCollectionOne[indexPath.row]
        
            return CGSize(width: label.intrinsicContentSize.width + 10, height: 25)
        }
        else {
            label.text = contentCollectionTwo[indexPath.row]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 35)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView == colectionViewOne {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let attributedString = item.dragItem.localObject as? NSAttributedString {
                        collectionView.performBatchUpdates({
                            contentCollectionOne.remove(at: sourceIndexPath.item)
                            contentCollectionOne.insert(attributedString.string, at: destinationIndexPath.item)
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
        if let attributedString = (colectionViewOne.cellForItem(at: indexpath) as? PracticeTranslateSentenceCellCollectionViewCell)?.cellTextLabel.attributedText{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        }
        else  {
            return []
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colectionViewOne {
            return contentCollectionOne.count
        }
        else {
            return contentCollectionTwo.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colectionViewOne {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
            cell.cellTextLabel.text = contentCollectionOne[indexPath.row]
            cell.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
         
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
            cell.cellTextLabel.text = contentCollectionTwo[indexPath.row]
            cell.isUserInteractionEnabled = true
            cell.cellTextLabel.sizeToFit()
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.cellTextLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell
        }
        
    }

 
    @objc func swipeUp(_ recognizer: UITapGestureRecognizer)  {
          print("single tap")
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewTwo)
            if let tapIndexPath = self.colectionViewTwo.indexPathForItem(at: tapLocation) {
                if contentCollectionTwo[tapIndexPath.item].containsChineseCharacters {
                    let utterance = AVSpeechUtterance(string: String(contentCollectionTwo[tapIndexPath.item].split(separator: "/")[0]))
                    utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
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
                    print(contentCollectionOne[tapIndexPath.item])
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
        if Bool.random() {
            textForTranslation.text = practiceTranslateSentence?.getChineseSentence()
            contentCollectionTwo = practiceTranslateSentence?.getShuffledEnglishWords() ?? [" "]
        } else {
            textForTranslation.text = practiceTranslateSentence?.getEnglishSentence()
            contentCollectionTwo = practiceTranslateSentence?.getShuffledChineseWords() ?? [" "]
        }
       // contentCollectionTwo = practiceDragDrop?.getShuffledWords() ?? []
        
        
    }
}
