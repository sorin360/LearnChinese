//
//  PracticeTranslateSentenceViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class PracticeTranslateSentenceViewController: PracticeViewController,   UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
   
    var practiceTranslateSentence: PracticeTranslateSentence?

    var contentAnswerColection:[WordPracticeModel] = [] {
        didSet {
            if !contentAnswerColection.isEmpty {
                checkButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                checkButton.isEnabled = true
                
            } else {
                checkButton.isEnabled = false
                checkButton.backgroundColor = .clear
            }
        }
    }
  
    var contentChoicesCollection:[WordPracticeModel] = []
   
    var answerColectionView: UICollectionView! {
        didSet{
            answerColectionView.dataSource = self
            answerColectionView.delegate = self
            answerColectionView.dragDelegate = self
            answerColectionView.dragInteractionEnabled = true
            
            let pressGesture = UITapGestureRecognizer(target: self, action: #selector(self.pressInAnswerCollection(_:)))
            pressGesture.numberOfTapsRequired = 1
            answerColectionView.addGestureRecognizer(pressGesture)
            pressGesture.delegate = self
            
            let alignedFlowLayout = LeftAlignedCollectionViewFlowLayout()
            alignedFlowLayout.minimumInteritemSpacing = 1
            alignedFlowLayout.minimumLineSpacing = 1.5
            answerColectionView.collectionViewLayout = alignedFlowLayout
            
            let backgroundView = StripedView()
            answerColectionView.backgroundView = backgroundView
            
            answerColectionView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var choicesCollectionView: UICollectionView! {
        didSet{
            choicesCollectionView.dataSource = self
            choicesCollectionView.delegate = self
            
            let pressGesture = UITapGestureRecognizer(target: self, action: #selector(self.pressInChoicesCollection(_:)))
            pressGesture.numberOfTapsRequired = 1
            choicesCollectionView.addGestureRecognizer(pressGesture)
            choicesCollectionView.backgroundColor = UIColor.white
            pressGesture.delegate = self
            
            choicesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        speakerButton.addTarget(self, action: #selector(self.speakerButtonAction), for: UIControl.Event.touchDown)
        
        setUpAnswerCollectionView()
        
        setUpChoicesCollectionView()
        
        setUpCheckButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        loadModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpCheckButton(){
        checkButton.addTarget(self, action: #selector(self.checkButtonAction), for: UIControl.Event.touchDown)
        view.addSubview(checkButton)
        
        checkButton.topAnchor.constraint(equalTo: choicesCollectionView.bottomAnchor, constant: 8.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
    }
    
    func setUpAnswerCollectionView() {
        self.answerColectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        view.addSubview(answerColectionView)
        
        answerColectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        answerColectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8.0).isActive = true
        answerColectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        answerColectionView.topAnchor.constraint(equalTo: textForTranslationCollectionView.bottomAnchor, constant: 8.0).isActive = true
        answerColectionView.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
    }
    
    func setUpChoicesCollectionView() {
        self.choicesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.addSubview(choicesCollectionView)
        
        choicesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        choicesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        choicesCollectionView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4).isActive = true
        choicesCollectionView.topAnchor.constraint(equalTo: answerColectionView.bottomAnchor, constant: 8.0).isActive = true
        choicesCollectionView.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
    }
    
    @objc func checkButtonAction() {
        
        var givenAnswer = [String]()
        
        for index in contentAnswerColection.indices {
            givenAnswer += [contentAnswerColection[index].wordText ]
        }
        
        let checkResult = practiceTranslateSentence?.check(theAnswer: givenAnswer)
        
        if (checkResult?.0)! {
            showMessageDialog(title: "Correct",
                              subtitle: "Answer: \((checkResult?.1)!)",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                // the answer is corect -> pop to PracticeManager
                self.navigationController?.popViewController(animated: false)
            }
            
        } else {
            lifeStatus -= 1
            practiceTranslateSentence?.practice?.lifeStatus -= 1
            showWrongAnswerDialog(title: "Sorry...", subtitle: "Wrong answer", answer: (checkResult?.1)!) { (option :String?) in
                
                switch option {
                case "Skip":
                    self.contentAnswerColection = []
                    self.answerColectionView.reloadData()
                    self.navigationController?.popViewController(animated: false)
                case "Retry":
                    //update progress and score (retry)
                    self.progressView.progress = self.practiceTranslateSentence?.practice?.progressStatus ?? 0.0
                    self.scoreButton.title = "score: " + (self.practiceTranslateSentence?.getScore() ?? "00")
                    self.contentChoicesCollection.append(contentsOf: self.contentAnswerColection)
                    self.contentAnswerColection = []
                    self.answerColectionView.reloadData()
                    self.choicesCollectionView.reloadData()
                default:
                    break
                }
            }
        }
    }
    
    @objc func speakerButtonAction() {
        practiceTranslateSentence?.getCorectAnswerInChinese().speak()
    }
    
    // MARK: - Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // simulation label in order to get intrinsicContentSize for cell
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        
        switch collectionView {
        case answerColectionView:
            if !chineseSentence {
                label.text = contentAnswerColection[indexPath.row].pinyin
                return CGSize(width: label.intrinsicContentSize.width + 10, height: 45)
            } else {
                label.text = contentAnswerColection[indexPath.row].wordText
                return CGSize(width: label.intrinsicContentSize.width + 10, height: 30)
            }
        case choicesCollectionView:
            if !chineseSentence {
                label.text = contentChoicesCollection[indexPath.row].pinyin
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 45)
            } else {
                label.text = contentChoicesCollection[indexPath.row].wordText
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 30)
            }
        default:
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView == answerColectionView {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let attributedText = item.dragItem.localObject as? NSMutableAttributedString {
                        var texts = attributedText.string.split(separator: "/")
                        let word = WordPracticeModel(wordText: String(texts[0]), pinyin: String(texts[1]))
                        collectionView.performBatchUpdates({
                            contentAnswerColection.remove(at: sourceIndexPath.item)
                            contentAnswerColection.insert(word, at: destinationIndexPath.item)
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
        if let cell = (answerColectionView.cellForItem(at: indexpath) as? PracticeTranslateSentenceCellCollectionViewCell){
            let attributedText1 =  cell.hanziLabel.attributedText ?? NSAttributedString(string: "")
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
        case answerColectionView:
            return contentAnswerColection.count
        case choicesCollectionView:
            return contentChoicesCollection.count
        default:
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
        if chineseSentence {
            cell.hanziLabel.text = contentAnswerColection[indexPath.row].wordText
            cell.pinyinLabel.text = " "
        } else {
            cell.hanziLabel.text = contentAnswerColection[indexPath.row].wordText
            cell.pinyinLabel.text = contentAnswerColection[indexPath.row].pinyin
        }
        cell.isUserInteractionEnabled = true
        
        switch collectionView {
        case answerColectionView:
            cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            return cell
        case choicesCollectionView:
            cell.backgroundColor = #colorLiteral(red: 0.867922463, green: 0.867922463, blue: 0.867922463, alpha: 1)
            return cell
        default:
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }

    @objc func pressInChoicesCollection(_ recognizer: UITapGestureRecognizer)  {
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.choicesCollectionView)
            if let tapIndexPath = self.choicesCollectionView.indexPathForItem(at: tapLocation) {
                
                if !chineseSentence {
                    contentChoicesCollection[tapIndexPath.item].wordText.speak()
                }
                contentAnswerColection.insert(contentChoicesCollection[tapIndexPath.item], at: IndexPath(item: contentAnswerColection.count, section: 0).item)
                answerColectionView.reloadData()
                contentChoicesCollection.remove(at: tapIndexPath.item)
                choicesCollectionView.deleteItems(at: [tapIndexPath])
            }
        }
    }
    
    @objc func pressInAnswerCollection(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.answerColectionView)
            if let tapIndexPath = self.answerColectionView.indexPathForItem(at: tapLocation) {
                  
                contentChoicesCollection.insert(contentAnswerColection[tapIndexPath.item], at: IndexPath(item: contentChoicesCollection.count, section: 0).item)
                choicesCollectionView.reloadData()
                contentAnswerColection.remove(at: tapIndexPath.item)
                answerColectionView.deleteItems(at: [tapIndexPath])
                practiceTranslateSentence?.updateScore(with: -10)
                self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
            }
        }
    }

    func loadModel(){
        progressView.progress = practiceTranslateSentence?.practice?.progressStatus ?? 0.0
      
        self.scoreButton.title = "score: " + (practiceTranslateSentence?.getScore() ?? "00")
        
        contentAnswerColection = []
        self.answerColectionView.reloadData()
        if Bool.random() {
            chineseSentence = true
            contentTextForTranslationCollection = practiceTranslateSentence?.getChineseSentence() ?? []
            contentChoicesCollection = practiceTranslateSentence?.getShuffledEnglishWords() ?? []
        } else {
            chineseSentence = false
            contentTextForTranslationCollection = practiceTranslateSentence?.getEnglishSentence() ?? []
            contentChoicesCollection = practiceTranslateSentence?.getShuffledChineseWords() ?? []
        }
        self.choicesCollectionView.reloadData()
        self.textForTranslationCollectionView.reloadData()
       // contentChoicesCollection = practiceDragDrop?.getShuffledWords() ?? []
        
        
    }
}
