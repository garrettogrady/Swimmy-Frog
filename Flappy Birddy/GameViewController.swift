//
//  GameViewController.swift
//  Flappy Birddy
//
//  Created by Garrett O'Grady on 1/16/15.
//  Copyright (c) 2015 Garrett O'Grady. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GameKit

let adBannerView = ADBannerView(frame: CGRect.zeroRect)

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        authenticateLocalPlayer()
        super.viewDidLoad()
    
        


        
        
        
    
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //kView.showsNodeCount = true
            loadAds()
      

            


            
            
           
            
            
            
            
            
            
            
            
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    func authenticateLocalPlayer(){
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                //These 2 lines are the only parts that have been changed
                let vc: UIViewController = self.view.window!.rootViewController!
                vc.presentViewController(viewController, animated: true, completion: nil)
            }
            else {
                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func loadAds() {
        
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)

        adBannerView.delegate = self
        adBannerView.hidden = true
        view.addSubview(adBannerView)
        
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adBannerView.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adBannerView.hidden = true
    }
    
       
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
 
    
  
    
        func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "Swimmyleader21") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            println("sucess")
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
        }
        
    }
    
  


    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    }
