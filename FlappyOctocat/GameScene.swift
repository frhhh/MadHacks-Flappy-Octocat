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
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var Ground = SKSpriteNode()
    var Octocat = SKSpriteNode()
    
//    override func didMove(to view: SKView) {
//        
//        //set up ground image
//        Ground = SKSpriteNode(imageNamed: "Ground")
//        Ground.setScale(1)
//        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
//        self.addChild(Ground)
//        
//        //set up octocat image
//        Octocat = SKSpriteNode(imageNamed: "Octocat")
//        Octocat.size = CGSize(width: 200, height: 200)
//        Octocat.position = CGPoint(x: self.frame.width / 2 - Octocat.frame.width, y: self.frame.height / 2)
//        self.addChild(Octocat)
//        
//    }
    
    
    override func sceneDidLoad() {
        
        //set up ground image
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(1)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = GameObjects.Ground
        Ground.physicsBody?.collisionBitMask = GameObjects.Octocat
        Ground.physicsBody?.contactTestBitMask = GameObjects.Octocat
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        self.addChild(Ground)
        
        //set up octocat image
        Octocat = SKSpriteNode(imageNamed: "Octocat")
        Octocat.size = CGSize(width: 200, height: 200)
        Octocat.position = CGPoint(x: self.frame.width / 2 - Octocat.frame.width, y: self.frame.height / 2)
        
        Octocat.physicsBody = SKPhysicsBody(circleOfRadius: Octocat.frame.height / 2)
        Octocat.physicsBody?.categoryBitMask = GameObjects.Octocat
        Octocat.physicsBody?.collisionBitMask = GameObjects.Ground | GameObjects.Wall
        Octocat.physicsBody?.contactTestBitMask = GameObjects.Ground | GameObjects.Wall
        Octocat.physicsBody?.affectedByGravity = true
        Octocat.physicsBody?.isDynamic = true
        self.addChild(Octocat)
        
        createWalls()
    }
    
    func createWalls(){
        let wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 200)
        btmWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 1000)
        
        topWall.setScale(1)
        btmWall.setScale(1)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        self.addChild(wallPair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
