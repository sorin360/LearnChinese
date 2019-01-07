//
//  FlashcardDetailsCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class FlashcardDetailsCollectionViewCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
   
    var word: Words?
    var myFlashcards: [MyFlashcards] = []

    
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(FlashcardDetailsCollectionViewCell.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(choseLibraryTextField)
    }
    
    @objc func doneClick() {
        choseLibraryTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        choseLibraryTextField.resignFirstResponder()
    }
 
    
    @IBOutlet weak var AddToLibraryButton: UIButton!{
        didSet {
            AddToLibraryButton.layer.cornerRadius = 10.0
            AddToLibraryButton.layer.borderWidth = 1.0
            AddToLibraryButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    @IBOutlet weak var IknowitButtonCollectionCell: UIButton! {
        didSet {
            IknowitButtonCollectionCell.layer.cornerRadius = 10.0
            IknowitButtonCollectionCell.layer.borderWidth = 1.0
            IknowitButtonCollectionCell.layer.borderColor = UIColor.blue.cgColor
           
        }
    }
    
    @IBAction func AddToLibraryButton(_ sender: Any) {
        choseLibraryTextField.becomeFirstResponder()
    }
    
    @IBAction func IknowitButton(_ sender: UIButton) {
        if let newWord = word {
            if newWord.veryKnown {
                newWord.veryKnown = false
                IknowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I know it"), for: .normal)
            }
            else {
                newWord.veryKnown = true
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
        if let newWord = word {
            myFlashcards[row].addToWords(newWord)
            MyFlashcards.update(myFlashcards: myFlashcards[row])
        }
    }
    
    
}
