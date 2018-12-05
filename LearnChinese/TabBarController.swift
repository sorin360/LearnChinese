//
//  ViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 03/12/2018.
//  Copyright © 2018 Sorin Lica. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let list = [1,2,3,4,5]
        let findList = [1,3,5]
        let listSet = Set(list)
        let findListSet = Set(findList)
        
        let allElemsContained = findListSet.isSubset(of: listSet)
        print(allElemsContained)
    }


}

