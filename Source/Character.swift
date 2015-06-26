//
//  Character.swift
//  SushiNeko
//
//  Created by James Sobieski on 6/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Character: CCSprite {
    weak var mainScene: MainScene!
    
    var dead:Bool = false
    
    var side: Side = .Left {
        didSet {
            mainScene.isGameOver()
        }
    }
    
    func tap() {
        self.animationManager.runAnimationsForSequenceNamed("Tap")
    }
    
    
    func left() {
        scaleX = 1
        side = .Left
        tap()
    }
    func right() {
        scaleX = -1
        side = .Right
        tap()
    }
    
    
}
