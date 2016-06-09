//
//  GameScene.swift
//  CatcherInTheRye
//
//  Created by Apple on 5/29/16.
//  Copyright (c) 2016 zsheill7. All rights reserved.
//

import SpriteKit


var invaderNum = 1
var childNum = 1
var score = 0
var lastTouch: CGPoint? = nil
// At the top of your code
let xPlayerForce = 20.0
let yPlayerForce = 30.0
var hudNode: SKNode!
var lblScore: SKLabelNode!
//let scale = 0.5
struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let Child: UInt32 = 0x1 << 4
    
}
/*class ChildNode: GameObjectNode {
    
    let starSound = SKAction.playSoundFileNamed("StarPing.wav", waitForCompletion: false)
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        // Boost the player up
        
        // Remove this Star
        runAction(starSound, completion: {
            self.removeFromParent()
        })
        
        // Award score
        GameState.sharedInstance.score += 1

        
        // The HUD needs updating to show the new stars and score
        return true
    }
}*/

class GameScene: SKScene, SKPhysicsContactDelegate {
    let rowsOfInvaders = 1
    var invaderSpeed = 2
    var childxSpeed = 3
    var childySpeed = 1
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = []
    let player:Player = Player()
    let maxLevels = 3
    let tempChild:Child = Child()
    
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0) //change this later to affect bullets: affectedByGravity
        self.physicsWorld.contactDelegate = self
        //backgroundColor = SKColor.blackColor()
        //let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        //backgroundImage.image = UIImage(named: "background.png")
        //self.view!.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "background")
        
        self.view!.insertSubview(backgroundImage, atIndex: 4)
        //self.view!.insertSubview(backgroundImage, atIndex: 0)
        
        //func sendSubviewToBack(_ view: UIView)
        rightBounds = self.size.width - 30
        setupInvaders()
        setupPlayer()
        setupChild()
        setupHUD()
        invokeInvaderFire()
    }
    
    var location = CGPoint(x: 0.0, y: 0.0)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       //Called when touch begins
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastTouch = nil
    }

    override func update(currentTime: CFTimeInterval) {
        moveInvaders()
        moveChild()
        let xForce: CGFloat = 8.0
        if let touch = lastTouch {
            let xOffset = (touch.x - player.position.x)*0.1
            let yOffset = (touch.y - player.position.y)*0.05
            
            var impulseVector = CGVector(dx: xOffset, dy: yOffset)
            if (xOffset > xForce && yOffset > 4.0) {
                impulseVector = CGVector(dx: xForce, dy: 2.0)
            } else if (xOffset > xForce) {
                impulseVector = CGVector(dx: xForce, dy: yOffset)
            } else if (yOffset > 4.0) {
                impulseVector = CGVector(dx: xOffset, dy: 4.0)
            }
            
            player.physicsBody?.applyImpulse(impulseVector)
        }
        if player.position.x <= 0.0 {
            player.position = CGPoint(x: 0.0, y: player.position.y)
        } else if (player.position.x >= self.size.width) {
            player.position = CGPoint(x: self.size.width, y: player.position.y)
        }
        if player.position.y <= 0.0 {
            player.position = CGPoint(x: player.position.x, y: 0.0)
        } else if (player.position.y >= self.size.height) {
            player.position = CGPoint(x: player.position.x, y: self.size.height)
        }
    }
    /*override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        moveInvaders()
        if let touch = lastTouch {
            var xForce = 0.0
            var yForce = 0.0
            let xTouchOffset = (touch.x - player.position.x)
            let yTouchOffset = (touch.y - player.position.y)
            
            if xTouchOffset > 0.0 {
                xForce = xPlayerForce
            } else if xTouchOffset < 0.0 {
                xForce = -xPlayerForce
            } // else we do nothing
            
            if yTouchOffset > 0.0 {
                yForce = yPlayerForce
            } else if yTouchOffset < 0.0 {
                yForce = -yPlayerForce
            }
            
            let impulseVector = CGVector(dx: xForce, dy: yForce)
            player.physicsBody?.applyImpulse(impulseVector)
        }
    }*/
    
    func setupInvaders(){
        var invaderRow = 0;
        var invaderColumn = 0;
        let numberOfInvaders = invaderNum
        for var i = 1; i <= rowsOfInvaders; i++ {
            invaderRow = i
            for var j = 1; j <= numberOfInvaders; j++ {
                invaderColumn = j
                let tempInvader:Invader = Invader()
                let invaderHalfWidth:CGFloat = tempInvader.size.width/2
                let xPositionStart:CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(invaderNum) * tempInvader.size.width) + CGFloat(10) + 300
                tempInvader.position = CGPoint(x:xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46) - 120)
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
                if(i == rowsOfInvaders){
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
        
    }
    
    func setupChild(){
        //var childRow = 0;
        //var childColumn = 0;
        //let numberOfInvaders =  childNum
        
                let invaderHalfWidth:CGFloat = tempChild.size.width/2
                let xPositionStart:CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(invaderNum) * tempChild.size.width) + CGFloat(10) + 500
                tempChild.position = CGPoint(x:xPositionStart + ((tempChild.size.width+CGFloat(10))*(CGFloat(0))), y:CGFloat(self.size.height - CGFloat(1) * 46))
                //tempChild.childRow = childRow
                //tempChild.childColumn = childColumn
                addChild(tempChild)
        
    }
    
    
    func setupHUD(){
        hudNode = SKNode()
        addChild(hudNode)
        lblScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        lblScore.fontSize = 30
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        
        // 5
        lblScore.text = "Children saved: 0"
        hudNode.addChild(lblScore)

    }
    
    func updateHUD(){
        if (lblScore.text == "Children saved: 0") {
            lblScore.text = "Children saved: 1"
        }
        else if (lblScore.text == "Children saved: 1") {
            lblScore.text = "Children saved: 2"
        }
        else if (lblScore.text == "Children saved: 2") {
            lblScore.text = "Children saved: 3"
        }
        else if (lblScore.text == "Children saved: 3") {
            lblScore.text = "Children saved: 4"
        }
        else if (lblScore.text == "Children saved: 4") {
            lblScore.text = "Children saved: 5"
        }
        else if (lblScore.text == "Children saved: 5") {
            lblScore.text = "Children saved: 6"
            invaderNum += 1
            //setupInvaders()
        }
        else if (lblScore.text == "Children saved: 6") {
            lblScore.text = "Children saved: 7"
        }
        else if (lblScore.text == "Children saved: 7") {
            lblScore.text = "Children saved: 8"
        }
        else if (lblScore.text == "Children saved: 8") {
            lblScore.text = "Children saved: 9"
            
        }
    }
/*
 FIX THIS SECTION FOR NO STRING CHANGING
     
 */
    
     func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
            NSLog("Invader and Player Bullet Contact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            NSLog("Player and Invader Bullet Contact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            NSLog("Invader and Player Collision Contact")
            
        }
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Child != 0)) {
            NSLog("Child and Player Collision Contact")
            
        }
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            player.die()
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            player.kill()
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Child != 0)) {
            updateHUD()

            
            self.tempChild.removeFromParent()
             delay(3.0) {
                self.setupChild()
            }
            // Award score
            GameState.sharedInstance.score += 1
            

        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            
            //let invadersPerRow = invaderNum * 2 + 1
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            //let newInvaderColumn = theInvader.invaderColumn
            if(newInvaderRow >= 1){
                self.enumerateChildNodesWithName("invader") { node, stop in
                    let invader = node as! Invader
                    
                        self.invadersWhoCanFire.append(invader)
                        stop.memory = true
                    
                }
            }
            
        }
    }
    
    func setupPlayer(){
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:player.size.height/2 + 10)
        addChild(player)
    }
    
    func moveInvaders(){
        var changeDirection = false
        enumerateChildNodesWithName("invader") { node, stop in
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if(invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth){
                changeDirection = true
            }
            
        }
        
        if(changeDirection == true){
            self.invaderSpeed *= -1
            self.enumerateChildNodesWithName("invader") { node, stop in
                let invader = node as! SKSpriteNode
                invader.position.y -= CGFloat(10)
            }
            changeDirection = false
        }
        
    }
    
    func moveChild(){
        var changeDirection = false
        enumerateChildNodesWithName("child") { node, stop in
            let child = node as! SKSpriteNode
            let childHalfWidth = child.size.width/2
            child.position.x -= CGFloat(self.childxSpeed)
            child.position.y -= CGFloat(self.childySpeed)
            if(child.position.x > self.rightBounds - childHalfWidth || child.position.x < self.leftBounds + childHalfWidth){
                changeDirection = true
            }
            
        }
        
        if(changeDirection == true){
            self.childxSpeed *= -1
            //self.childySpeed *= -1
            self.enumerateChildNodesWithName("child") { node, stop in
                let child = node as! SKSpriteNode
                //child.position.y -= CGFloat(46)
            }
            changeDirection = false
        }
        
    }

    
    func invokeInvaderFire(){
        let fireBullet = SKAction.runBlock(){
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.waitForDuration(4)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatActionForever(invaderFire)
        runAction(repeatForeverAction)
    }
    
    func fireInvaderBullet(){
        if(invadersWhoCanFire.isEmpty){
            invaderNum += 1
            levelComplete()
        }else{
        let randomInvader = invadersWhoCanFire.randomElement()
        randomInvader.fireBullet(self)
        }
    }
    
    func levelComplete(){
        if(invaderNum <= maxLevels){
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
            view?.presentScene(levelCompleteScene,transition: transitionType)
        }else{
            invaderNum = 1
            newGame()
        }
        
    }
    
    func newGame(){
        let gameOverScene = StartGameScene(size: size)
        gameOverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(gameOverScene,transition: transitionType)
    }
    
    
}