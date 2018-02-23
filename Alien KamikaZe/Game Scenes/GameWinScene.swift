//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: GameWinScene.swift
// File Desc: Scene to display GameWin event
//
// Version: 0.1
// Commit: Added game sounds
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

class GameWinScene: SKScene {
    
    override func didMove(to view: SKView) {
        //play backgroundaudio
        audioInBackground()
    }
    
    //play background sound
    func audioInBackground() {
        //load background file into node
        let soundNode = SKAudioNode(fileNamed: "EndOfTheGame_soundtrack.mp3")
        soundNode.name = "background_music"
        //play audio on loop
        soundNode.autoplayLooped = true
        //add to the scene
        self.addChild(soundNode)
        //change volume of the file to appropriate level
        soundNode.run(SKAction.changeVolume(to: Float(0.2), duration: 0))
    }
    
}
