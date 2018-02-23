//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: TowerObject.swift
// File Desc: Tower Object in Game of memeber Generic game object class
//
// Version: 0.2
// Commit: Added physcis behaviour to the Tower object
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

class TowerObject: GenericObject {
    init() {
        super.init(objectTextureFileName: "turret", objectScale: 1.2)
        self.zPosition = 10
        
        //shape of the polygon for physics contact
        self.physicsBody = SKPhysicsBody(circleOfRadius: 50)//SKPhysicsBody(texture: self.texture!, size: (self.texture!.size()))
        
        //physics body dynamic
        self.physicsBody?.isDynamic = true
        
        //affected by gravity
        self.physicsBody?.affectedByGravity = false
        
        //collision category object belongs to
        self.physicsBody?.categoryBitMask = collisionTowerCategory
        
        //collision category object that trigers collision event with
        self.physicsBody?.contactTestBitMask = collisionEnemyCategory
        
        //collision mask
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
