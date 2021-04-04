//
//  SoundService.swift
//  MatchGame_Exam
//
//  Created by Tsibulko on 24.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import Foundation
import AVFoundation

class SoundService {
    
    var audioPlayer:AVAudioPlayer?
    
    enum soundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSounds(effect:soundEffect) {
        
        var nameOfSound = ""
        
        switch effect {
        case .flip:
            nameOfSound = "cardflip"
        case .match:
            nameOfSound = "dingcorrect"
        case .nomatch:
            nameOfSound = "dingwrong"
        case .shuffle:
            nameOfSound = "shuffle"
            
        }//end of switch
        
        
        let soundBundlePath = Bundle.main.path(forResource: nameOfSound, ofType: ".wav")
        
        guard soundBundlePath != nil else {
            return
        }
        
        let soundURL = URL(fileURLWithPath: soundBundlePath!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
        catch {
            return
        }
    } //end of func playSounds()
    
} // end of class SoundService
