//
//  ViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 03/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData
import GameplayKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let someDate = Date() + 1
        let someDate2 = Date() + 1
        let someDate3 = Date() + 2
        
        
        let notSoRandomSource1 = GKMersenneTwisterRandomSource(seed: UInt64(someDate.timeIntervalSince1970))
        let numberForToday = GKRandomDistribution(randomSource: notSoRandomSource1,
                                                  lowestValue: 1,
                                                  highestValue: 2000)
        let first = numberForToday.nextInt()
        
        print(first)
        
        //  var hsk = CodableHskFlashcardsModel(level: "hsk1", words: [word, word])
        
        //let jsonData: Data? = try? JSONEncoder().encode(hsk)
        // let jsonResponse = try? JSONSerialization.jsonObject(with:
        //      jsonData!, options: [])
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var downloadEnd = false
        let firstUse = UserDefaults.standard.bool(forKey: "firstUse")
        if !firstUse {
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            self.container?.performBackgroundTask(){ context in
                
                guard let url = URL(string: "https://api.myjson.com/bins/ylxfo") else {return}
                
                URLSession.shared.dataTask(with: url, completionHandler:  { (data, response, error) in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    do{
                        
                        
                        let myData = try JSONDecoder().decode(CodableHskFlashcardsModel.self, from: dataResponse)
                        
                        HskFlashcards.addFlashcardBunch(in: context, with: myData)
                        DispatchQueue.main.async {
                            if downloadEnd {
                                self.dismiss(animated: true, completion: nil)
                                if let navController = self.viewControllers?[0] as? UINavigationController{
                                    if let testController = navController.children.first as? HomeViewController{
                                        testController.setCharacterOfTheDay()
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            } else {
                                downloadEnd = true
                            }
                        }
                        
                        //   self.dismiss(animated: false, completion: nil)
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }).resume()
                
                guard let urlSentences = URL(string: "https://api.npoint.io/6125e5679466e7eedeb7") else {return}
                
                URLSession.shared.dataTask(with: urlSentences, completionHandler:  { (data, response, error) in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    do{
                        
                        
                        let myData = try JSONDecoder().decode([CodableSentencesModel].self, from: dataResponse)
                        
                        Sentences.addSentences(in: context, with: myData)
                        DispatchQueue.main.async {
                            if downloadEnd {
                                self.dismiss(animated: true, completion: nil)
                                if let navController = self.viewControllers?[0] as? UINavigationController{
                                    if let testController = navController.children.first as? HomeViewController{
                                        testController.setCharacterOfTheDay()
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            } else {
                                downloadEnd = true
                            }
                        }
                        
                        //   self.dismiss(animated: false, completion: nil)
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }).resume()
            }
        }
    }
}

