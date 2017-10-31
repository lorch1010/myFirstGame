//
//  EnemySpriteController.swift
//  myFirstGame
//
//  Created by lorch on 2017/10/5.
//  Copyright © 2017年 lorch. All rights reserved.
//

// - Creating/Destroying Enemies
// - Shooting
// - Animations

import SpriteKit

class EnemySpriteController{
    var enemySprites: [SKSpriteNode] = []
    
    // Return a new enemy sprite which follows the targetSprite node
    func spawnEnemy(targetSprite: SKNode) -> SKSpriteNode{
        // Create a new enemy sprite
        let newEnemy = SKSpriteNode(imageNamed: "spaceship")
        enemySprites.append(newEnemy)
        newEnemy.xScale = 0.08
        newEnemy.yScale = 0.08
        newEnemy.color = UIColor.red
        newEnemy.colorBlendFactor = 0.4
        
        // Position a new sprite at a random position on the screen
        let sizeRect = UIScreen.main.bounds
        let xPos = arc4random_uniform(UInt32(sizeRect.size.width))
        let yPos = arc4random_uniform(UInt32(sizeRect.size.height))
        newEnemy.position = CGPoint(x: CGFloat(xPos), y: CGFloat(yPos))
        
        // Define constraints for orientation/targeting behavior
        let num = enemySprites.count - 1
        let rangeForOrientation = SKRange(constantValue: CGFloat(M_2_PI*7))
        let orientConstraint = SKConstraint.orient(to: targetSprite, offset: rangeForOrientation)
        
        let rangeToSprite = SKRange(lowerLimit: 80, upperLimit: 90)
        var distanceConstraint: SKConstraint
        
        // First enemy has to follow spriteToFollow, whereas the second enemy follows the first one
        if num == 0{
            distanceConstraint = SKConstraint.distance(rangeToSprite, to: targetSprite)
        }else{
            distanceConstraint = SKConstraint.distance(rangeToSprite, to: enemySprites[num-1])
        }
        
        newEnemy.constraints = [orientConstraint, distanceConstraint]
        
        return newEnemy
    }
    
    // Shoot in direction of spriteToShoot
    func shoot(targetSprite: SKNode){
        for enemy in enemySprites{
            // Create the bullet sprite
            let bullet = SKSpriteNode()
            bullet.color = UIColor.green
            bullet.size = CGSize(width: 5, height: 5)
            bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
            targetSprite.parent?.addChild(bullet)
            
            // Add physics body for collision detection
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = collisionBulletCategory
            bullet.physicsBody?.contactTestBitMask = collisionHeroCategory
            bullet.physicsBody?.collisionBitMask = 0x0
            
            // Determine vector to targetSprite
            let vector = CGVector(dx: targetSprite.position.x-enemy.position.x, dy: targetSprite.position.y-enemy.position.y)
            
            // Create the action to move the bullet and DON'T forget to remove it afterwards
            let bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10), SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
            bullet.run(bulletAction)
        }
    }
}
