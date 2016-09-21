//
//  GameScene.swift
//  Flappy Birddy
//
//  Created by Garrett O'Grady on 1/16/15.
//  Copyright (c) 2015 Garrett O'Grady. All rights reserved.
//
import SpriteKit
import GameKit

class GameScene: SKScene {
    let playButton = SKSpriteNode(imageNamed: "play")
    var bg = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        
    
        
        func makeBackground() {
            let bgTexture = SKTexture(imageNamed: "bg.png")
            bg.zPosition = -10
            let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
            let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
            let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
            
            
            for var i:CGFloat=0; i<3; i++ {
                
                bg = SKSpriteNode(texture: bgTexture)
                bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
                bg.size.height = self.frame.height
                
                bg.runAction(movebgForever)
                

                self.addChild(bg)
                
                
            }
        }

               makeBackground()
                playButton.zPosition = 10
        
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
    
           
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
        
        
       
    }
    

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}