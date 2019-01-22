//
//  FlashcardDetailsCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class FlashcardDetailsCollectionViewCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
     var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
   
    var word: Words? {
        didSet{
            if word?.veryKnown != nil && (word?.veryKnown)! {
                AddToLibraryButton.isHidden = true
            } else {
                AddToLibraryButton.isHidden = false
            }
        }
    }
    var myFlashcards: [MyFlashcards] = []
    private var row = 0
    
    @IBOutlet weak var hanziLabelCollectionCell: UILabel?
    @IBOutlet weak var pinyinLabelCollectionCell: UILabel!
    @IBOutlet weak var translationLabelColectionCell: UILabel!
    
 
    @IBOutlet weak var choseLibraryTextField: UITextField!
    var myPickerView : UIPickerView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myFlashcards = MyFlashcards.retrieveData()
        self.choseLibraryTextField.delegate = self
        self.choseLibraryTextField.isHidden = true
        
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
    
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(FlashcardDetailsCollectionViewCell.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
          let newLibraryButton = UIBarButtonItem(title: "New Library", style: .done, target: self, action: #selector(FlashcardDetailsCollectionViewCell.newLibrary))
     
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(FlashcardDetailsCollectionViewCell.cancelClick))
        toolBar.setItems([cancelButton, spaceButton,newLibraryButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(choseLibraryTextField)
    }
    
    @objc func doneClick() {
        choseLibraryTextField.resignFirstResponder()
        if let newWord = word {
            if myFlashcards.count > row {
                myFlashcards[row].addToWords(newWord)
                MyFlashcards.update(myFlashcards: myFlashcards[row])
                AddToLibraryButton.setAttributedTitle(NSAttributedString(string: "Remove from library"), for: .normal)
            }
        }
    }
    @objc func cancelClick() {
        choseLibraryTextField.resignFirstResponder()
    }
 
    @objc func newLibrary(){
        
        showInputDialog(title: "Add library",
                        subtitle: "Please enter the name below.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Name",
                        inputKeyboardType: .alphabet)
        { (input:String?) in
            
            /* self.myFlshcardsBunchList = MyFlashcards.retrieveData()
             self.tableView.reloadData()
             */
            self.container?.performBackgroundTask(){ context in
                MyFlashcards.addFlashcardBunch(in: context, with: input ?? "Unknown")
                //  HskFlashcards.addFlashcardBunch(in: context, with: input ?? "Unknown")
                
                DispatchQueue.main.async {
                    self.myFlashcards = MyFlashcards.retrieveData()
                    self.choseLibraryTextField.resignFirstResponder()
                    self.choseLibraryTextField.becomeFirstResponder()
                }
            }
        }
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
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var AddToLibraryButton: UIButton!{
        didSet {
            AddToLibraryButton.layer.cornerRadius = 10.0
            AddToLibraryButton.layer.borderWidth = 1.0
            AddToLibraryButton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            AddToLibraryButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            AddToLibraryButton.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
        }
    }
    @IBOutlet weak var IknowitButtonCollectionCell: UIButton! {
        didSet {
            IknowitButtonCollectionCell.layer.cornerRadius = 10.0
            IknowitButtonCollectionCell.layer.borderWidth = 1.0
            IknowitButtonCollectionCell.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
             IknowitButtonCollectionCell.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             IknowitButtonCollectionCell.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

        }
    }
    
    @IBAction func AddRemoveToLibraryButton(_ sender: Any) {
        if let flashcard = word?.flashcard {
            flashcard.removeFromWords(word!)
            AddToLibraryButton.setAttributedTitle(NSAttributedString(string: "Add to library"), for: .normal)

        }
        else {
            choseLibraryTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func IknowitButton(_ sender: UIButton) {
        if let newWord = word {
            if newWord.veryKnown {
                newWord.veryKnown = false
                word?.veryKnown = false
                IknowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I know it"), for: .normal)
               // AddToLibraryButton.isHidden = false
                UIView.transition(with: AddToLibraryButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.AddToLibraryButton.isHidden = false
                })
            }
            else {
                UIView.transition(with: AddToLibraryButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.AddToLibraryButton.isHidden = true
                })
                
                if let flashcard = word?.flashcard {
                    flashcard.removeFromWords(word!)
                } // remove the word from flashcards
                
                newWord.veryKnown = true
                word?.veryKnown = true
                IknowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I don't know it"), for: .normal)
                
            }
            Words.update(with: newWord)
        }
       
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myFlashcards.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myFlashcards[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row = row
    }
    
    
}
