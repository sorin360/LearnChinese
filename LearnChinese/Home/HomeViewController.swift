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

class HomeViewController: UIViewController, UITabBarControllerDelegate{

    var speakerButtonCollectionCell: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var wordOfTheDayTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(22)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "The word of the day", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var chartTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(22)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "Scores on the last 7 days", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
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
        button.titleLabel?.font = button.titleLabel?.font.withSize(60)
        button.titleLabel?.textColor = #colorLiteral(red: 0.03470817438, green: 0.5300959564, blue: 0.9903107271, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var pinyinButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
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
        button.titleLabel?.font = button.titleLabel?.font.withSize(28)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var translationLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var chart: Chart = {
        var chart = Chart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    var settingsButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("More", for: UIControl.State.normal)
        button.backgroundColor = UIColor.yellow
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let wordOfTheDayContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.white
        return stackView
    }()
    
    var knownWords:[Words] = []
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var homeModel = Home()

    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        knownWordsCounterButton.addTarget(self, action: #selector(self.knownWordsCounterButtonAction), for: .touchDown)
        hanziButton.addTarget(self, action: #selector(self.wordOfTheDayButtonAction), for: .touchDown)
        settingsButton.addTarget(self, action: #selector(self.settingsButtonAction), for: .touchDown)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.green
        
        setCharacterOfTheDay()
        setupScrollView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateKnownWords()
        updateChart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateChart(){
        let series = homeModel.getChartSeries()
        var weekDays = homeModel.getWeekDaysLabels()
        
        chart.xLabels = [6, 0, 1, 2, 3, 4, 5]
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return weekDays[labelIndex]
        }
        chart.backgroundColor = UIColor.white
        chart.removeAllSeries()
        chart.add(series)
        
    }
  
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupViews(){
        
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "background")
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let chartSubView = UIView()
        chartSubView.backgroundColor = .white
        chartSubView.layer.cornerRadius = 10
        chartSubView.translatesAutoresizingMaskIntoConstraints = false
        chartSubView.addSubview(chartTitle)
        chartSubView.addSubview(chart)
        
        chartTitle.topAnchor.constraint(equalTo: chartSubView.topAnchor, constant: 10).isActive = true
        chartTitle.centerXAnchor.constraint(equalTo: chartSubView.centerXAnchor).isActive = true
        chartTitle.leftAnchor.constraint(equalTo: chartSubView.leftAnchor, constant: 5).isActive = true
        chartTitle.rightAnchor.constraint(equalTo: chartSubView.rightAnchor, constant: -5).isActive = true
        chartTitle.bottomAnchor.constraint(equalTo: chart.topAnchor, constant: -10).isActive = true
        
        chart.leftAnchor.constraint(equalTo: chartSubView.leftAnchor, constant: 5).isActive = true
        chart.rightAnchor.constraint(equalTo: chartSubView.rightAnchor, constant: -5).isActive = true
        chart.bottomAnchor.constraint(equalTo: chartSubView.bottomAnchor, constant: -5).isActive = true
        
        contentView.addSubview(knownWordsCounterButton)
        contentView.addSubview(knownWordsCounterButtonSubtitle)
        contentView.addSubview(wordOfTheDayContentView)
        contentView.addSubview(chartSubView)
        contentView.addSubview(settingsButton)
    
        knownWordsCounterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        knownWordsCounterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        knownWordsCounterButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
        knownWordsCounterButton.heightAnchor.constraint(equalTo: knownWordsCounterButton.widthAnchor).isActive = true
        knownWordsCounterButton.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -60).isActive = true
        
        knownWordsCounterButtonSubtitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        knownWordsCounterButtonSubtitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
        knownWordsCounterButtonSubtitle.heightAnchor.constraint(equalTo: knownWordsCounterButton.widthAnchor).isActive = true
        knownWordsCounterButtonSubtitle.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -25).isActive = true
   
        wordOfTheDayContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        wordOfTheDayContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85).isActive = true
        wordOfTheDayContentView.bottomAnchor.constraint(equalTo: chartSubView.topAnchor, constant: -30).isActive = true
        
        let wordOfTheDayStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = NSLayoutConstraint.Axis.horizontal
            stackView.alignment = .fill
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
        

        subView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: wordOfTheDayContentView.topAnchor, constant: -20).isActive = true
        subView.bottomAnchor.constraint(equalTo: wordOfTheDayContentView.bottomAnchor, constant: 20).isActive = true
        subView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true

        wordOfTheDayContentView.addArrangedSubview(wordOfTheDayTitle)
        wordOfTheDayContentView.addArrangedSubview(wordOfTheDayStackView)
        wordOfTheDayContentView.addArrangedSubview(translationLabel)
      
        chartSubView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        chartSubView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        chartSubView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
        chartSubView.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -10.0).isActive = true
        
        settingsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        wordOfTheDayStackView.widthAnchor.constraint(equalTo: wordOfTheDayContentView.widthAnchor, multiplier: 0.95).isActive = true
    }
    
    
    @objc func settingsButtonAction(){
        let destination = SettingsTableViewController()
        navigationController?.pushViewController(destination, animated: true)
    }
    

    func updateKnownWords(){
        knownWords = Words.getKnownWords()
        knownWordsCounterButton.setAttributedTitle(NSAttributedString(string: String(knownWords.count)), for: .normal)
  
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func wordOfTheDayButtonAction(){
        let destination = FlashcardDetailsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
        destination.words = [Words.getTheWordOfTheDay()!]
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func knownWordsCounterButtonAction(){
        let flashcadsCollectionController = FlashcardsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
        flashcadsCollectionController.navigationItem.title = "Well known words"
        navigationController?.pushViewController(flashcadsCollectionController, animated: true)
    }

    
    func setCharacterOfTheDay(){
        let wordOfTheDay = Words.getTheWordOfTheDay()
        pinyinButton.setTitle(wordOfTheDay?.pinyin, for: .normal)
        hanziButton.setTitle(" \(wordOfTheDay?.chinese ?? "--") ", for: .normal)
        translationLabel.text = wordOfTheDay?.english
    }
    
}
