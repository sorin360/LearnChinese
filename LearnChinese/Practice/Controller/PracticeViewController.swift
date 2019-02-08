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
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    let synthesizer = AVSpeechSynthesizer()
    
    var speakerButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.06727838991, green: 1, blue: 0.2576389901, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // tabbar
    var scoreButton: UIBarButtonItem!
    var endPracticeButton: UIBarButtonItem!
    
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
    
    var contentCollectionZero:[WordPracticeModel] = []
   
    
    var colectionViewZero: UICollectionView! {
        didSet{
            colectionViewZero.dataSource = self
            colectionViewZero.delegate = self
            let alignedFlowLayout = LeftAlignedCollectionViewFlowLayout()
            alignedFlowLayout.minimumInteritemSpacing = 1
            alignedFlowLayout.minimumLineSpacing = 1.5
            colectionViewZero.collectionViewLayout = alignedFlowLayout

            colectionViewZero.backgroundColor = UIColor.white
      
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.font = label.font.withSize(20)
        label.textAlignment = .center
           if chineseSentence {
                label.text = contentCollectionZero[indexPath.row].pinyin
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 45)
            } else {
                label.text = contentCollectionZero[indexPath.row].chinese
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 30)
            }
        
    }
    var verticalLayoutConstraint: NSLayoutConstraint!
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCollectionZero.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragDropCell", for: indexPath) as! PracticeTranslateSentenceCellCollectionViewCell
        if !chineseSentence {
            cell.chineseLabel.text = contentCollectionZero[indexPath.row].chinese
            cell.pinyinLabel.text = " "
        } else {
            cell.chineseLabel.text = contentCollectionZero[indexPath.row].chinese
            cell.pinyinLabel.text = contentCollectionZero[indexPath.row].pinyin
        }
        cell.isUserInteractionEnabled = true
        cell.chineseLabel.sizeToFit()
        cell.pinyinLabel.sizeToFit()
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // cell.chineseLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        // cell.pinyinLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
     self.verticalLayoutConstraint.constant = self.colectionViewZero.contentSize.height
      
       // colectionViewZero.constra
        return cell
    }
    
  
    @objc func endPracticeButtonAction() {
        showMessageDialog(title: "Are you sure you want to end this sesion?", subtitle: "The score gained by now won't be saved", actionTitle: "OK", cancelActionTitle: "Cancel") { () in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
      
       
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
        
        self.colectionViewZero = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        colectionViewZero.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colectionViewZero)
        
        speakerButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        speakerButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        speakerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        speakerButton.rightAnchor.constraint(equalTo: colectionViewZero.leftAnchor, constant: -5.0).isActive = true
        speakerButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10.0).isActive = true
        
        
        
        colectionViewZero.leftAnchor.constraint(equalTo: speakerButton.rightAnchor).isActive = true
        colectionViewZero.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        colectionViewZero.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10.0).isActive = true
       verticalLayoutConstraint = colectionViewZero.heightAnchor.constraint(equalToConstant: 10)
        verticalLayoutConstraint.isActive = true
          colectionViewZero.register(PracticeTranslateSentenceCellCollectionViewCell.self, forCellWithReuseIdentifier: "dragDropCell")
     
    }
    
}
