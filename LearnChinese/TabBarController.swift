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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

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
        
       // self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.green
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PopulateDBfromJSON.getData(from: container, showAlertHandler: {
            showAlertUpdateDatabase()
        }, hideAlertHandler: {
            self.dismiss(animated: true, completion: nil)
        }) {
            self.prepareFirstTabForUse()
        }
    }

    // return to root controller when a tab is selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    func showAlertUpdateDatabase(){
        let alert = UIAlertController(title: Constants.alertUpdateDatabaseTitle.rawValue, message: Constants.alertUpdateDatabaseMessage.rawValue, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func prepareFirstTabForUse(){
        // get the controller of the first tab and setCharacterOfTheDay
        if let navController = self.viewControllers?[0] as? UINavigationController{
            if let testController = navController.children.first as? HomeViewController{
                testController.setCharacterOfTheDay()
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

}

