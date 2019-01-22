//
//  FlashcardsCollectionViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 04/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlashcardsCollectionViewController: UICollectionViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

   
    var myPickerView : UIPickerView!
    
    var pickerOptionTextField = UITextField()
    
    var words: [Words] = [] 
    var selectedSegmentIndex = -1
    var selectedIndex = 0
    var pickerViewOptions = [String]()
    private var row = 0
    
   
    @IBOutlet weak var filterButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pickerOptionTextField)
        self.pickerOptionTextField.delegate = self
        self.pickerOptionTextField.isHidden = true
      //  self.collectionView.scr
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch selectedSegmentIndex {
        case 0:
             words = MyFlashcards.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
             filterButtonOutlet.isEnabled = false
             filterButtonOutlet.tintColor = .clear
           // filterButtonOutlet.view
      
        case 1:
             words = HskFlashcards.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
             filterButtonOutlet.isEnabled = true
             filterButtonOutlet.tintColor = nil
        default:
             words = Words.getKnownWords()
             filterButtonOutlet.isEnabled = false
             filterButtonOutlet.tintColor = .clear
             
            
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
    
    @IBAction func sortCellsButton(_ sender: UIBarButtonItem) {

       // pickerViewOptions = ["Ascending by hanzi","Descending by hanzi", "Ascending by pinyin", "Descending by hanzi", "Ascending by priority", "Descending by priority"]
        pickerViewOptions = SortBy.allCases.map{$0.rawValue}
        pickerOptionTextField.becomeFirstResponder()
       
    }
  
    @IBAction func filterCellsButton(_ sender: UIBarButtonItem) {
        
        pickerViewOptions =  Filters.allCases.map{$0.rawValue}
        pickerOptionTextField.becomeFirstResponder()
        
    }
    @objc func doneClick() {
     //sort or filter
       
        if pickerViewOptions == Filters.allCases.map{$0.rawValue} {
            
            switch selectedSegmentIndex {
            case 0:
                words = MyFlashcards.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
            case 1:
                words = HskFlashcards.retrieveData()[selectedIndex].words?.allObjects as? [Words] ?? []
            default:
                words = Words.getKnownWords()
            }
            
            switch Filters.allCases[row] {
            case .inLibrary:
                words = words.filter { $0.flashcard != nil }
            case .known:
                words = words.filter { $0.veryKnown == true }
            case .unknown:
                words = words.filter { $0.veryKnown != true }
                words = words.filter { $0.flashcard == nil }
            default:
                break
            }
        } else {
            switch SortBy.allCases[row] {
            case .pinyinAsc:
                words.sort(by: {($0.pinyin ?? "") < ($1.pinyin ?? "")})
            case .pinyinDes:
                words.sort(by: {($0.pinyin ?? "") > ($1.pinyin ?? "")})
            default:
                break
            }
          
        }
        row = 0
        
        pickerOptionTextField.resignFirstResponder()
        self.collectionView.reloadData()
       
        self.collectionView.contentOffset = CGPoint(x: 0, y: 0 - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height)
        // .scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    @objc func cancelClick() {
        pickerOptionTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
            destination.words = words
        }
        
        if let selectedCell = sender as? FlashcardCollectionViewCell {
            if let selectedCellIndex = collectionView.indexPath(for: selectedCell) {
                if let destination = segue.destination as? FlashcardDetailsCollectionViewController {
                    
                    destination.words = words
                    destination.indexPath = selectedCellIndex
                    
                }
                // TO DO: do not get all the words
            }
        }
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return words.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flashcardCell", for: indexPath) as! FlashcardCollectionViewCell
        // if let flashcardCell = cell as? FlashcardCollectionViewCell {
       // cell.hanziLabelCollectionCell.text = words[indexPath.row].chinese ?? ""
        cell.pinyinLabelCollectionCell.text = words[indexPath.row].pinyin ?? ""
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
    
        if words[indexPath.row].veryKnown{
            cell.layer.borderColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)])
        }
        else if words[indexPath.row].flashcard != nil {
                cell.layer.borderColor = UIColor.red.cgColor
                cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            } else {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.hanziLabelCollectionCell.attributedText = NSAttributedString(string: words[indexPath.row].chinese ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
            }
       
    /*    else {
            cell.layer.borderColor = UIColor.green.cgColor
        }*/
        // cell.backgroundColor = UIColor.blue
        // }
        // Configure the cell
        
        return cell
    }
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
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
