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
// Version: 0.11
// Commit: Spelling errors fixes
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

class BattlecruiserObject: EnemyObject {
    init() {
        super.init(objectTextureFileName: "battlecruiser", objectScale: 1.0)
        self.objectMoveSpeed = 5.5
        self.hp = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
