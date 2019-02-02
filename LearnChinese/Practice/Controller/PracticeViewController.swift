//
//  PracticeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 21/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit
import AVFoundation

class PracticeViewController: UIViewController {
    
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
    
    var speakerButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.06727838991, green: 1, blue: 0.2576389901, alpha: 1)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var progressView: UIProgressView = {
        var progress = UIProgressView()
        progress.setProgress(0.0, animated: true)
        progress.trackTintColor = UIColor.white
        progress.progressTintColor = UIColor.green
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    var textForTranslation: UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @objc func speakerButtonAction() {
        let utterance = AVSpeechUtterance(string: textForTranslation.text ?? " ")
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    
    @objc func endPracticeButtonAction() {
        showMessageDialog(title: "Are you sure you want to end this sesion?", subtitle: "The score gained by now won't be saved", actionTitle: "OK", cancelActionTitle: "Cancel") { () in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        speakerButton.addTarget(self, action: #selector(self.speakerButtonAction), for: UIControl.Event.touchDown)
        
        lifeStatus = 4
        
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
        
        view.addSubview(textForTranslation)
        
        speakerButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        speakerButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        speakerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        speakerButton.rightAnchor.constraint(equalTo: textForTranslation.leftAnchor, constant: -4.0).isActive = true
        speakerButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8.0).isActive = true
        
        
        
        textForTranslation.leftAnchor.constraint(equalTo: speakerButton.rightAnchor).isActive = true
        textForTranslation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8.0).isActive = true
        textForTranslation.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8.0).isActive = true
        
        
    }
}
