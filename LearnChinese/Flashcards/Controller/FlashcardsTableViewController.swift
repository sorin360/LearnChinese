//
//  FlashcardsTableViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 03/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit
import CoreData

class FlashcardsTableViewController: UITableViewController {
    

    var myFlshcardsBunchList: [MyFlashcards] = []
    var hskFlshcardsBunchList: [HskFlashcards] = []
   
    var segmentedControl: UISegmentedControl!
    var addButton: UIBarButtonItem!
    
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  myFlshcardsBunchList = MyFlashcards.retrieveData()
        hskFlshcardsBunchList = HskFlashcards.retrieveData()
        
        
      //  self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "flashcardsBunchCell")
        
        
        // setup segmentedControl
        let items = ["My Libraries", "HSKs"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        
        // setup addButton
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonAction))
        addButton.tintColor = UIColor.green
        navigationItem.rightBarButtonItem = addButton
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         myFlshcardsBunchList = MyFlashcards.retrieveData()
         self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return myFlshcardsBunchList.count
        default:
            return hskFlshcardsBunchList.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "flashcardsBunchCell")//, for: indexPath)
       // cell.editingStyle = UITableViewCell.CellStyle.value2
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "flashcardsBunchCell")
        }
        var knownCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var unknownCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        var inLibCountersAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            cell!.textLabel?.text = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"

            inLibCountersAttributedString = NSMutableAttributedString(string: "  " + String(myFlshcardsBunchList[indexPath.row].words?.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
          
        default:
            cell!.textLabel?.text = hskFlshcardsBunchList[indexPath.row].level ?? "Unknown"
            knownCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).veryKnown == true }.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)])
            unknownCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).veryKnown == false && ($0 as! Words).flashcard == nil}.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
            inLibCountersAttributedString = NSMutableAttributedString(string: "  " + String(hskFlshcardsBunchList[indexPath.row].words?.filter { ($0 as! Words).flashcard != nil }.count ?? 0), attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }
        
        
        let countersAttributedString = unknownCountersAttributedString
        
        
        countersAttributedString.append(inLibCountersAttributedString)
        countersAttributedString.append(knownCountersAttributedString)
        cell!.detailTextLabel?.attributedText = countersAttributedString
        return cell!
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                     MyFlashcards.delete(myFlashcards: myFlshcardsBunchList[indexPath.row])
                myFlshcardsBunchList.remove(at: indexPath.row)
                 tableView.deleteRows(at: [indexPath], with: .fade)
           
            default:
                break
              //  hskFlshcardsBunchList.remove(at: indexPath.row)

              //  cell.textLabel?.text =NSMutableAttributedString hskFlshcardsBunchList[indexPath.row].level ?? "Unknown"
            }

            //flshcardsBunchList.remove(at: indexPath.row)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = FlashcardsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                destination.selectedSegmentIndex = 0
                destination.selectedIndex = indexPath.row
                destination.navigationItem.title = myFlshcardsBunchList[indexPath.row].name ?? "Unknown"
            default:
                destination.selectedSegmentIndex = 1
                destination.selectedIndex = indexPath.row
                destination.navigationItem.title = hskFlshcardsBunchList[indexPath.row].level ?? "Unknown"
                
            }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.pushViewController(destination, animated: true)
        
  
            // TO DO: do not get all the words
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if let selectedCellIndex = tableView.indexPath(for: selectedCell) {
                if let destination = segue.destination as? FlashcardsCollectionViewController {
                    
                   switch segmentedControl.selectedSegmentIndex {
                    case 0:
                        destination.selectedSegmentIndex = 0
                        destination.selectedIndex = selectedCellIndex.row
                        destination.navigationItem.title = myFlshcardsBunchList[selectedCellIndex.row].name ?? "Unknown"
                        // = myFlshcardsBunchList[selectedCellIndex.row].
                    //    destination.words = myFlshcardsBunchList[selectedCellIndex.row].words?.allObjects as? [Words] ?? []
                        
                    // print(myFlshcardsBunchList[selectedCellIndex.row])
                    default:
                        destination.selectedSegmentIndex = 1
                        destination.selectedIndex = selectedCellIndex.row
                        destination.navigationItem.title = hskFlshcardsBunchList[selectedCellIndex.row].level ?? "Unknown"// = hskFlshcardsBunchList[selectedCellIndex.row]
                       // destination.words = hskFlshcardsBunchList[selectedCellIndex.row].words?.allObjects as? [Words] ?? []
                        //  print(hskFlshcardsBunchList[selectedCellIndex.row].words?.allObjects)
                        
                    }
                    // TO DO: do not get all the words
                }
            }
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
*/
    @objc func addButtonAction() {
        
        
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
                _ = MyFlashcards.addFlashcardBunch(in: context, with: input ?? "Unknown")
                //  HskFlashcards.addFlashcardBunch(in: context, with: input ?? "Unknown")
                //self.myFlshcardsBunchList.append(newLib)
                DispatchQueue.main.async {
                    self.myFlshcardsBunchList = MyFlashcards.retrieveData()
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    
    @objc func segmentChanged() {
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //  flshcardsBunchList = ["list1", "list2", "list3"]
          /*  flshcardsBunchList = []
            for flashcard in myFlshcardsBunchList {
                flshcardsBunchList += [flashcard.name ?? "Unknown"]
            }*/
            tableView.reloadData()
            addButton.isEnabled = true
        default:
            //flshcardsBunchList = ["hsk 1", "hsk 2", "hsk 3"]
         /*   flshcardsBunchList = []
            for flashcard in hskFlshcardsBunchList {
                flshcardsBunchList += [flashcard.level ?? "Unknown"]
            }*/
            tableView.reloadData()
            addButton.isEnabled = false
        }
    }
    
}
/*
extension UITableViewController {
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
*/
