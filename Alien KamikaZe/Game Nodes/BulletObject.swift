//---------------------------------------------------------------------------
//
// Project name: Alien KamikaZe
//
// Project Desc: Arcade fixed shooter where you have to defend yourself from
//               alien fleet invasion
//
//
// File: BulletObject.swift
// File Desc: Bullet Object in Game of memeber Generic game object class.
//
// Version: 0.1
// Commit: Rocket bullet object created with custom move to target action
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

class BulletObject: GenericObject {
    init() {
        super.init(objectTextureFileName: "rocket", objectScale: 1.5)
        self.zPosition = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //create custom runAction
    override func doActions(location: CGPoint, speed: CGFloat) {
        
        //set constraints to orient node to face the location
        self.constraints = [SKConstraint.orient(to: location, offset: rangeforOrientation)]
        
        //create vector between location and origing(middle of the screen)
        let vector = CGVector(dx: location.x-sceneMiddlePointForX!, dy: location.y-sceneMiddlePointForY!)
        
        //calc ratio of movement speed along the vector axis
        let distanceForX = abs(vector.dx)/sceneMiddlePointForX!
        let distanceForY = abs(vector.dy)/sceneMiddlePointForY!
        
        var movementSpeed = CGFloat(1)
        
        //choose movement speed based on axis that takes longest to travel on
        if distanceForX > distanceForY {
            movementSpeed = distanceForX
        } else {
            movementSpeed = distanceForY
        }
        
        //create action of moving object along the vector till it escpaes the edges of the screen then delete it
        let action = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: TimeInterval(movementSpeed)), count: 10), SKAction.wait(forDuration: 3.0/60.0), SKAction.removeFromParent()])
        
        //run action
        self.run(action)
    }
}
