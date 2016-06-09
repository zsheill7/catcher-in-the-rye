//
//  Child.swift
//  CatcherInTheRye
//
//  Created by Zoe on 6/7/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import UIKit
import SpriteKit

class Child: SKSpriteNode {
    var childRow = 0
    var childColumn = 0
    
    init() {
        let texture = SKTexture(imageNamed: "child.gif")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "child"
        self.physicsBody =
            SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Child
        self.physicsBody?.contactTestBitMask = CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

