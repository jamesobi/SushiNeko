//
//  Piece.swift
//  SushiNeko
//
//  Created by James Sobieski on 6/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Piece: CCNode {
    weak var left:CCSprite!
    weak var right:CCSprite!
    
    var side: Side = .None {
        didSet {
            
            left.visible = false
            right.visible = false
            if side == .Right {
                right.visible = true
            }
            if side == .Left {
                left.visible = true
            }
        }
    }
    
    func setObstacle(lastSide: Side) -> Side{
        if lastSide == .None {
            var randomNumber = CCRANDOM_0_1() * 100.0
            
            if randomNumber < 45 {
                side = .Left
                
            } else if randomNumber < 90 {
                side = .Right
            } else {
                side = .None
            }
        } else {
            side = .None
        }
        return side
    }
    
    
   
}
