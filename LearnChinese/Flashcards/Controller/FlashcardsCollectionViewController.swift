//
//  FlashcardsCollectionViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit



class FlashcardsCollectionViewController: UICollectionViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    
    private var myPickerView : UIPickerView!
    private var pickerOptionTextField = UITextField()
    
    private var filterCellsButton: UIBarButtonItem!
    private var sortCellsButton: UIBarButtonItem!
    
    private var words: [Words] = []
    private var selectedSegmentIndex = -1
    private var selectedIndex = 0
    private var pickerViewOptions = [String]()
    private var row = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pickerOptionTextField)
        self.pickerOptionTextField.delegate = self
        self.pickerOptionTextField.isHidden = true
        
        // setup navbar right buttons
        filterCellsButton = UIBarButtonItem(image: UIImage(named: "filter"
        ), style: .plain, target: self, action: #selector(self.filterCellsAction))
     
        sortCellsButton = UIBarButtonItem(image: UIImage(named: "sort"
        ), style: .plain, target: self, action: #selector(self.sortCellsAction))
 
        navigationItem.rightBarButtonItems = [sortCellsButton, filterCellsButton]
        navigationController?.navigationBar.tintColor = UIColor.green

        self.collectionView.register(FlashcardCollectionViewCell.self, forCellWithReuseIdentifier: "flashcardCell")
        
        self.collectionView.backgroundColor = UIColor.white
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch selectedSegmentIndex {
        case 0:
            words = MyLibraries.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
            filterCellsButton.isEnabled = false
            filterCellsButton.tintColor = .clear
        case 1:
            words = HskLibraries.getHskLibraries()[selectedIndex].words?.allObjects as? [Words] ?? []
            filterCellsButton.isEnabled = true
            filterCellsButton.tintColor = nil
        default:
            words = Words.getKnownWords()
            filterCellsButton.isEnabled = false
            filterCellsButton.tintColor = .clear
        }
        self.collectionView.reloadData()
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
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
        toolBar.setItems([cancelButton, spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(pickerOptionTextField)
    }
    
    @objc func sortCellsAction() {

        pickerViewOptions = SortBy.allCases.map{$0.rawValue}
        pickerOptionTextField.becomeFirstResponder()
    }
  
    @objc func filterCellsAction() {
        
        pickerViewOptions =  Filters.allCases.map{$0.rawValue}
        pickerOptionTextField.becomeFirstResponder()
        
    }
    
    @objc func doneClick() {
     //sort or filter
        if pickerViewOptions == Filters.allCases.map{$0.rawValue} {
            
            switch selectedSegmentIndex {
            case 0:
                words = MyLibraries.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
            case 1:
                words = HskLibraries.getHskLibraries()[selectedIndex].words?.allObjects as? [Words] ?? []
            default:
                words = Words.getKnownWords()
            }
            
            switch Filters.allCases[row] {
            case .inLibrary:
                words = words.filter { $0.myLibraries != nil }
            case .known:
                words = words.filter { $0.veryKnown == true }
            case .unknown:
                words = words.filter { $0.veryKnown != true }
                words = words.filter { $0.myLibraries == nil }
            default:
                break
            }
        } else {
            switch SortBy.allCases[row] {
            case .pinyinAsc:
                words.sort(by: {($0.pinyin ?? "") < ($1.pinyin ?? "")})
            case .pinyinDes:
                words.sort(by: {($0.pinyin ?? "") > ($1.pinyin ?? "")})
            }
          
        }
        row = 0
        pickerOptionTextField.resignFirstResponder()
        self.collectionView.reloadData()

    }
    @objc func cancelClick() {
        pickerOptionTextField.resignFirstResponder()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flashcardCell", for: indexPath) as! FlashcardCollectionViewCell
        cell.pinyinLabelCollectionCell.text = words[indexPath.row].pinyin ?? ""
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
 
        if words[indexPath.row].veryKnown{
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)])
            cell.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if words[indexPath.row].myLibraries != nil {
                cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
                cell.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
                cell.layer.borderColor = UIColor.blue.cgColor
            }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 85, height: 85)
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        let destination = FlashcardDetailsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())

        destination.words = words
      
        destination.indexPath = indexPath
 
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row = row
    }
}
