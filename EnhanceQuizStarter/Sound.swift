//
//  Sound.swift
//  EnhanceQuizStarter
//
//  Created by Kate Duncan-Welke on 10/13/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import AudioToolbox

struct Sound {
    var number: SystemSoundID
    var resourceName: String
    var type: String
    
    static func loadSound(resourceName: String, type: String, number: inout SystemSoundID) {
        let path = Bundle.main.path(forResource: resourceName, ofType: type)
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &number)
    }
    
    static func playSound(number: SystemSoundID) {
        AudioServicesPlaySystemSound(number)
    }
}

var gameSound = Sound(number: 0, resourceName: "GameSound", type: "wav")
var wrongSound = Sound(number: 1, resourceName: "error", type: "wav")
var rightSound = Sound(number: 2, resourceName: "good", type: "wav")
var endSound = Sound(number: 3, resourceName: "select", type: "wav")
