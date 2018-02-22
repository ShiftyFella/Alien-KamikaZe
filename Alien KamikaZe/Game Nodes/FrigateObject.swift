//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: FrigateObject.swift
// File Desc: Frigate Object in Game of memeber Enenmy object class.
//
// Version: 0.1
// Commit: Enenmy frigate created
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

class FrigateObject: EnemyObject {
    init() {
        super.init(objectTextureFileName: "frigate", objectScale: 1.5)
        self.hp = 1
        self.objectMoveSpeed = 3.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

