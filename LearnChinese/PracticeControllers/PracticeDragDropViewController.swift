//
//  PracticeDragDropViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeDragDropViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate{
    
    var practiceDragDrop: PracticeDragDrop?
    var contentCollectionOne:[String] = []
    var contentCollectionTwo:[String] = []
    
    @IBOutlet weak var textForTranslation: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet{
            progressView.setProgress(0.0, animated: true)
        }
    }
    
    @IBAction func endPracticeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var colectionViewOne: UICollectionView! {
        didSet{
            colectionViewOne.dataSource = self
            colectionViewOne.delegate = self
            colectionViewOne.dragDelegate = self
            colectionViewOne.dragInteractionEnabled = true
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
            swipeGesture.direction = .down
            colectionViewOne.addGestureRecognizer(swipeGesture)
            swipeGesture.delegate = self
        }
    }
    
    @IBOutlet weak var colectionViewTwo: UICollectionView! {
        didSet{
            colectionViewTwo.dataSource = self
            colectionViewTwo.delegate = self
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
            swipeGesture.direction = .up
            colectionViewTwo.addGestureRecognizer(swipeGesture)
            swipeGesture.delegate = self
        }
    }
    
    @IBAction func checkButton(_ sender: Any) {
        
        progressView.progress = Float(practiceDragDrop?.curentSentenceIndex ?? 0) / Float(practiceDragDrop?.sentences.count ?? 0)
        
        let checkResult = practiceDragDrop?.check(theAnswer: contentCollectionOne)
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK")
            { (input:String?) in
                
 
                self.scoreLabel.text = "score: " + (self.practiceDragDrop?.getScore() ?? "00")
                if self.practiceDragDrop?.curentSentenceIndex == self.practiceDragDrop?.sentences.count {
                    
                    self.showMessageDialog(title: "Congratulations!!!",
                                           subtitle: "Your score is \(self.practiceDragDrop?.getScore() ?? "0")",
                        actionTitle: "OK")
                    { (input:String?) in
                   
                        let score = Int(self.practiceDragDrop?.getScore() ?? "0") ?? 0
                        let date = Date().stripTime()
                        
                        Scores.update(with: score, at: date)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    self.loadModel()
                    self.colectionViewOne.reloadData()
                    self.colectionViewTwo.reloadData()
                }
            }
            
        } else {
            self.scoreLabel.text = "score: " + (practiceDragDrop?.getScore() ?? "00")
            
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                    if self.practiceDragDrop?.curentSentenceIndex == self.practiceDragDrop?.sentences.count {
                        self.showMessageDialog(title: "Congratulations!!!",
                                               subtitle: "Your score is \((checkResult?.1)!)",
                            actionTitle: "OK")
                        { (input:String?) in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        self.loadModel()
                        self.colectionViewOne.reloadData()
                        self.colectionViewTwo.reloadData()
                    }
                default:
                    self.contentCollectionTwo.append(contentsOf: self.contentCollectionOne)
                    self.contentCollectionOne = []
                    self.colectionViewOne.reloadData()
                    self.colectionViewTwo.reloadData()
                }
            }
        }
    }
    // MARK: - Configurations
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        let image = #imageLiteral(resourceName: "background")
        self.view.backgroundColor = UIColor(patternImage: image)
        
        if (practiceDragDrop?.sentences.count)! > 0 {
            loadModel()
        } else {
            showMessageDialog(title: "Not sentences found",
                              subtitle: "Please select more words",
                              actionTitle: "OK")
            { (input:String?) in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        super.viewDidLoad()
    }
    // MARK: - Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colectionViewOne {
             return CGSize(width: contentCollectionOne[indexPath.row].count * 20, height: 40)
        }
        else {
            return CGSize(width: contentCollectionTwo[indexPath.row].count * 20, height: 40)
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
        if let attributedString = ( colectionViewOne.cellForItem(at: indexpath) as? PracticeDragDropCellCollectionViewCell)?.cellTextLabel.attributedText{
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionOneCell", for: indexPath) as! PracticeDragDropCellCollectionViewCell
            cell.cellTextLabel.text = contentCollectionOne[indexPath.row]
            cell.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
         
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionOneCell", for: indexPath) as! PracticeDragDropCellCollectionViewCell
            cell.cellTextLabel.text = contentCollectionTwo[indexPath.row]
            cell.isUserInteractionEnabled = true
            cell.cellTextLabel.sizeToFit()

            return cell
        }
        
    }

    
    @objc func swipeUp(_ recognizer: UITapGestureRecognizer)  {
          print("single tap")
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewTwo)
            if let tapIndexPath = self.colectionViewTwo.indexPathForItem(at: tapLocation) {
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
                
                practiceDragDrop?.updateScore(with: -10)
                self.scoreLabel.text = "score: " + (practiceDragDrop?.getScore() ?? "00")
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
    
    
    func loadModel(){
        textForTranslation.text = practiceDragDrop?.getSentence().english ?? "missing sentence"
        contentCollectionOne = []
        contentCollectionTwo = practiceDragDrop?.getShuffledWords() ?? []
    }
}

