//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: BattlecruiserObject.swift
// File Desc: Battlecruiser Object in Game of memeber Enemy object class.
//
// Version: 0.1
// Commit: Enemy Battlecruiser object created
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

class BAttlecruiserObject: EnemyObject {
    init() {
        super.init(objectTextureFileName: "Battlecruiser", objectScale: 1.0)
        self.objectMoveSpeed = 5.5
        self.hp = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
