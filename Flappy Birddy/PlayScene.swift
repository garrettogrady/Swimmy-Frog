//
//  PlayScene.swift
//  Flappy Birddy
//
//  Created by Garrett O'Grady on 1/16/15.
//  Copyright (c) 2015 Garrett O'Grady. All rights reserved.
//

import SpriteKit
import UIKit
import GameKit


class PlayScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    var bird = SKSpriteNode()
    var gameIsPlaying = false
    var bg = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    var highScoreLabel = SKLabelNode()
    var newHighScore = SKLabelNode()
    var restart = SKSpriteNode()
    
    var gapGroup:UInt32 = 0 << 3
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var leaderButton = SKLabelNode()
    
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    
    var gameOver = 0
    
    var movingObjects = SKNode()
    

    override func didMoveToView(view: SKView) {
        
    
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        self.addChild(movingObjects)
        
        makeBackground()
        
        self.addChild(labelHolder)
        
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        scoreLabel.zPosition = 10
        
        
        
        var birdTexture = SKTexture(imageNamed: "flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame) - 100, y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = objectGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        bird.physicsBody?.collisionBitMask = gapGroup
        
        bird.zPosition = 10
        self.addChild(bird)
        
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        
        
    }
    
    //shows leaderboard screen
    func showLeader() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    func makeBackground() {
        var bgTexture = SKTexture(imageNamed: "bg.png")
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        
        for var i:CGFloat=0; i<3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.zPosition = -10
            
            bg.runAction(movebgForever)
            
            
            movingObjects.self.addChild(bg)
            
            
        }
    }
    
    func makePipes() {
        
        if(gameOver == 0) {
            let gapHeight = bird.size.height * 2.75
            
            var movementAmount = arc4random() % UInt32(self.frame.size.height / 3)
            
            var pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 6
            
            var speed = Double(score)
            
            var additions = CGFloat(Double((2) * ((speed/38.0) + 1)))
            
            var movePipes = SKAction.moveByX(-self.frame.size.width * additions, y: 0, duration: NSTimeInterval(self.frame.size.width / 50))
            
            var removePipes = SKAction.removeFromParent()
            
            var moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
            
            
            var pipe1Texture = SKTexture(imageNamed: "pipe1.png")
            var pipe1 = SKSpriteNode(texture: pipe1Texture)
            pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + pipeOffSet)
            pipe1.runAction(moveAndRemovePipes)
            pipe1.zPosition = -9
            pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width / 3.5, pipe1.size.height))
            pipe1.physicsBody?.dynamic = false
            pipe1.physicsBody?.categoryBitMask = objectGroup
            movingObjects.addChild(pipe1)
            
            var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
            var pipe2 = SKSpriteNode(texture: pipe2Texture)
            pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + pipeOffSet)
            pipe2.runAction(moveAndRemovePipes)
            pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe2.size.width / 3.5, pipe2.size.height))
            pipe2.physicsBody?.dynamic = false
            pipe2.zPosition = -9
            pipe2.physicsBody?.categoryBitMask = objectGroup
            movingObjects.addChild(pipe2)
            
            var gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width + 50, y: CGRectGetMidY(self.frame) + pipeOffSet)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(0.1, gapHeight / 2))
            gap.runAction(moveAndRemovePipes)
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = gapGroup
            gap.physicsBody?.categoryBitMask = gapGroup
            gap.physicsBody?.contactTestBitMask = birdGroup
            movingObjects.addChild(gap)
            
    
        }
    }
        // TODO: Move to utilities somewhere. There's no reason this should be a member function
        func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
            if( value > max ) {
                return max
            } else if( value < min ) {
                return min
            } else {
                return value
            }
        }
        
    
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            
            score++
            
            scoreLabel.text = "\(score)"
        
            
        } else {
            
            if gameOver == 0 {

       
                //var highScore = defaults.integerForKey("highScore")
                
            var scoreboard = SKSpriteNode(imageNamed: "scoreboard.png")
            
                var highscore = NSUserDefaults().integerForKey("highscore")
                
                


                
                if (score > highscore) {
                    
                    NSUserDefaults().setInteger(score, forKey: "highscore")
                     newHighScore.text = "New High Score!"
                    newHighScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50)
                    
                    
                    GameViewController().saveHighscore(score)
                    let alert = UIAlertView(title: "Congrats",
                        message: "Your new highscore has been posted to the leaderboard",
                        delegate: self,
                        cancelButtonTitle: "Ok")
                    alert.show()

                    
                   /* let leaderboardName = "Swimmyleader21"
                    let scoreObj = GKScore(leaderboardIdentifier: leaderboardName)
                    scoreObj.context = 0
                    scoreObj.value = Int64(highscore)
                    GKScore.reportScores([scoreObj], withCompletionHandler: {(error) -> Void in
                        let alert = UIAlertView(title: "Congrats",
                            message: "Your new highscore has been posted to the leaderboard",
                            delegate: self, 
                            cancelButtonTitle: "Ok")
                        alert.show()
                    }) */
                    
                    
                    
                }
                
                
              
                
                var highScoreShow = NSUserDefaults().integerForKey("highscore")
                
                highScoreLabel.text = "Highscore: \(highScoreShow)"
                 highScoreLabel.zPosition = 10
               
                highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50)

            labelHolder.addChild(highScoreLabel)

                


                gameOver = 1
                
                movingObjects.speed = 0
            

                
                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame) - 10)
                
                scoreboard.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(scoreboard)
                
                gameOverLabel.fontName = "Wawati"
                gameOverLabel.fontSize = 20
                gameOverLabel.text = "Restart"
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame))

                labelHolder.addChild(gameOverLabel)
                
               leaderButton.fontName = "Wawati"
                leaderButton.fontSize = 20
              leaderButton.text = "Leaderboard"
             leaderButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 75)
                
                labelHolder.addChild(leaderButton)
            }
        }
        
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        
        
        
        
        if (gameOver == 0) {
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 40))
            
        } else {
            
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                let node = self.nodeAtPoint(location)
                if node == leaderButton {
                    showLeader()
                    
                }
            }

            
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                let node = self.nodeAtPoint(location)
                if node == gameOverLabel {
                    println("Hello!!!!")

            score = 0
            scoreLabel.text = "0"
            
            movingObjects.removeAllChildren()
            
            makeBackground()
            
            bird.position = CGPoint(x: CGRectGetMidX(self.frame) - 100, y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
            
            labelHolder.removeAllChildren()
            
            gameOver = 0
            
            movingObjects.speed = 1
        
        }
            }
        
        
        
        
        
    }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
}

