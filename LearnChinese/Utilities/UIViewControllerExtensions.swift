//
//  UIViewControllerExtensions.swift
//  LearnChinese
//
//  Created by Sorin Lica on 05/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

extension UIViewController {
    func showMessageDialog(title:String? = nil,
                           subtitle:String? = nil,
                           actionTitle:String? = "OK",
                           cancelActionTitle:String? ,
                           actionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            actionHandler?()
        }))
        if cancelActionTitle != nil {
            alert.addAction(UIAlertAction(title: cancelActionTitle, style: .destructive, handler: { (action:UIAlertAction) in
                return
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showWrongAnswerDialog(title:String? = nil,
                               subtitle:String? = nil,
                               answer:String? = nil,
                               actionHandler: ((_ text: String?) -> Void)? = nil){
        
        let actionTitleSkip:String? = "Skip"
        let actionTitleRetry:String? = "Retry"
        let actionTitleAnswer:String? = "Correct Answer"
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitleSkip, style: .destructive, handler: { (action:UIAlertAction) in
            actionHandler?("Skip")
            return
        }))
        
        alert.addAction(UIAlertAction(title: actionTitleRetry, style: .destructive, handler: { (action:UIAlertAction) in
            actionHandler?("Retry")
            return
        }))
        
        alert.addAction(UIAlertAction(title: actionTitleAnswer, style: .destructive, handler: { (action:UIAlertAction) in
            self.showMessageDialog(title: "Correct answer:",
                                   subtitle: "\(String(describing: answer ?? "" ))",
                actionTitle: "OK", cancelActionTitle: nil)
            { () in
                actionHandler?("Skip")
                return
            }
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
