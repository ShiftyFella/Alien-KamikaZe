//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: MenuScene.swift
// File Desc: Main Screen
//
// Version: 0.1
// Commit: Created Start\Quit buttons with respective actions, added background
// Date: 22.02.2018
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

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        
        //Set scene background
        let backgroundNode = SKSpriteNode(imageNamed: "Splash screen")
        backgroundNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundNode.size = self.frame.size
        backgroundNode.zPosition = 0
        
        //creates start game button
        let startGameLabel = SKLabelNode()
        startGameLabel.name = "start"
        startGameLabel.text = "New Game"
        startGameLabel.fontSize = 42 * UIScreen.main.scale
        startGameLabel.fontColor = SKColor.yellow
        startGameLabel.fontName = "Neuropolitical"
        startGameLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4)
        startGameLabel.zPosition = 1
        
        //creates quit game button
        let quitGameLabel = SKLabelNode()
        quitGameLabel.name = "quit"
        quitGameLabel.text = "Quit Game"
        quitGameLabel.fontSize = 38 * UIScreen.main.scale
        quitGameLabel.fontColor = SKColor.yellow
        quitGameLabel.fontName = "Neuropolitical"
        quitGameLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/8)
        quitGameLabel.zPosition = 1
        
        //add nodes to game scene
        self.addChild(backgroundNode)
        self.addChild(startGameLabel)
        self.addChild(quitGameLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            //get touch location
            let location = t.location(in: self)
            
            //returns node entity that intersects touch location
            let node: SKNode = self.atPoint(location)
            
            //check if start or quit nodes were tapped
            if node.name == "start" {
                //starts new game, transition to game level scene with animations
                
                //creates fade in transition
                let transition = SKTransition.fade(withDuration: 1.0)
                
                //creates instance of game level scene to transition to
                let scene = Level1Scene(size: self.size)
                
                //present new scene using transition
                self.view?.presentScene(scene, transition: transition)
                
                
            } else if node.name == "quit" {
                //suspending application to background when quit button pressed
                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                       to: UIApplication.shared, for: nil)
            }
        }
    }
}
