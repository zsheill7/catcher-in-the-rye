//
//  GameState.swift
//  PokeJump
//
//  Created by Apple on 5/28/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import Foundation
import SpriteKit

class GameState {
    var score: Int
    var highScore: Int
    var stars: Int
    

    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        stars = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        stars = defaults.integerForKey("stars")
    }
    
    func saveState() {
        //Update highScore if current score is greater
        
        highScore = max(score, highScore)
        
        // Store in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(stars, forKey: "stars")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}



