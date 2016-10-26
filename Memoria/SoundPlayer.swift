//
//  SoundPlayer.swift
//  Memoria
//
//  Created by Matan Cohen on 25/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    
    class func playSystemSound() {
        // create a sound ID, in this case its the tweet sound.
        let systemSoundID: SystemSoundID = 1016
        
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
}
