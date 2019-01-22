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
    
    static func getData(to context: NSManagedObjectContext)  {
        

        guard let url = URL(string: "https://api.myjson.com/bins/ylxfo") else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler:  { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{

                
                let myData = try JSONDecoder().decode([CodableHskFlashcardsModel].self, from: dataResponse)
   
                HskFlashcards.addFlashcardBunch(in: context, with: myData)
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }).resume()
        
        
    }
}
