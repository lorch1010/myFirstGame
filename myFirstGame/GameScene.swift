//
//  GameScene.swift
//  myFirstGame
//
//  Created by lorch on 2017/10/5.
//  Copyright © 2017年 lorch. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // Add two global Sprite properties
    var heroSprite = SKSpriteNode(imageNamed: "Spaceship")
    var invisibleControllerSprite = SKSpriteNode()
    var enemySprites = EnemySpriteController()
    // HUD global properties
    var lifeNodes: [SKSpriteNode] = []
    var remainingLives = 3
    var scoreNode = SKLabelNode()
    var score = 0
    
    func createHUD(){
        // Create a root node with black background to position and group the HUD elements
        // HUD size is relative to the screen resolution of a specific device
        var hud = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.size.width, height: self.size.height * 0.05))
        hud.anchorPoint = CGPoint(x: 0, y: 0)
        hud.position = CGPoint(x: 0, y: self.size.height - hud.size.height)
        self.addChild(hud)
        
        // Display the remaining lives
        // Add icons for displaying the remaining lives with the spaceship image again
        // Scale and position the image relative to the HUD size
        let lifeSize = CGSize(width: hud.size.height - 10, height: hud.size.height - 10)
        for var i in 0 ... self.remainingLives-1{
            var tmpNode = SKSpriteNode(imageNamed: "Spaceship")
            lifeNodes.append(tmpNode)
            tmpNode.size = lifeSize
            tmpNode.position = CGPoint(x: tmpNode.size.width * 1.3 * (1.0 + CGFloat(i)), y: (hud.size.height - 5)/2)
            hud.addChild(tmpNode)
        }
        
        // Pause button container and label
        var pauseContainer = SKSpriteNode()
        pauseContainer.position = CGPoint(x: hud.size.width/1.5, y: 1)
        pauseContainer.size = CGSize(width: hud.size.height * 3, height: hud.size.height * 2)
        pauseContainer.name = "PauseButtonContainer"
        hud.addChild(pauseContainer)
        
        var pauseButton = SKLabelNode()
        pauseButton.position = CGPoint(x: hud.size.width/1.5, y: 1)
        pauseButton.text = "||"
        pauseButton.fontSize = hud.size.height
        pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        pauseButton.name = "PauseButton"
        
        // Display the current score
        self.score = 0
        self.scoreNode.position = CGPoint(x: hud.size.width * 0.9, y: 1)
        self.scoreNode.text = "0"
        self.scoreNode.fontSize = hud.size.height
        hud.addChild(self.scoreNode)
        
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        // Place the created hero sprite in the middle of the screen
        heroSprite.xScale = 0.15
        heroSprite.yScale = 0.15
        heroSprite.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(heroSprite)
        
        invisibleControllerSprite.size = CGSize(width: 0, height: 0)
        self.addChild(invisibleControllerSprite)
        
        // Define a constraint for the orientation behavior
        let rangeForOrientation = SKRange(constantValue: CGFloat(M_2_PI * 7))
        heroSprite.constraints = [SKConstraint.orient(to: invisibleControllerSprite, offset: rangeForOrientation)]
        
        for _ in 0...2{
            self.addChild(enemySprites.spawnEnemy(targetSprite: heroSprite))
        }
        
        // Add HUD to the screen
        createHUD()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    // Function that's been modified
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a touch begins
        for touch in (touches as! Set<UITouch>){
            // Determine the new position for the invisible sprite
            // Calculations are needed to ensure that the positions of both sprites are the same, but somehow different
            // Otherwise, the hero sprite rotates back to its original orientation after reaching the location of the invisible sprite
            
            var xOffset: CGFloat = 1.0
            var yOffset: CGFloat = 1.0
            var location = touch.location(in: self)
            if location.x > heroSprite.position.x{
                xOffset = -1.0
            }
            if location.y > heroSprite.position.y{
                yOffset = -1.0
            }
            // Create an action to move the invisibleControllerSprite
            // This will cause automatic orientation changes for the hero sprite
            let actionMoveInvisibleNode = SKAction.move(to: CGPoint(x: location.x - xOffset, y: location.y - yOffset), duration: 0.2)
            invisibleControllerSprite.run(actionMoveInvisibleNode)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
