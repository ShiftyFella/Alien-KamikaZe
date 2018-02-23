//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: Level1Scene.swift
// File Desc: Scene for Level 1 of the game
//
// Version: 0.7
// Commit: Special and Audio effects
// Date: 23.02.2018
//
// Contributors:
//          Name         StudenID
//      Viktor Bilyk  - #300964200
//      Andrii Damm   - #300966307
//      Timofei Sopin - #300965775
//      Tarun Singh   - #300967393
//
//---------------------------------------------------------------------------

import SpriteKit
import GameplayKit

//store middle of the screen as global variable
var sceneMiddlePointForX : CGFloat?
var sceneMiddlePointForY : CGFloat?

//collision mask for physics
let collisionBulletCategory:UInt32 = 0x1 << 0
let collisionEnemyCategory:UInt32 = 0x1 << 1
let collisionTowerCategory:UInt32 = 0x1 << 2

class Level1Scene: SKScene, SKPhysicsContactDelegate {
    
    //label nodes to display alien and missiles count
    let aliensCountLabel = SKLabelNode()
    let missilesCountLabel = SKLabelNode()
    
    //tower object
    let tower = TowerObject()
    
    //alien and missiles count
    var aliensCount = 25
    var aliensCountToGenerate = 25 //amount of enemis left to generate, initial value should be equal to aliensCount
    var missilesCount: Int?
    
    //number of enemy ships
    var frigatesCount: Int?
    var cruisersCount: Int?
    var battlecruisersCount: Int?
    
    //random distribution for X and Y axis
    var randomSourceForY = GKShuffledDistribution()
    var randomSourceForX = GKShuffledDistribution()
    
    //timer to repeat action at intervals
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        //play backgroundaudio
        audioInBackground()
        
        //set middle point of the screen
        sceneMiddlePointForX = self.frame.width/2
        sceneMiddlePointForY = self.frame.height/2
        
        //get random distribution for enemy position generation
        randomSourceForY = GKShuffledDistribution.init(lowestValue: 0, highestValue: Int(sceneMiddlePointForX!))
        randomSourceForX = GKShuffledDistribution.init(lowestValue: 0, highestValue: Int(sceneMiddlePointForY!))
        
        //display level background
        let backgroundNode = SKSpriteNode(imageNamed: "Level1_background")
        backgroundNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundNode.size = self.frame.size
        backgroundNode.zPosition = 0
        
        //add background node to the scene
        self.addChild(backgroundNode)
    
        //put tower in the middle of the scene
        tower.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        //add tower object to the scene
        self.addChild(tower)
        
        //create syncronized que of worker ques to make sure they're not added to the que out of order
        DispatchQueue.global(qos: .background).sync {
            
            //generate enemy count worker que
            DispatchQueue.global(qos: .background).sync {
                generateEnemyCount()
            }
            
            //generate missileCount after enemy counts been generated
            DispatchQueue.global(qos: .background).sync {
                missilesCount = frigatesCount!+2*cruisersCount!+3*battlecruisersCount!+50
                //start timed enemy spawn
                timedEnemySpawn()
            }
        }
        
        //draw hud when scene loads
        createHUD()
        
        //assign Physics World delegate to the scene
        self.physicsWorld.contactDelegate = self
    }
    
    //draw HUD elements
    func createHUD() {
        
        //get hud element size proportionate to screen size
        let nodeWidth = self.frame.width/3
        let nodeHeight = nodeWidth/3
        
        //create HUD shape for remaining aliens count
        let alienScoreController = SKShapeNode()
        alienScoreController.path = UIBezierPath(roundedRect: CGRect(x: -nodeWidth/2, y: -nodeHeight/2, width: nodeWidth, height: nodeHeight), cornerRadius: 20).cgPath
        alienScoreController.position = CGPoint(x: (alienScoreController.frame.width/2)+10, y: self.frame.height-(alienScoreController.frame.height/2)-10)
        alienScoreController.fillColor = SKColor.yellow
        alienScoreController.strokeColor = SKColor.red
        alienScoreController.lineWidth = 2
        alienScoreController.zPosition = 50
        
        //create node to display alien icon on the left side inside the hud shape
        let alientCountIcon = SKSpriteNode(imageNamed: "frigate")
        alientCountIcon.setScale(1.2)
        alientCountIcon.position = CGPoint(x: -(alienScoreController.frame.width/2-alientCountIcon.size.width/2-10), y: 0)
        
        //display number of remanining aliens next to alient icon's position
        aliensCountLabel.fontName = "Neuropolitical"
        aliensCountLabel.fontSize = 14 * UIScreen.main.scale
        aliensCountLabel.fontColor = SKColor.darkGray
        aliensCountLabel.text = "Aliens: \(aliensCount)"
        aliensCountLabel.position = CGPoint(x: alientCountIcon.size.width-25, y: -aliensCountLabel.frame.height/2)
        
        //add child nodes to alien count controller node
        alienScoreController.addChild(alientCountIcon)
        alienScoreController.addChild(aliensCountLabel)
        
        //create HUD shape for remaining missiles count
        let missilesScoreController = SKShapeNode()
        missilesScoreController.path = UIBezierPath(roundedRect: CGRect(x: -nodeWidth/2, y: -nodeHeight/2, width: nodeWidth, height: nodeHeight), cornerRadius: 20).cgPath
        missilesScoreController.position = CGPoint(x: (self.frame.width-missilesScoreController.frame.width/2)-10, y: self.frame.height-(missilesScoreController.frame.height/2)-10)
        missilesScoreController.fillColor = SKColor.yellow
        missilesScoreController.strokeColor = SKColor.red
        missilesScoreController.lineWidth = 2
        missilesScoreController.zPosition = 50
        
        //create node to display missile icon on the left side inside the hud shape
        let missilesCountIcon = SKSpriteNode(imageNamed: "rocket")
        missilesCountIcon.setScale(1.5)
        missilesCountIcon.position = CGPoint(x: -(missilesScoreController.frame.width/2-missilesCountIcon.size.width/2-10), y: 0)
        
        //display number of remaninging missiles on the hud
        missilesCountLabel.fontName = "Neuropolitical"
        missilesCountLabel.fontSize = 14 * UIScreen.main.scale
        missilesCountLabel.fontColor = SKColor.darkGray
        missilesCountLabel.text = "Rockets: \(missilesCount!)"
        missilesCountLabel.position = CGPoint(x: missilesCountIcon.size.width-5, y: -missilesCountLabel.frame.height/2)
        
        //add child nodes to missile count controller node
        missilesScoreController.addChild(missilesCountIcon)
        missilesScoreController.addChild(missilesCountLabel)
        
        //add controller nodes to main scene
        self.addChild(alienScoreController)
        self.addChild(missilesScoreController)
        
    }
    
    //play background sound
    func audioInBackground() {
        //load background file into node
        let soundNode = SKAudioNode(fileNamed: "Lvl_1_soundrack.mp3")
        soundNode.name = "background_music"
        //play audio on loop
        soundNode.autoplayLooped = true
        //add to the scene
        self.addChild(soundNode)
        //change volume of the file to appropriate level
        soundNode.run(SKAction.changeVolume(to: Float(0.2), duration: 0))
    }
    
    //generate random position on the endges of the screen
    func generateEnemyPosition() -> CGPoint {
        var position = CGPoint.zero
                
        //generate from what side object appears
        let randomSide = GKShuffledDistribution.init(lowestValue: 0, highestValue: 3)
        
        switch randomSide.nextInt() {
            //position along the bottom edge
        case 0: position = CGPoint(x: randomSourceForX.nextInt(), y: 0)
            //position along the left edge
        case 1: position = CGPoint(x: 0, y: randomSourceForY.nextInt())
            //position along the top edge
        case 2: position = CGPoint(x: randomSourceForX.nextInt(), y: Int(self.frame.height))
            //position along the right edge
        case 3: position = CGPoint(x: Int(self.frame.width), y: randomSourceForY.nextInt())
        default: return position
            
        }
        
        return position
    }
    
    //generate enemy counts
    func generateEnemyCount() {
        DispatchQueue.global(qos: .background).sync {
            
        //generate random number of frigates up to the max
        DispatchQueue.global(qos: .background).sync {
            frigatesCount = GKShuffledDistribution.init(lowestValue: 5, highestValue: 15).nextInt()
        }
        //generate random number of cruisers from remaining slots
        DispatchQueue.global(qos: .background).sync {
            cruisersCount = GKShuffledDistribution.init(lowestValue: 0, highestValue: aliensCount-frigatesCount!).nextInt()
        }
            
        //generate random number of cruisers from remaining slots
        DispatchQueue.global(qos: .background).sync {
            if cruisersCount! + frigatesCount! < aliensCount {
                battlecruisersCount = GKShuffledDistribution.init(lowestValue: 0, highestValue: aliensCount-frigatesCount!-cruisersCount!).nextInt()
            }
        }
        
        //check if not enought enemies been generated add more frigates
        DispatchQueue.global(qos: .background).sync {
            let count = frigatesCount!+cruisersCount!+battlecruisersCount!
            if count < aliensCount {
                frigatesCount! += aliensCount-count
            }
        }
        }
    }
    
    //display generated enemy on screen
    func generateEnemyOnScreen(enemyType: String) {
        var enemy: EnemyObject?
        
        //select which type to choose
        switch enemyType {
        case "frigate": enemy=FrigateObject()
        case "cruiser": enemy=CruiserObject()
        case "battlecruiser": enemy=BattlecruiserObject()
        default: enemy=FrigateObject()
        }
        
        //generate random position on screen
        enemy!.position = self.generateEnemyPosition()
        
        //add enemy node to the scene
        self.addChild(enemy!)
        
        //start enemy movement action to middle of the screen
        enemy!.doActions(location: CGPoint(x: sceneMiddlePointForX!, y: sceneMiddlePointForY!), speed: 0)
    }
    
    //spawn random of enemies of random type per spawn cycle
    @objc func generateEnemies() {
        if (aliensCountToGenerate>0) {
            var enemyRoll = 0
            //generate random number of enemies, re-roll if count is higher then avaliable amount
            repeat {
               enemyRoll = GKShuffledDistribution.init(lowestValue: 1, highestValue: 2).nextInt()
            } while (enemyRoll>aliensCountToGenerate)
            
            var toNext = false
            for _ in 1...enemyRoll {
                //generate random enemy type, re-roll if generated type has been exhausted
                repeat {
                    toNext = false
                    if (frigatesCount! > 0 || cruisersCount! > 0 || battlecruisersCount! > 0) {
                        let typeRoll = GKShuffledDistribution.init(lowestValue: 0, highestValue: 2).nextInt()
                        switch typeRoll {
                        case 0: if (frigatesCount! > 0 ) {
                            self.generateEnemyOnScreen(enemyType: "frigate")
                            frigatesCount! -= 1
                            toNext = true
                            }
                        case 1: if (cruisersCount! > 0) {
                            self.generateEnemyOnScreen(enemyType: "cruiser")
                            cruisersCount! -= 1
                            toNext = true
                            }
                        case 2: if (battlecruisersCount! > 0) {
                            self.generateEnemyOnScreen(enemyType: "battlecruiser")
                            battlecruisersCount! -= 1
                            toNext = true
                            }
                        default: break
                        }
                    } else {
                        toNext = true
                    }
                } while (!toNext)
            }
            aliensCountToGenerate -= enemyRoll
        } else {
            //no more enemies to generate cancel timer
            timer.invalidate()
        }
    }
    
    //timer to generate enemy swawn at specific interval
    func timedEnemySpawn() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.generateEnemies), userInfo: nil, repeats: true)
    }
    
    //handle collision actions
    func collissionAction(enemyNode: SKNode, bulletNode: SKNode) {
        let enemy = enemyNode as! EnemyObject
        let bullet = bulletNode as! BulletObject
        
        //if enemy still has HP reduce it
        if enemy.hp!>1 {
            enemy.hp! -= 1
            
            //bullet collided with enemy, play smoke effect, remove from scene
            smoke(position: bullet.position)
            bullet.removeAllActions()
            bullet.removeFromParent()
        } else {
            //enemy has no hp left, destroy it
            explosion(position: enemy.position)
            enemy.removeAllActions()
            enemy.removeFromParent()
            
            //bullet exploded, remove from scene
            bullet.removeAllActions()
            bullet.removeFromParent()
            
            //enemy destroyed update enemy count
            updateAliensCount()
        }
    }
    
    //verify which group collided between each other
    func checkCollision(nodeA: SKPhysicsBody, nodeB: SKPhysicsBody) {
        //DO IT
        
        // EnemyObject and Bullet collided pass node objects to collision handler
        if ( nodeA.categoryBitMask == collisionEnemyCategory && nodeB.categoryBitMask == collisionBulletCategory ) {
            collissionAction(enemyNode: nodeA.node!, bulletNode: nodeB.node!)
        } else if ( nodeB.categoryBitMask == collisionEnemyCategory && nodeA.categoryBitMask == collisionBulletCategory ) {
            collissionAction(enemyNode: nodeB.node!, bulletNode: nodeA.node!)
        }
        //Enemy reached tower, display Game Over scene
        else if (nodeA.categoryBitMask == collisionTowerCategory && nodeB.categoryBitMask == collisionEnemyCategory || nodeB.categoryBitMask == collisionTowerCategory && nodeA.categoryBitMask == collisionEnemyCategory) {
                    gameOver()
            }
    }
    
    //enemy explosion special effect
    func explosion(position: CGPoint) {
        //load special effect
        let emitterNode = SKEmitterNode(fileNamed: "sparks.sks")
        //assign node to position on the screen
        emitterNode?.particlePosition = position
        //add node to the scene
        self.addChild(emitterNode!)
        //execute action to play collision sound and remove node after
        self.run(SKAction.group([SKAction.playSoundFileNamed("Collision_With_rocket.mp3", waitForCompletion: true), SKAction.wait(forDuration: 1)]), completion: {emitterNode?.removeFromParent()})
    }
    
    //rocket collision smoke special effect
    func smoke(position: CGPoint) {
        //load special effect
        let emitterNode = SKEmitterNode(fileNamed: "smoke.sks")
        //assign node to position on the screen
        emitterNode?.particlePosition = position
        //add node to the scene
        self.addChild(emitterNode!)
        //execute action to play collision sound and remove node after
        self.run(SKAction.group([SKAction.playSoundFileNamed("Collision_With_rocket.mp3", waitForCompletion: true), SKAction.wait(forDuration: 1)]), completion: {emitterNode?.removeFromParent()})
    }
    
    //enemy destroyed update enemy count
    func updateAliensCount() {
        //check if there are any more enemies remaining
        if aliensCount-1 > 0 {
            aliensCount -= 1
        } else {//no more enemies, switch to Game Win scene
            gameWin()
        }
    }
    
    //Switch to game over scene
    func gameOver() {
        //creates fade in transition
        let transition = SKTransition.fade(withDuration: 1.0)
        
        //creates instance of game over scene to transition to
        let scene = GameOverScene(size: self.size)
        
        //present new scene using transition
        self.view?.presentScene(scene, transition: transition)
    }
    
    //Switch to Game Won scene
    func gameWin() {
        //creates fade in transition
        let transition = SKTransition.fade(withDuration: 1.0)
        
        //creates instance of game over scene to transition to
        let scene = GameWinScene(size: self.size)
        
        //present new scene using transition
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //get location of the tap
            let location = t.location(in: self)
            
            //if misslies are avaliable, fire
            if (missilesCount! > 0) {
                //create bullet object and move it through touch location
                let bullet = BulletObject()
                bullet.position = CGPoint(x: sceneMiddlePointForX!, y: sceneMiddlePointForY!)
                self.addChild(bullet)
                bullet.doActions(location: location, speed: 1.0)
                
                //misslie fired, reduce avaliable misslies
                missilesCount! -= 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //update HUD labels
        aliensCountLabel.text = "Aliens: \(aliensCount)"
        missilesCountLabel.text = "Rockets: \(missilesCount!)"
        
        //check if no more aliens go to game win scene
        if aliensCount == 0 {
            gameWin()
        }
    }
    
    //SKPhysicsContact Delegate method to handle reaction to collision events
    func didBegin(_ contact: SKPhysicsContact) {
        checkCollision(nodeA: contact.bodyA, nodeB: contact.bodyB)
    }
}
