//
//  PracticeViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 21/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

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
    
    
    
    @IBOutlet weak var textForTranslation: UILabel!
    
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
    
    func checkAction(){
        preconditionFailure("this methos must be overridden")
    }

    
 
    @IBAction func checkButton(_ sender: Any) {
        
        checkAction()
       
    }

    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        lifeStatus = 4
        self.view.backgroundColor = UIColor.white // UIColor(patternImage: image)
        super.viewDidLoad()
    }
}
