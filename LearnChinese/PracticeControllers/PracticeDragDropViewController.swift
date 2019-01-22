//
//  PracticeDragDropViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeDragDropViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate {
    
    var practiceDragDrop: PracticeDragDrop?
    
    var lifeStatus = 4 { //"⭐️⭐️⭐️⭐️" {
        didSet{
            
            switch lifeStatus {
            case 4:
                self.navigationItem.title = "⭐️⭐️⭐️⭐️"
            case 3:
                self.navigationItem.title = "⭐️⭐️⭐️"
            case 2:
                self.navigationItem.title = "⭐️⭐️"
            case 1:
                self.navigationItem.title = "⭐️"
            default:
                    self.showMessageDialog(title: "Sorry...",
                                           subtitle: "These sentences seem to be too difficult for you, try to choose some easier words for practice",
                                           actionTitle: "OK", cancelActionTitle: nil)
                    { () in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
    
    
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
    
    @IBOutlet weak var textForTranslation: UILabel!
    
   // @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var scoreButton: UIBarButtonItem!
    
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.backgroundColor = .clear
            checkButton.layer.cornerRadius = 15
            checkButton.layer.borderWidth = 2
            checkButton.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            checkButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            checkButton.isEnabled = false
            
        }
    }
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet{
            progressView.setProgress(0.0, animated: true)
           // progressView.layer.cornerRadius = 20
         
        }
    }
    
    @IBAction func endPracticeButton(_ sender: Any) {
        showMessageDialog(title: "Are you sure you want to end this sesion?", subtitle: "The score gained by now won't be saved", actionTitle: "OK", cancelActionTitle: "Cancel") { () in
             self.navigationController?.popViewController(animated: true)
            }
       
    }

    @IBOutlet weak var colectionViewOne: UICollectionView! {
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
          //  let image = UIImage(named: "line.png")
           
          //  image?.size = CGSize(width: 0.0, height: 0.0)
          //  colectionViewOne.backgroundColor = UIColor.init  .init(patternImage: image!)
                
                //UIColor.colorWithPatternImage(UIImage(named:DrawOnImage(startingImage: image!))!)
  
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
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
 
                self.scoreButton.title = "score: " + (self.practiceDragDrop?.getScore() ?? "00")
                if self.practiceDragDrop?.curentSentenceIndex == self.practiceDragDrop?.sentences.count {
                    
                    self.showMessageDialog(title: "Congratulations!!!",
                                           subtitle: "Your score is \(self.practiceDragDrop?.getScore() ?? "0")",
                        actionTitle: "OK", cancelActionTitle: nil)
                    { () in
                   
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
            self.scoreButton.title = "score: " + (practiceDragDrop?.getScore() ?? "00")
               lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                switch option {
                case "Skip":
                    if self.practiceDragDrop?.curentSentenceIndex == self.practiceDragDrop?.sentences.count {
                        self.showMessageDialog(title: "Congratulations!!!",
                                               subtitle: "Your score is \((checkResult?.1)!)",
                            actionTitle: "OK", cancelActionTitle: nil)
                        { () in
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
    /*
    override var prefersStatusBarHidden: Bool {
        return true
    }
    */
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)
         self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
        if (practiceDragDrop?.sentences.count)! > 0 {
            loadModel()
        } else {
            showMessageDialog(title: "Not sentences found",
                              subtitle: "Please select more libraries for prctice",
                              actionTitle: "OK", cancelActionTitle: nil)
            { () in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        lifeStatus = 4
        
     //   let image = #imageLiteral(resourceName: "background")
        self.view.backgroundColor = UIColor.white // UIColor(patternImage: image)
    
        
        super.viewDidLoad()
    }
    // MARK: - Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colectionViewOne {
             return CGSize(width: contentCollectionOne[indexPath.row].count * 15, height: 30)
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
                self.scoreButton.title = "score: " + (practiceDragDrop?.getScore() ?? "00")
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

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}

class StripedView: UIView {
    
    override func draw(_ rect: CGRect) {
        //// Set pattern tile colors width and height; adjust the color width to adjust pattern.
        let color1 = UIColor.white
        let color1Width: CGFloat = 30
        let color1Height: CGFloat = 30
        
        let color2 = #colorLiteral(red: 0.8647956285, green: 0.8647956285, blue: 0.8647956285, alpha: 1)
        let color2Width: CGFloat = 1
        let color2Height: CGFloat = 1
        
        
        //// Set pattern tile orientation vertical.
        let patternWidth: CGFloat = min(color1Width, color2Width)
        let patternHeight: CGFloat = (color1Height + color2Height)
        
        //// Set pattern tile size.
        let patternSize = CGSize(width: patternWidth, height: patternHeight)
        
        //// Draw pattern tile
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)
        
        let color1Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: color1Width, height: color1Height))
        color1.setFill()
        color1Path.fill()
        
        let color2Path = UIBezierPath(rect: CGRect(x: 0, y: color1Height, width: color2Width, height: color2Height))
        color2.setFill()
        color2Path.fill()
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //// Draw pattern in view
        UIColor(patternImage: image!).setFill()
        context!.fill(rect)
    }
}
