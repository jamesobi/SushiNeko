//
//  GameOver.swift
//  SushiNeko
//
//  Created by James Sobieski on 6/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameOver: CCNode {
    weak var scoreLabel:CCLabelTTF!
    
    weak var matVariable:CCNode!
    weak var mainNode:CCNode!
    weak var restartButton:CCButton!
    
    
    var score:Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    
    func getMat() -> CCNode {
        return matVariable
    }
    
    func getMainNode() -> CCNode {
        return mainNode
    }

    
    func didLoadFromCCB(){
        restartButton.cascadeOpacityEnabled = true
        restartButton.runAction(CCActionFadeIn(duration: 0.3))
    }
}
