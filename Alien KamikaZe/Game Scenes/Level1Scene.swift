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
// Version: 0.1
// Commit: Game Level Initial Design. Added level background and HUD
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
import GameplayKit

class Level1Scene: SKScene {
    
    let aliensCountLabel = SKLabelNode()
    let missilesCountLabel = SKLabelNode()
    
    var aliensCount = 25
    var missilesCount = 35
    
    override func didMove(to view: SKView) {
        
        //display level background
        let backgroundNode = SKSpriteNode(imageNamed: "Level1_background")
        backgroundNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundNode.size = self.frame.size
        backgroundNode.zPosition = 0
        
        self.addChild(backgroundNode)
    
        //draw hud when scene loads
        createHUD()
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
        alientCountIcon.setScale(1.5)
        alientCountIcon.position = CGPoint(x: -(alienScoreController.frame.width/2-alientCountIcon.size.width/2-10), y: 0)
        
        //display number of remanining aliens next to alient icon's position
        aliensCountLabel.fontName = "Neuropolitical"
        aliensCountLabel.fontSize = 48
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
        missilesCountIcon.setScale(2.0)
        missilesCountIcon.position = CGPoint(x: -(missilesScoreController.frame.width/2-missilesCountIcon.size.width/2-10), y: 0)
        
        //display number of remaninging missiles on the hud
        missilesCountLabel.fontName = "Neuropolitical"
        missilesCountLabel.fontSize = 48
        missilesCountLabel.fontColor = SKColor.darkGray
        missilesCountLabel.text = "Rockets: \(missilesCount)"
        missilesCountLabel.position = CGPoint(x: missilesCountIcon.size.width-5, y: -missilesCountLabel.frame.height/2)
        
        //add child nodes to missile count controller node
        missilesScoreController.addChild(missilesCountIcon)
        missilesScoreController.addChild(missilesCountLabel)
        
        //add controller nodes to main scene
        self.addChild(alienScoreController)
        self.addChild(missilesScoreController)
        
    }
    
}
