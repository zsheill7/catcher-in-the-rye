//
//  Children.swift
//  CatcherInTheRye
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import UIKit
import SpriteKit

class Invader: SKSpriteNode {
    var invaderRow = 0
    var invaderColumn = 0
    
    init() {
        let texture = SKTexture(imageNamed: "spencer")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "invader"
        self.physicsBody =
            SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Invader
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireBullet(scene: SKScene) {
        let bullet = InvaderBullet(imageName: "vick's",bulletSound: nil)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y - self.size.height/2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.moveTo(CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 3.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([moveBulletAction,removeBulletAction]))
    }
}
