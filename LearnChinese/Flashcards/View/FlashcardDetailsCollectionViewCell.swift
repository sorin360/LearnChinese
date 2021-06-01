//
//  FlashcardDetailsCollectionViewCell.swift
//  LearnChinese
//
//  Created by Sorin Lica on 10/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class FlashcardDetailsCollectionViewCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
   
    var word: Words? {
        didSet{
            if word?.veryKnown != nil && (word?.veryKnown)! {
                addToLibraryButtonCollectionCell.isHidden = true
            } else {
                addToLibraryButtonCollectionCell.isHidden = false
            }
        }
    }
    var myLibraries: [MyLibraries] = []
    
    private var row = 0
    
    var hanziLabelCollectionCell: UILabel = {
        var hanziLabel = UILabel()
        hanziLabel.font = hanziLabel.font.withSize(35)
        hanziLabel.textAlignment = .center
        hanziLabel.translatesAutoresizingMaskIntoConstraints = false
        return hanziLabel
    }()
    
    var pinyinLabelCollectionCell: UILabel = {
        var pinyinLabel = UILabel()
        pinyinLabel.font = pinyinLabel.font.withSize(20)
        pinyinLabel.textAlignment = .center
        pinyinLabel.translatesAutoresizingMaskIntoConstraints = false
        return pinyinLabel
    }()
    var translationLabelColectionCell: UILabel = {
        var translationLabel = UILabel()
        translationLabel.font = translationLabel.font.withSize(20)
        translationLabel.textAlignment = .center
        translationLabel.lineBreakMode = .byWordWrapping
        translationLabel.numberOfLines = 0
        translationLabel.translatesAutoresizingMaskIntoConstraints = false
        return translationLabel
    }()
    
    var choseLibraryTextField: UITextField = {
        var choseLibrary = UITextField()
        choseLibrary.translatesAutoresizingMaskIntoConstraints = false
        return choseLibrary
    }()
    var speakerButtonCollectionCell: UIButton = {
        var button = UIButton()
     
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.cornerRadius = 10.0
      
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addToLibraryButtonCollectionCell: UIButton = {
        var addToLibraryButton = UIButton()
        addToLibraryButton.layer.cornerRadius = 10.0
        addToLibraryButton.layer.borderWidth = 1.0
        addToLibraryButton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        addToLibraryButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addToLibraryButton.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    
        addToLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        return addToLibraryButton
    }()
    
    var iKnowitButtonCollectionCell: UIButton = {
        var iKnowItButton = UIButton()
        iKnowItButton.layer.cornerRadius = 10.0
        iKnowItButton.layer.borderWidth = 1.0
        iKnowItButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        iKnowItButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        iKnowItButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        iKnowItButton.translatesAutoresizingMaskIntoConstraints = false
        return iKnowItButton
    }()
    
    var myPickerView : UIPickerView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        myLibraries = MyLibraries.retrieveData()
        
        addToLibraryButtonCollectionCell.addTarget(self, action: #selector(self.AddRemoveToLibraryButton), for: UIControl.Event.touchDown)
        iKnowitButtonCollectionCell.addTarget(self, action: #selector(self.IknowitButton), for: UIControl.Event.touchDown)
        speakerButtonCollectionCell.addTarget(self, action: #selector(self.speakerButtonAction), for: UIControl.Event.touchDown)
        
        self.choseLibraryTextField.delegate = self
        self.choseLibraryTextField.isHidden = true
        
        self.backgroundColor = UIColor.white
        
        //Stack View
        let mainStackView = UIStackView()
        mainStackView.axis = NSLayoutConstraint.Axis.vertical
        mainStackView.distribution = UIStackView.Distribution.equalSpacing
        mainStackView.alignment = UIStackView.Alignment.center
        mainStackView.spacing = 2.0
        
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = NSLayoutConstraint.Axis.horizontal
        buttonsStackView.distribution = UIStackView.Distribution.fillEqually
        buttonsStackView.alignment = UIStackView.Alignment.center
        buttonsStackView.spacing = 1.0
        buttonsStackView.addArrangedSubview(addToLibraryButtonCollectionCell)
        buttonsStackView.addArrangedSubview(iKnowitButtonCollectionCell)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hanziPinyinStackView = UIStackView()
        hanziPinyinStackView.axis = NSLayoutConstraint.Axis.vertical
        hanziPinyinStackView.distribution = UIStackView.Distribution.equalSpacing
        hanziPinyinStackView.alignment = UIStackView.Alignment.center
        hanziPinyinStackView.spacing = 2.0
        hanziPinyinStackView.addArrangedSubview(hanziLabelCollectionCell)
        hanziPinyinStackView.addArrangedSubview(pinyinLabelCollectionCell)
        hanziPinyinStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        mainStackView.addArrangedSubview(hanziPinyinStackView)
        mainStackView.addArrangedSubview(speakerButtonCollectionCell)
        mainStackView.addArrangedSubview(translationLabelColectionCell)
        mainStackView.addArrangedSubview(buttonsStackView)
        mainStackView.addArrangedSubview(choseLibraryTextField)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainStackView)
        translationLabelColectionCell.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        speakerButtonCollectionCell.heightAnchor.constraint(equalToConstant: 50).isActive = true
        speakerButtonCollectionCell.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true //, multiplier:
        buttonsStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonsStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height / 8).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0 - self.frame.height / 8
            ).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    @objc func speakerButtonAction(){
        hanziLabelCollectionCell.text?.speak()
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
    
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        self.bringSubviewToFront(myPickerView)
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
            if myLibraries.count > row {
                myLibraries[row].addToWords(newWord)
                MyLibraries.update(myLibraries: myLibraries[row])
                addToLibraryButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "Remove from library"), for: .normal)
            }
        }
    }
    
    @objc func cancelClick() {
        choseLibraryTextField.resignFirstResponder()
        self.superview?.layoutSubviews()
    }
 
    @objc func newLibrary(){
        
        showInputDialog(title: "Add library",
                        subtitle: "Please enter the name below.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Name",
                        inputKeyboardType: .alphabet, actionHandler:
                            { (input:String?) in
                                _ = MyLibraries.addLibrary(with: input ?? "Unknown")
                                self.myLibraries = MyLibraries.retrieveData()
                                self.myPickerView.reloadAllComponents()
                            })
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
            if textField.text != "" {
                actionHandler?(textField.text)
            }
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    
    @objc func AddRemoveToLibraryButton() {
        if (word?.myLibraries) != nil {
            MyLibraries.remove(word: word!)
            addToLibraryButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "Add to library"), for: .normal)
        }
        else {
            choseLibraryTextField.becomeFirstResponder()
        }
    }
    
    @objc func IknowitButton() {

        if (word?.veryKnown)! {
            UIView.transition(with: addToLibraryButtonCollectionCell, duration: 0.5, options: .showHideTransitionViews, animations: {
                self.addToLibraryButtonCollectionCell.isHidden = false
            })
            word?.veryKnown = false
            iKnowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I know it"), for: .normal)
        } else {
            UIView.transition(with: addToLibraryButtonCollectionCell, duration: 0.5, options: .showHideTransitionViews, animations: {
                self.addToLibraryButtonCollectionCell.isHidden = true
            })
                
            if let library = word?.myLibraries {
                library.removeFromWords(word!)
            }
            word?.veryKnown = true
            addToLibraryButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "Add to library"), for: .normal)
            iKnowitButtonCollectionCell.setAttributedTitle(NSAttributedString(string: "I don't know it"), for: .normal)
        }
        Words.update(with: word!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myLibraries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myLibraries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row = row
    }
    
    
}
