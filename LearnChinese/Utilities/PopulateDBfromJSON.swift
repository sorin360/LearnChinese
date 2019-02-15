//
//  PopulateDBfromJSON.swift
//  LearnChinese
//
//  Created by Sorin Lica on 09/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import Foundation
import CoreData

class PopulateDBfromJSON {

    static func getData(from container: NSPersistentContainer?,
                        showAlertHandler: (() -> Void),
                        hideAlertHandler: @escaping (() -> Void),
                        readyToUseHandler: @escaping (() -> Void))  {
        

        var downloadEnd = false
        
        let firstUse = UserDefaults.standard.bool(forKey: Constants.firstUseKey.rawValue)
        
        if !firstUse {
            
            showAlertHandler()
            
            container?.performBackgroundTask(){ context in
                guard let urlWords = URL(string: Constants.wordsUrl.rawValue) else {return}
                
                URLSession.shared.dataTask(with: urlWords, completionHandler:  { (data, response, error) in
                    guard let dataResponse = data, error == nil else { return }
                    do{
                        let decodedData = try JSONDecoder().decode([CodableHskFlashcardsModel].self, from: dataResponse)
                        
                        HskLibraries.add(data: decodedData, in: context)
                        
                        DispatchQueue.main.async {
                            if downloadEnd {
                                hideAlertHandler()
                                readyToUseHandler()
                            } else {
                                downloadEnd = true
                            }
                        }
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }).resume()
                
                guard let urlSentences = URL(string: Constants.sentencesUrl.rawValue) else {return}
                
                URLSession.shared.dataTask(with: urlSentences, completionHandler:  { (data, response, error) in
                    
                    guard let dataResponse = data, error == nil else { return }
                    do{
                        let decodedData = try JSONDecoder().decode([CodableSentencesModel].self, from: dataResponse)
                        
                        Sentences.add(data: decodedData)
                        DispatchQueue.main.async {
                            if downloadEnd {
                                hideAlertHandler()
                                readyToUseHandler()
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
}
