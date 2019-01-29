//
//  HomeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import GameplayKit
import SwiftChart
import CoreData
import AVFoundation


class HomeViewController: UIViewController, UITabBarControllerDelegate{

    var wordOfTheDayTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "The word of the day"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var knownWordsCounterButtonSubtitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "words"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var knownWordsCounterButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(50)
        button.titleLabel?.textColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var pinyinButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var hanziButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.blue, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var translationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var chart: Chart = {
        var chart = Chart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    var knownWords:[Words] = []
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var homeModel = Home()
    
    var settingsButton: UIButton!
    
    func updateChart(){
     
        let series = homeModel.getChartSeries()
        var weekDays = homeModel.getWeekDaysLabels()
        
        chart.xLabels = [6, 0, 1, 2, 3, 4, 5]
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return weekDays[labelIndex]
        }
        chart.backgroundColor = UIColor.white
        
        chart.add(series)
        
    }
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(knownWordsCounterButton)
        
        
        
        
     
    
    }
  */
    
    let scrollView = UIScrollView()
    let contentView = UIView()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "background")
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        setCharacterOfTheDay()
        setupScrollView()
        updateChart()
        setupViews()
    }
  
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        //x,w,t,b
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //x,w,t,b
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupViews(){
        
        let chartSubView = UIView()
        chartSubView.backgroundColor = .white
        chartSubView.layer.cornerRadius = 10
        chartSubView.translatesAutoresizingMaskIntoConstraints = false
        
        chartSubView.addSubview(chart)
        
        chart.topAnchor.constraint(equalTo: chartSubView.topAnchor, constant: 5).isActive = true
         chart.leftAnchor.constraint(equalTo: chartSubView.leftAnchor, constant: 5).isActive = true
         chart.rightAnchor.constraint(equalTo: chartSubView.rightAnchor, constant: -5).isActive = true
         chart.bottomAnchor.constraint(equalTo: chartSubView.bottomAnchor, constant: -5).isActive = true
        contentView.addSubview(knownWordsCounterButton)
        contentView.addSubview(knownWordsCounterButtonSubtitle)
        contentView.addSubview(wordOfTheDayContentView)
         contentView.addSubview(chartSubView)
          contentView.addSubview(label2)
       
        
    
        let computedHight = (view.frame.width - (0.6 * view.frame.width))/2
        
        knownWordsCounterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        knownWordsCounterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        knownWordsCounterButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
        knownWordsCounterButton.heightAnchor.constraint(equalTo: knownWordsCounterButton.widthAnchor).isActive = true
        knownWordsCounterButton.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -60).isActive = true
        
        knownWordsCounterButtonSubtitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
     //   knownWordsCounterButtonSubtitle.topAnchor.constraint(equalTo: knownWordsCounterButton.bottomAnchor, constant: 40).isActive = true
        knownWordsCounterButtonSubtitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
        knownWordsCounterButtonSubtitle.heightAnchor.constraint(equalTo: knownWordsCounterButton.widthAnchor).isActive = true
        knownWordsCounterButtonSubtitle.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -25).isActive = true
        
        
        wordOfTheDayContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        wordOfTheDayContentView.topAnchor.constraint(equalTo: knownWordsCounterButton.bottomAnchor).isActive = true
        wordOfTheDayContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
        wordOfTheDayContentView.bottomAnchor.constraint(equalTo: chartSubView.topAnchor, constant: -30).isActive = true
        
        let wordOfTheDayStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = NSLayoutConstraint.Axis.horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        wordOfTheDayStackView.addArrangedSubview(pinyinButton)
        wordOfTheDayStackView.addArrangedSubview(hanziButton)
        
        //stackview background
        
        let subView = UIView()
        subView.backgroundColor = .white
        subView.layer.cornerRadius = 10
        subView.translatesAutoresizingMaskIntoConstraints = false
        wordOfTheDayContentView.addSubview(subView) // Important: addSubview() not addArrangedSubview()
        
        // use whatever constraint method you like to
        // constrain subView to the size of stackView.
        subView.topAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -20).isActive = true
        subView.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.bottomAnchor, constant: 20).isActive = true
        subView.leftAnchor.constraint(equalTo: wordOfTheDayContentView.leftAnchor).isActive = true
        subView.rightAnchor.constraint(equalTo: wordOfTheDayContentView.rightAnchor).isActive = true

        
        wordOfTheDayContentView.addArrangedSubview(wordOfTheDayTitle)
        wordOfTheDayContentView.addArrangedSubview(wordOfTheDayStackView)
        wordOfTheDayContentView.addArrangedSubview(translationLabel)
        /*
        wordOfTheDayTitle.centerXAnchor.constraint(equalTo: wordOfTheDayContentView.centerXAnchor).isActive = true
        wordOfTheDayTitle.topAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: 20).isActive = true
        wordOfTheDayTitle.widthAnchor.constraint(equalTo: wordOfTheDayContentView.widthAnchor).isActive = true
        wordOfTheDayTitle.bottomAnchor.constraint(equalTo: wordOfTheDayStackView.topAnchor, constant: -20).isActive = true
        */
        /*
        wordOfTheDayStackView.centerXAnchor.constraint(equalTo: wordOfTheDayContentView.centerXAnchor).isActive = true
        wordOfTheDayStackView.topAnchor.constraint(equalTo: wordOfTheDayTitle.bottomAnchor, constant: 20).isActive = true
        wordOfTheDayStackView.widthAnchor.constraint(equalTo: wordOfTheDayContentView.widthAnchor, multiplier: 3/4).isActive = true
        wordOfTheDayStackView.bottomAnchor.constraint(equalTo: translationLabel.topAnchor, constant: -20).isActive = true
        */
        /*
        translationLabel.centerXAnchor.constraint(equalTo: wordOfTheDayContentView.centerXAnchor).isActive = true
        translationLabel.topAnchor.constraint(equalTo: wordOfTheDayStackView.bottomAnchor).isActive = true
        translationLabel.widthAnchor.constraint(equalTo: wordOfTheDayContentView.widthAnchor, multiplier: 3/4).isActive = true
        translationLabel.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.bottomAnchor).isActive = true
    */
        chartSubView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chartSubView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        chartSubView.topAnchor.constraint(equalTo: wordOfTheDayContentView.bottomAnchor).isActive = true
        chartSubView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
        chartSubView.bottomAnchor.constraint(equalTo: label2.topAnchor).isActive = true
        
        label2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label2.topAnchor.constraint(equalTo: chartSubView.bottomAnchor).isActive = true
        label2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        label2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
      //  chartSubView.addSubview(label2)
   /*
       label2.centerXAnchor.constraint(equalTo: chartSubView.centerXAnchor).isActive = true
        label2.topAnchor.constraint(equalTo: chartSubView.bottomAnchor).isActive = true
        label2.widthAnchor.constraint(equalTo: chartSubView.widthAnchor, multiplier: 3/4).isActive = true
        label2.bottomAnchor.constraint(equalTo: chartSubView.bottomAnchor).isActive = true
        */
        
        wordOfTheDayStackView.widthAnchor.constraint(equalTo: wordOfTheDayContentView.widthAnchor, multiplier: 0.95).isActive = true
        
        
        
    }
    
    let wordOfTheDayContentView: UIStackView = {
       /* let label = UIView()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label*/
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.white
    
        return stackView
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "© 2018 Sorin Lica"
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label23: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
      //  updateChart()
        updateKnownWords()
        super.viewWillAppear(animated)
        
        let utterance = AVSpeechUtterance(string: "你在干嘛")
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
   
    func updateKnownWords(){
        knownWords = Words.getKnownWords()
        knownWordsCounterButton.setAttributedTitle(NSAttributedString(string: String(knownWords.count)), for: .normal)
  
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "knownWords" {
            let flashcadsCollectionController = segue.destination as? FlashcardsCollectionViewController
           // flashcadsCollectionController?.words = knownWords
            flashcadsCollectionController?.navigationItem.title = "Well known words"
        }
        
        if segue.identifier == "wordOfTheDay" {
            if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                destination.words = [Words.getTheWordOfTheDay()!]
            }
        }
    }
    
    func setCharacterOfTheDay(){
        
        //TO DO add this in same function with updateView
        let wordOfTheDay = Words.getTheWordOfTheDay()
        pinyinButton.setTitle(wordOfTheDay?.pinyin, for: .normal)
        hanziButton.setTitle(" \(wordOfTheDay?.chinese ?? "--") ", for: .normal)
        translationLabel.text = wordOfTheDay?.english
    }
    
}
