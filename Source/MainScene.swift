import Foundation

enum Side {
    case Left, Right, None
}

enum GameState {
    case Title, Ready, Playing, GameOver
}

class MainScene: CCNode {
    weak var piecesNode:CCNode!
    weak var firstPiece:Piece!
    weak var character:Character!
    
    //weak var restartButton:CCButton!
    weak var retryButton:CCButton!
    weak var mainMenuButton:CCButton!
    
    weak var lifeBar:CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var tapButtons:CCNode!
    
    
    var gameState: GameState = .Title
    
    
    var windowAlreadyMade:Bool = false
    var piecesArray:[Piece]! = []
    var someValue:CGFloat = CGFloat(60)
    var pieceLastSide:Side = .Left
    var counter:Int = 0
    var firstSushi:Bool = true
    var difficulty:Float = 1
    var addPiecePosition: CGPoint?
    var savedGameOverScreen:GameOver?
    
    var timeLeft:Float = 10 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = (timeLeft / Float(10))
        }
    }
    
    

    override func onEnter() {
        super.onEnter()
        addPiecePosition = CGPoint(x: piecesNode.positionInPoints.x, y: piecesNode.positionInPoints.y + 40)
    }
    
    func didLoadFromCCB() {
        //piecesArray.append(firstPiece)
        //previousPiece = firstPiece
        
        resetTower()
        
        
        
        character.mainScene = self
    }
    
    func spawnNewSushi(){
        var temporaryPiece = CCBReader.load("Piece") as! Piece
        if !firstSushi {
            pieceLastSide = temporaryPiece.setObstacle(pieceLastSide)
        } else {
            firstSushi = false
        }
        println("Sushi #\(counter)")
        counter += 1
        
        
        
        if piecesArray.count >= 1 {
            var newPiecesArray = piecesArray
            
            temporaryPiece.position = ccp(newPiecesArray[newPiecesArray.count - 1].position.x, newPiecesArray[newPiecesArray.count - 1].position.y + someValue)
            piecesNode.addChild(temporaryPiece)
            piecesArray.append(temporaryPiece)
            
        } else {
            temporaryPiece.position = CGPoint(x: 0, y: -30)
            piecesNode.addChild(temporaryPiece)
            piecesArray.append(temporaryPiece)
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
        
        if gameState == .Playing || gameState == .Ready {
            if gameState == .Ready {
                gameState = .Playing
                tapButtons.runAction(CCActionFadeOut(duration: 0.2))
            }
            
            difficulty += Float(0.01)
            if touch.locationInWorld().x > screenHalf {
                character.right()
            } else {
                character.left()
            }
            
            if(isGameOver()){
                return
            }
            stepTower()
            if(isGameOver()){
                return
            }
        }
    }

    func stepTower() {
        for sushiRoll:Piece in piecesArray {
            sushiRoll.position.y = sushiRoll.position.y - someValue
        }
        piecesArray.append(piecesArray.removeAtIndex(0))
        piecesArray[piecesArray.count - 1].position.y = piecesArray[piecesArray.count - 2].position.y + someValue
        piecesArray[piecesArray.count-1].setObstacle(piecesArray[piecesArray.count - 2].side)
        piecesArray[piecesArray.count-1].zOrder += 1
        timeLeft += Float(0.25)
        //println("\(scoreLabel.string)")
        var scoreLabelValue:Int = scoreLabel.string.toInt()!
        scoreLabel.string = String(scoreLabelValue + 1)
        
        
        addHitPiece(piecesArray[0].side)
        isGameOver()
        if(isGameOver()){
            return
        }
        piecesArray[0].side = .None

        
    }
    
    func isGameOver() -> Bool {
        
        if (piecesArray[0].side == character.side)  || (piecesArray[1].side == character.side) {
            triggerGameOver()
        }
        
        return gameState == .GameOver
    }
    
    func resetTower() {
        firstSushi = true
        pieceLastSide = character.side
        
        piecesArray.removeAll()
        piecesNode.removeAllChildren()
        
        for var i = 0; i < 10; i += 1 {
            spawnNewSushi()
        }
        userInteractionEnabled = true
    }
    
    override func update(delta: CCTime) {
        if gameState == .Playing {
            timeLeft -= (Float(delta) * difficulty)
            if timeLeft == 0 {
                triggerGameOver()
            }
        }
    }
    
    func retry() {
        println("retry function hit")
        //savedGameOverScreen!.runAction(CCActionFadeOut(duration: 0.2))
        
        //savedGameOverScreen!.getMainNode().visible = false
        
        //savedGameOverScreen!.removeAllChildren()
        
        self.removeChildByName("GameOverNode")
        println("node removed")
        println("prepare for error")
        
        scoreLabel.string = "0"
        resetTower()
        gameState = .Playing
        mainMenuButton.visible = false
        retryButton.visible = false
        timeLeft = 10
        difficulty = 1
        
        gameState = .Ready
        
        self.animationManager.runAnimationsForSequenceNamed("Ready")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
        
        
        character.left()
        windowAlreadyMade = false
        
    }
    
    func addHitPiece(obstacleSide: Side) {
        var flyingPiece = CCBReader.load("Piece") as! Piece
        flyingPiece.position = addPiecePosition!
        
        var animationName = character.side == .Left ? "FromLeft": "FromRight"
        flyingPiece.animationManager.runAnimationsForSequenceNamed(animationName)
        flyingPiece.side = obstacleSide
        
        self.addChild(flyingPiece)
    }
    
    func mainMenu() {
        scoreLabel.string = "0"
        resetTower()
        gameState = .Playing
        mainMenuButton.visible = false
        retryButton.visible = false
        timeLeft = 10
        difficulty = 1
        
        
        self.animationManager.runAnimationsForSequenceNamed("InitialLaunch")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
        
        gameState = .Title
        
        character.left()
        
        userInteractionEnabled = true
    }
    
    
    
    func triggerGameOver() {
        gameState = .GameOver
        
        //userInteractionEnabled = false
        if !windowAlreadyMade {
            var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
            gameOverScreen.score = scoreLabel.string.toInt()!
            self.addChild(gameOverScreen, z: 10, name: "GameOverNode")
            windowAlreadyMade = true
            println("Game Over")
        }
        
        //self.addChild(gameOverScreen)
        
        println("Game Over again...")
    }
    
    
    
    
    func ready() {
        gameState = .Ready
        
        self.animationManager.runAnimationsForSequenceNamed("Ready")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
        
        gameState = .Ready
        userInteractionEnabled = true
    }
}
