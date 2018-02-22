//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: GenericObject.swift
// File Desc: Generic game object class that extends SKSpiteNode functionality for the purprose of the game
//
// Version: 0.0
// Commit: Intial commit
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

class GenericObject: SKSpriteNode {
    
    init (objectTextureFileName: String, objectScale: CGFloat) {
        let objectTexture = SKTexture(imageNamed: objectTextureFileName)
        super.init(texture: objectTexture, color: UIColor.clear, size: objectTexture.size())
        self.setScale(objectScale)
        self.name = objectTextureFileName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
