//
//  tesrViewController.swift
//  LearnChinese
//
//  Created by Sorin Lica on 16/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class tesrViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var progress: UIProgressView! {
        didSet{
            
        
              progress.progress = 0.6
    }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
