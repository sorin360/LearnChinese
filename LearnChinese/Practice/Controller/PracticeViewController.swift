//
//  PracticeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 21/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
    var chineseSentence = true
    
    var lifeStatus = 4 {
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
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    var speakerButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.06727838991, green: 1, blue: 0.2576389901, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var scoreButton: UIBarButtonItem!
    
    private var endPracticeButton: UIBarButtonItem!
    
    var checkButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.isEnabled = false
        
        button.setTitle("Check", for: UIControl.State.normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var progressView: UIProgressView = {
        var progress = UIProgressView()
        progress.setProgress(0.0, animated: true)
        progress.trackTintColor = UIColor.white
        progress.progressTintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var textForTranslationCollectionView: UICollectionView! {
        didSet{
            textForTranslationCollectionView.dataSource = self
            textForTranslationCollectionView.delegate = self
            let alignedFlowLayout = LeftAlignedCollectionViewFlowLayout()
            alignedFlowLayout.minimumInteritemSpacing = 1
            alignedFlowLayout.minimumLineSpacing = 1.5
            textForTranslationCollectionView.collectionViewLayout = alignedFlowLayout
            textForTranslationCollectionView.backgroundColor = UIColor.white
      
        }
    }
    
    var contentTextForTranslationCollection:[WordPracticeModel] = []
    private var verticalLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        setUpNavigationBar()
        
        setUpTextForTranslationCollectionView()
    }
    
    // MARK: - Collection
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // simulation label in order to get intrinsicContentSize for cell
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        if chineseSentence {
            label.text = contentTextForTranslationCollection[indexPath.row].pinyin
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 45)
        } else {
            label.text = contentTextForTranslationCollection[indexPath.row].wordText
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 30)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentTextForTranslationCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
        if !chineseSentence {
            cell.hanziLabel.text = contentTextForTranslationCollection[indexPath.row].wordText
            cell.pinyinLabel.text = " "
        } else {
            cell.hanziLabel.text = contentTextForTranslationCollection[indexPath.row].wordText
            cell.pinyinLabel.text = contentTextForTranslationCollection[indexPath.row].pinyin
        }
        cell.isUserInteractionEnabled = true
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.verticalLayoutConstraint.constant = self.textForTranslationCollectionView.contentSize.height
        
        return cell
    }
    
    @objc func endPracticeButtonAction() {
        showMessageDialog(title: "Are you sure you want to end this sesion?", subtitle: "The score gained by now won't be saved", actionTitle: "OK", cancelActionTitle: "Cancel") { () in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func setUpNavigationBar() {
        self.scoreButton = UIBarButtonItem(title: "score: 0", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = scoreButton
        
        self.endPracticeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.endPracticeButtonAction))
        navigationItem.leftBarButtonItem = endPracticeButton
        view.addSubview(progressView)
        
        progressView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        
        view.addSubview(speakerButton)
        
        speakerButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        speakerButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        speakerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        speakerButton.rightAnchor.constraint(equalTo: textForTranslationCollectionView.leftAnchor, constant: -5.0).isActive = true
        speakerButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10.0).isActive = true
        
    }
    
    func setUpTextForTranslationCollectionView(){
        
        self.textForTranslationCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        textForTranslationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textForTranslationCollectionView)
 
        textForTranslationCollectionView.leftAnchor.constraint(equalTo: speakerButton.rightAnchor).isActive = true
        textForTranslationCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        textForTranslationCollectionView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10.0).isActive = true
        verticalLayoutConstraint = textForTranslationCollectionView.heightAnchor.constraint(equalToConstant: 10)
        verticalLayoutConstraint.isActive = true
        
        textForTranslationCollectionView.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
    }
}
