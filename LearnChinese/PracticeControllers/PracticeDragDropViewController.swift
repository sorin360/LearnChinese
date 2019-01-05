//
//  PracticeDragDropViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeDragDropViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var textForTranslation: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet{
            progressView.setProgress(0.0, animated: true)
        }
    }
    
    @IBAction func endPracticeButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    var sentences:[Sentences] = []
    var curentSentenceIndex = 0
    var score = 0
    let tap = UITapGestureRecognizer()
    
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
     //   self.hidesBottomBarWhenPushed = false
        super.viewWillDisappear(animated)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colectionViewOne {
          
             return CGSize(width: temporaryModel1[indexPath.row].count * 20, height: 40)
        }
        else {
           
            return CGSize(width: temporaryModel2[indexPath.row].count * 20, height: 40)
         //   (heightSizes[temporaryModel2[indexPath.row].count > 2 ? 1 : 0])
        }
     //   return CGSize(width: yourDesiredWidth, height: height)
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
        ) {
        if collectionView == colectionViewOne {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let attributedString = item.dragItem.localObject as? NSAttributedString {
                        collectionView.performBatchUpdates({
                            temporaryModel1.remove(at: sourceIndexPath.item)
                            temporaryModel1.insert(attributedString.string, at: destinationIndexPath.item)
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
    
    
    
    @IBOutlet weak var colectionViewOne: UICollectionView! {
        didSet{
            colectionViewOne.dataSource = self
            colectionViewOne.delegate = self
            colectionViewOne.dragDelegate = self
            colectionViewOne.dropDelegate = self
            colectionViewOne.dragInteractionEnabled = true
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
            // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
            //   let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
            // tapGesture.numberOfTapsRequired = 2
            swipeGesture.direction = .down
            colectionViewOne.addGestureRecognizer(swipeGesture)
            swipeGesture.delegate = self
            //  colectionViewOne.time
            
            
        }
    }
    
    @IBOutlet weak var colectionViewTwo: UICollectionView! {
        didSet{
            /*
             colectionViewTwo.dataSource = self
             colectionViewTwo.delegate = self
             colectionViewTwo.dragInteractionEnabled = true
             
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
             //   let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
             colectionViewTwo.addGestureRecognizer(tapGesture)
             tapGesture.delegate = self
             */
            colectionViewTwo.dataSource = self
            colectionViewTwo.delegate = self
            //  colectionViewTwo.dragDelegate = self
            //  colectionViewTwo.dropDelegate = self
            colectionViewTwo.dragInteractionEnabled = true
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
            // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
            //   let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
            // tapGesture.numberOfTapsRequired = 2
            swipeGesture.direction = .up
            colectionViewTwo.addGestureRecognizer(swipeGesture)
            swipeGesture.delegate = self
            //  colectionViewOne.time
            
            
        }
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
    var temporaryModel1:[String] = []
    
    var temporaryModel2:[String] = [] //["bu","ai","ni","baobao","ye","bu","ai","ni","baobao","ye","bu","ai","ni"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colectionViewOne {
            return temporaryModel1.count
        }
        else {
            return temporaryModel2.count
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colectionViewOne {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionOneCell", for: indexPath) as! PracticeDragDropCellCollectionViewCell
            cell.cellTextLabel.text = temporaryModel1[indexPath.row]
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            tap.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tap)
            
            cell.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled = true
         
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionOneCell", for: indexPath) as! PracticeDragDropCellCollectionViewCell
            cell.cellTextLabel.text = temporaryModel2[indexPath.row]
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
            
            cell.addGestureRecognizer(tap)
            
            cell.isUserInteractionEnabled = true
            cell.cellTextLabel.sizeToFit()
            
            // Customize cell height
         //   cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: CGFloat(temporaryModel2[indexPath.row].count * 10), height: cell.frame.size.height)
           
            
            return cell
        }
        
    }
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //    print("add cell")
    }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        //   print("add cell")
    }
    override func viewDidLoad() {
        let image = #imageLiteral(resourceName: "background")
        self.view.backgroundColor = UIColor(patternImage: image)

        if sentences.count > 0 {
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
    
    @objc func singleTap(_ recognizer: UITapGestureRecognizer)  {
          print("single tap")
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewTwo)
            if let tapIndexPath = self.colectionViewTwo.indexPathForItem(at: tapLocation) {
                
                print(temporaryModel2[tapIndexPath.item])
                temporaryModel1.insert(temporaryModel2[tapIndexPath.item], at: IndexPath(item: temporaryModel1.count, section: 0).item)
                colectionViewOne.reloadData()
                // colectionViewTwo.insertItems(at: [IndexPath(item: temporaryModel2.count - 1, section: 0)])
                
                
              //  if let tappedCell = self.colectionViewTwo.cellForItem(at: tapIndexPath) as? PracticeDragDropCellCollectionViewCell {
                    //do what you want to cell here
                // print(   colectionViewTwo.numberOfItems(inSection: 0))
                  temporaryModel2.remove(at: tapIndexPath.item)
             //   print(   colectionViewTwo.numberOfItems(inSection: 0))
               
                colectionViewTwo.deleteItems(at: [tapIndexPath])
                
                
                    // temporaryModel1.insert(attributedString.string, at: destinationIndexPath.item)
                    
                    //collectionView.insertItems(at: [destinationIndexPath])
                    
                    
              //  }
            }
        }
    }
    
    @objc func doubleTap(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.colectionViewOne)
            if let tapIndexPath = self.colectionViewOne.indexPathForItem(at: tapLocation) {
             
                    //do what you want to cell here
                    print(temporaryModel1[tapIndexPath.item])
                    temporaryModel2.insert(temporaryModel1[tapIndexPath.item], at: IndexPath(item: temporaryModel2.count, section: 0).item)
                    colectionViewTwo.reloadData()
                   // colectionViewTwo.insertItems(at: [IndexPath(item: temporaryModel2.count - 1, section: 0)])
                    
                    
                    
                    print("double tap")
                    temporaryModel1.remove(at: tapIndexPath.item)
                   // print(   colectionViewOne.numberOfItems(inSection: 0))
                    colectionViewOne.deleteItems(at: [tapIndexPath])
                    score -= 10
                scoreLabel.text = "score: " + String(score)

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
    
    
    @IBAction func checkButton(_ sender: Any) {
       
        progressView.progress = Float(curentSentenceIndex) / Float(sentences.count)
       
        var temporaryModel2Correct:[String] = []
            var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                temporaryModel2Correct += [hanzi[index]+"/"+pinyin[index]]
            }
            print(temporaryModel1)
            print(temporaryModel2Correct)
  
        if temporaryModel1.elementsEqual(temporaryModel2Correct) {
            score += 100
     
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \(temporaryModel2Correct[0])",
                              actionTitle: "OK")
            { (input:String?) in
                
                self.scoreLabel.text = "score: " + String(self.score)
                if self.curentSentenceIndex == self.sentences.count {
                    // message with score
                    self.showMessageDialog(title: "Congratulations!!!",
                                           subtitle: "Your score is \(self.score)",
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
            }
            
        } else {
            score -= 50
            self.scoreLabel.text = "score: " + String(self.score)
            
            
            showWrongAnswerDialog(title: "Wrong", subtitle: "Maybe next time", answer: temporaryModel2Correct[0]) { (option :String?) in
                switch option {
                case "Skip":
                    if self.curentSentenceIndex == self.sentences.count {
                        self.showMessageDialog(title: "Congratulations!!!",
                                               subtitle: "Your score is \(self.score)",
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
                    self.temporaryModel2.append(contentsOf: self.temporaryModel1)
                    self.temporaryModel1 = []
                    self.colectionViewOne.reloadData()
                    self.colectionViewTwo.reloadData()
                }
            }
        }
    }
    
    func loadModel(){
        temporaryModel1 = []
        
        temporaryModel2 = []
        textForTranslation.text = self.sentences[curentSentenceIndex].english ?? "missing translation"
        var hanzi = self.sentences[curentSentenceIndex].chinese?.map{String($0)} ?? []
        var pinyin = self.sentences[curentSentenceIndex].pinyin?.split(separator: " ") ?? []
        for index in hanzi.indices {
            temporaryModel2 += [hanzi[index]+"/"+pinyin[index]]
        }
        if (sentences.count > curentSentenceIndex + 1) {
          
            var hanzi = self.sentences[curentSentenceIndex + 1].chinese?.map{String($0)} ?? []
            var pinyin = self.sentences[curentSentenceIndex + 1].pinyin?.split(separator: " ") ?? []
            for index in hanzi.indices {
                temporaryModel2 += [hanzi[index]+"/"+pinyin[index]]
            }
        }
        else {
            if sentences.count > 0 {
                var hanzi = self.sentences[curentSentenceIndex - 1].chinese?.map{String($0)} ?? []
                var pinyin = self.sentences[curentSentenceIndex - 1].pinyin?.map{String($0)} ?? []
                for index in hanzi.indices {
                    temporaryModel2 += [hanzi[index]+"/"+pinyin[index]]
                }
            }
        }
        temporaryModel2.shuffle()
        curentSentenceIndex += 1
        
    }
  
    @IBOutlet weak var scoreLabel: UILabel!
}
extension UIViewController {
    func showMessageDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "OK",
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func showWrongAnswerDialog(title:String? = nil,
                           subtitle:String? = nil,
                           answer:String? = nil,
                           actionHandler: ((_ text: String?) -> Void)? = nil){
        
    let actionTitleSkip:String? = "Skip"
    let actionTitleRetry:String? = "Retry"
    let actionTitleAnswer:String? = "Correct Answer"
    
    let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: actionTitleSkip, style: .destructive, handler: { (action:UIAlertAction) in
        actionHandler?("Skip")
        return
    }))
        
    alert.addAction(UIAlertAction(title: actionTitleRetry, style: .destructive, handler: { (action:UIAlertAction) in
        actionHandler?("Retry")
        return
    }))
    
        alert.addAction(UIAlertAction(title: actionTitleAnswer, style: .destructive, handler: { (action:UIAlertAction) in
            self.showMessageDialog(title: "Correct answer:",
                                   subtitle: "\(String(describing: answer))",
                actionTitle: "OK")
            { (input:String?) in
                actionHandler?("Skip")
                return
            }
        }))
        
      
        
        self.present(alert, animated: true, completion: nil)
    }
}
