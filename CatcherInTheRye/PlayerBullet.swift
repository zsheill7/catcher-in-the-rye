//
//  PlayerBullet.swift
//  CatcherInTheRye
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerBullet: Bullet {
    
    
    override init(imageName: String, bulletSound:String?){
        super.init(imageName: imageName, bulletSound: bulletSound)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.PlayerBullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
