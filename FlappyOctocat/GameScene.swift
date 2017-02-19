//
//  GameScene.swift
//  FlappyOctocat
//
//  Created by Frank Hu on 2017/2/18.
//  Copyright © 2017年 WeichuHu. All rights reserved.
//

import SpriteKit
import GameplayKit

struct GameObjects {
    static let Octocat : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var entities = [GKEntity]()
    //var graphs = [String : GKGraph]()
    
    var Ground = SKSpriteNode()
    var Octocat = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveRemove = SKAction()
    var gameStart = Bool()
    
    var score = Int()
    let scoreLb = SKLabelNode()
    
    var died = Bool()
    var restart = SKSpriteNode()
    
    //private var lastUpdateTime : TimeInterval = 0
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStart = false
        score = 0
        createScene()
        
    }
    
    
    func createScene() {
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
        
        
        scoreLb.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLb.text = "\(score)"
        //scoreLb.fontName = "04b_19"
        scoreLb.zPosition = 5
        scoreLb.fontSize = 60
        self.addChild(scoreLb)
        
        //set up ground image
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = GameObjects.Ground
        Ground.physicsBody?.collisionBitMask = GameObjects.Octocat
        Ground.physicsBody?.contactTestBitMask = GameObjects.Octocat
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        self.addChild(Ground)
        
        //set up octocat image
        Octocat = SKSpriteNode(imageNamed: "Octocat")
        Octocat.size = CGSize(width: 60, height: 50)
        Octocat.position = CGPoint(x: self.frame.width / 2 - Octocat.frame.width, y: self.frame.height / 2)
        
        Octocat.physicsBody = SKPhysicsBody(circleOfRadius: Octocat.frame.height / 2)
        Octocat.physicsBody?.categoryBitMask = GameObjects.Octocat
        Octocat.physicsBody?.collisionBitMask = GameObjects.Ground | GameObjects.Wall
        Octocat.physicsBody?.contactTestBitMask = GameObjects.Ground | GameObjects.Wall | GameObjects.Score
        Octocat.physicsBody?.affectedByGravity = true
        Octocat.physicsBody?.isDynamic = true
        
        Octocat.zPosition = 2
        self.addChild(Octocat)
        
        //createWalls()
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createBTN(){
        
        restart = SKSpriteNode(imageNamed: "RestartBtn")
        restart.size = CGSize(width: 200, height: 100)
        restart.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restart.zPosition = 6
        restart.setScale(0)
        self.addChild(restart)
        restart.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == GameObjects.Score && secondBody.categoryBitMask == GameObjects.Octocat{
            
            score += 1
            scoreLb.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        }
        else if firstBody.categoryBitMask == GameObjects.Octocat && secondBody.categoryBitMask == GameObjects.Score {
            
            score += 1
            scoreLb.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        }
            
        else if firstBody.categoryBitMask == GameObjects.Octocat && secondBody.categoryBitMask == GameObjects.Wall || firstBody.categoryBitMask == GameObjects.Wall && secondBody.categoryBitMask == GameObjects.Octocat{
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                createBTN()
            }
        }
        else if firstBody.categoryBitMask == GameObjects.Octocat && secondBody.categoryBitMask == GameObjects.Ground || firstBody.categoryBitMask == GameObjects.Ground && secondBody.categoryBitMask == GameObjects.Octocat{
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                createBTN()
            }
        }
    }

    
    func createWalls(){
        let wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width / 2 + 25, y: self.frame.height / 2 + 300)
        btmWall.position = CGPoint(x: self.frame.width / 2 + 25, y: self.frame.height / 2 - 300)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = GameObjects.Wall
        topWall.physicsBody?.collisionBitMask = GameObjects.Octocat
        topWall.physicsBody?.contactTestBitMask = GameObjects.Octocat
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = GameObjects.Wall
        btmWall.physicsBody?.collisionBitMask = GameObjects.Octocat
        btmWall.physicsBody?.contactTestBitMask = GameObjects.Octocat
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        
        
        self.addChild(wallPair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStart == false{
            
            gameStart =  true
            
            self.Octocat.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveRemove = SKAction.sequence([movePipes, removePipes])
            
            Octocat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Octocat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
        else{
            Octocat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Octocat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
            
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStart == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
            }
        }
    }
}

