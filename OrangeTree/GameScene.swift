//
//  GameScene.swift
//  OrangeTree
//
//  Created by Jane Cui on 2023-04-27.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    
    override func didMove(to view: SKView) {
      orangeTree = childNode(withName: "tree") as? SKSpriteNode
        
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if atPoint(location).name == "tree" {
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            touchStart = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Update position of Orange to current location
        orange?.position = location
        
        let path = UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        shapeNode.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let dx = touchStart.x - location.x
        let dy = touchStart.y - location.y
        let vector = CGVector(dx: dx, dy: dy)
        
        // Apply vector as impulse
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        shapeNode.path = nil
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        print(nodeA?.name)
        print(nodeB?.name)
        if contact.collisionImpulse > 1 {
            if nodeA?.name == "skull" {
                print(contact.collisionImpulse)
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                print(contact.collisionImpulse)
                removeSkull(node: nodeB!)
            }
        }
    }
    
    func removeSkull(node: SKNode) {
        node.removeFromParent()
    }
}
