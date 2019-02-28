//
//  StripedView.swift
//  LearnChinese
//
//  Created by Sorin Lica on 29/01/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import UIKit

class StripedView: UIView {
    
    override func draw(_ rect: CGRect) {
 
        let color1 = UIColor.white
        let color1Width: CGFloat = 25
        let color1Height: CGFloat = 25
        let color2 = #colorLiteral(red: 0.8647956285, green: 0.8647956285, blue: 0.8647956285, alpha: 1)
        let color2Width: CGFloat = 1
        let color2Height: CGFloat = 1
        
        
        //// Set pattern tile orientation vertical.
        let patternWidth: CGFloat = min(color1Width, color2Width)
        let patternHeight: CGFloat = (color1Height + color2Height)
        
        //// Set pattern tile size.
        let patternSize = CGSize(width: patternWidth, height: patternHeight)
        
        //// Draw pattern tile
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)
        
        let color1Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: color1Width, height: color1Height))
        color1.setFill()
        color1Path.fill()
        
        let color2Path = UIBezierPath(rect: CGRect(x: 0, y: color1Height, width: color2Width, height: color2Height))
        color2.setFill()
        color2Path.fill()
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //// Draw pattern in view
        UIColor(patternImage: image!).setFill()
        context!.fill(rect)
    }
}
