//
//  GameScene.swift
//  SpaceCannonGame
//
//  Created by Josh Ransom on 10/4/14.
//  Copyright (c) 2014 RansomNode. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var SHOOT_SPEED = CGFloat(1000.0) // Speed of cannon projectiles
    var cannon = SKSpriteNode(imageNamed: "Cannon") // Cannon Sprite
    var main = SKNode()     // Main game layer
    var shotFired = Bool()    //Turn off gravity.
    
    
    // Conversion for cannon radians to vector.
    func radiansToVector(tempRadians:CGFloat) -> CGVector {
        let radians = Float(tempRadians)
        let xVal = CGFloat(cosf(radians))
        let yVal = CGFloat(sinf(radians))
        let vector = CGVectorMake(xVal, yVal)
        return vector
    }
    
    override func didMoveToView(view: SKView)
    {
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)

        // Add the background Image.
        var background = SKSpriteNode(imageNamed: "Starfield")
        background.size = CGSizeMake(self.size.width, self.size.height)
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(background)
        
        // Add the main SpriteKit layer.
        self.addChild(main)
        
        // Add the canon to the main layer.
        cannon.position = CGPointMake(self.size.width * 0.5, 0.0)
        main.addChild(cannon)
        
        // Add the action sequence for the cannon.
        var positive = CGFloat(M_PI)
        var negative = -1 * positive
        var rotateCannon = SKAction.sequence([SKAction.rotateByAngle(positive, duration: 2.0), SKAction.rotateByAngle(negative, duration: 2.0)])
        cannon.runAction(SKAction.repeatActionForever(rotateCannon))
        
    }
    
    // Add function to fire cannon when screen is tapped.
    func fireCannon() {

        var ball = SKSpriteNode(imageNamed: "Ball")
        ball.name = "ball"
        
        var rotationVector = radiansToVector(cannon.zRotation)
        ball.position = CGPointMake(cannon.position.x + (cannon.size.width * 0.5 * rotationVector.dx), cannon.position.y + (cannon.size.width * 0.5 * rotationVector.dy))
        main.addChild(ball)
        
        // Adding physics for the ball shooting.
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 6.0)
        ball.physicsBody?.velocity = CGVectorMake(rotationVector.dx * SHOOT_SPEED, rotationVector.dy * SHOOT_SPEED)
        
    }
    
    // Delete nodes outside of the main view.
    override func didSimulatePhysics() {
        
        if(shotFired) {
            self.fireCannon()
            shotFired = false
        }
        main.enumerateChildNodesWithName("ball", usingBlock: { (node, stop) -> Void in
            if(!CGRectContainsPoint(self.frame, node.position)){
                node.removeFromParent()
            }
        })
    }
      
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            shotFired = true
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
