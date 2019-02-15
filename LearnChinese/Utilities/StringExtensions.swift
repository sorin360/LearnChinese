//
//  StringExtensions.swift
//  LearnChinese
//
//  Created by Sorin Lica on 13/02/2019.
//  Copyright © 2019 Sorin Lica. All rights reserved.
//

import Foundation
import AVFoundation

extension String {
    
    static let synthesizer = AVSpeechSynthesizer()
    
    func speak(){
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.4
        
        String.synthesizer.stopSpeaking(at: .immediate)
        String.synthesizer.speak(utterance)
    }
}
