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

class TabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // new link https://sorin360.github.io/hsk-vocabulary/hsk-vocab-json/hsk-level-1.json
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
   /*
        Scores.update(with: 50, at: Calendar.current.date(byAdding: .day, value: 0 - 0, to: Date().stripTime())!)
        Scores.update(with: 20, at: Calendar.current.date(byAdding: .day, value: 0 - 1, to: Date().stripTime())!)
        Scores.update(with: 100, at: Calendar.current.date(byAdding: .day, value: 0 - 2, to: Date().stripTime())!)
        Scores.update(with: 90, at: Calendar.current.date(byAdding: .day, value: 0 - 3, to: Date().stripTime())!)
        Scores.update(with: 90, at: Calendar.current.date(byAdding: .day, value: 0 - 4, to: Date().stripTime())!)
        Scores.update(with: 60, at: Calendar.current.date(byAdding: .day, value: 0 - 5, to: Date().stripTime())!)
        Scores.update(with: 100, at: Calendar.current.date(byAdding: .day, value: 0 - 6, to: Date().stripTime())!)
   */
        let homeViewController = HomeViewController()
        let navControllerHome = UINavigationController(rootViewController: homeViewController)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        let flashcardsViewController = FlashcardsTableViewController()
        let navControllerFlashcards = UINavigationController(rootViewController: flashcardsViewController)
        flashcardsViewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "library"), tag: 1)
        
        let practiceViewController = PracticeTableViewController()
        let navControllerPractice = UINavigationController(rootViewController: practiceViewController)
        practiceViewController.tabBarItem = UITabBarItem(title: "Practice", image: UIImage(named: "practice"), tag: 2)
        
        let searchViewController = SearchTableViewController()
        let navControllerSearch = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        
        let tabBarList = [navControllerHome, navControllerFlashcards, navControllerPractice, navControllerSearch]
        
        viewControllers = tabBarList
        
  
        setViewBackground()

     
    }
    
    func setViewBackground(){
        
        let image = #imageLiteral(resourceName: "background")
        let newWidth = view.frame.width
        let newHeight = view.frame.height
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
        image.draw(in: CGRect(x: 0, y: 0, width: Int(newWidth), height: Int(newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UINavigationBar.appearance().setBackgroundImage(newImage, for: .default)
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.green
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var downloadEnd = false
        let firstUse = UserDefaults.standard.bool(forKey: "firstUse")
        
        if !firstUse {
            
            let alert = UIAlertController(title: "Please wait...", message: "The database is being updating.", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            self.container?.performBackgroundTask(){ context in
                
            //    guard let url = URL(string: "https://api.myjson.com/bins/13mxps") else {return} hsk1
                guard let url = URL(string: "https://sorin360.github.io/LearnChineseResources/hskWords1-5.json") else {return}
                
                URLSession.shared.dataTask(with: url, completionHandler:  { (data, response, error) in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    do{

                        let myData = try JSONDecoder().decode([CodableHskFlashcardsModel].self, from: dataResponse)
                        
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
                
                guard let urlSentences = URL(string: "https://sorin360.github.io/LearnChineseResources/hskSentences1-2.json") else {return}
                
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
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }).resume()
            }
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
   
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }

    }


}

