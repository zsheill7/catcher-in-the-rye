//
//  StartGameScene.swift
//  CatcherInTheRye
//
//  Created by Apple on 5/29/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPointMake(size.width/2,size.height/2 - 100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "startgame"){
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
}
