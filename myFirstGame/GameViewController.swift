//
//  GameViewController.swift
//  myFirstGame
//
//  Created by lorch on 2017/10/5.
//  Copyright © 2017年 lorch. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Detect the screen size
        var sizeRect = UIScreen.main.bounds
        // var sizeRect = UIScreen.mainScreen.applicationFrame
        var width = sizeRect.size.width * UIScreen.main.scale
        var height = sizeRect.size.height * UIScreen.main.scale
        
        // Screen should be shown in fullscreen mode
        
        let scene = GameScene(size: CGSize(width: width, height: height))
        //let scene = GameScene(size: CGSizeMake(width, height))
        // Configure the view
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // SpriteKit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        // Set the scale mode to fit the window
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
