import SpriteKit
import AVFoundation

private var crocodile: SKSpriteNode!
private var prize: SKSpriteNode!
private var heart: SKSpriteNode!
private var sliceSoundAction: SKAction!
private var splashSoundAction: SKAction!
private var nomNomSoundAction: SKAction!
private var levelOver = false
private var caughtPineapple = false
private var vineCut = false
private var scoreLabel: SKLabelNode!
private var levelLabel: SKLabelNode!
private var gameOverLabel: SKLabelNode!
private var score = 0
private var lives = 3
private var lastVineX: CGFloat!
//private var level = 0
//private let maxLevel = GameConfiguration.VineDataFile.count - 1

class GameScene: SKScene, SKPhysicsContactDelegate
{

    override func didMove(to view: SKView)
    {
        print(GameConfiguration.CanCutMultipleVinesAtOnce)
        levelOver = false
        caughtPineapple = false
        setUpPhysics()
        setUpScenery()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        setUpAudio()
        setUpHearts()
        setUpLabels()
        
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics()
    {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
    }
    
    fileprivate func setUpScenery()
    {
        var background: SKSpriteNode!
        background = SKSpriteNode(imageNamed: ImageName.Background)
        background.anchorPoint = CGPoint(x: 0, y:0)
        background.position = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = Layer.Background
        addChild(background)
        
        var water: SKSpriteNode!
        water = SKSpriteNode(imageNamed: ImageName.Water)
        water.anchorPoint = CGPoint(x: 0, y:0)
        water.position = CGPoint(x: 0, y: 0)
        water.size = CGSize(width: self.size.width, height: self.size.height*0.2139)
        water.zPosition = Layer.Water
        addChild(water)
    }
    
    fileprivate func setUpHearts()
    {
        for i in 0..<lives
        {
            print("adding")
            heart = SKSpriteNode(imageNamed: ImageName.Heart)
            var xPos = self.size.width*0.1 //CGFloat
            let xPosInt = Int(xPos) * (i+1) // Int
            xPos = CGFloat(xPosInt) // Convert to CGFloat
            let yPos = self.size.height * 0.9
            heart.position = CGPoint(x: xPos, y: yPos)
            heart.zPosition = Layer.Hud
            addChild(heart)
        }
    }
    
    fileprivate func setUpPrize()
    {
        prize = SKSpriteNode(imageNamed: ImageName.Prize)
        let randomX = CGFloat.random(in: 0.2 ..< 0.8)
        prize.position = CGPoint(x: self.size.width*randomX, y: self.size.height*0.7)
        prize.zPosition = Layer.Prize
        prize.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.Prize), size: prize.size)
        prize.physicsBody?.categoryBitMask = PhysicsCategory.Prize
        prize.physicsBody?.collisionBitMask = 0
        prize.physicsBody?.density = 0.5
        prize.physicsBody?.isDynamic = true
        addChild(prize)
    }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines()
    {
        // 1 load vine data
        //let dataFile = Bundle.main.path(forResource: GameConfiguration.VineDataFile[level], ofType: nil)
        //let vines = NSArray(contentsOfFile: dataFile!) as! [NSDictionary]
        let vines = Int.random(in: 2 ... 5)
        
        // 2 add vines
        for i in 0..<vines
        {
            // Changed this to a pseudo random generation of vines
            // 3 create vine
            //let vineData = vines[i]
            let length = Int(CGFloat.random(in: 16 ..< 21))
            //let length = Int(vineData["length"] as! NSNumber)
            var anchorPoint: CGPoint!
            let relAnchorPoint = CGPoint(x: CGFloat.random(in: 0.15 ... 0.9), y: CGFloat.random(in: 0.8 ... 0.95))
            //let relAnchorPoint = NSCoder.cgPoint(for: vineData["relAnchorPoint"] as! String)
            anchorPoint = CGPoint(x: relAnchorPoint.x * size.width,
                                                  y: relAnchorPoint.y * size.height)
            lastVineX = anchorPoint.x
            
            // Just checking if 2 vines created after eachother are too close, reroll values. Doesn't guarantee they'll be further apart, just sometimes it will.
            if i > 1
            {
                if abs(lastVineX - anchorPoint.x) < 0.1
                {
                    let relAnchorPoint = CGPoint(x: CGFloat.random(in: 0.15 ... 0.9), y: CGFloat.random(in: 0.8 ... 0.95))
                    anchorPoint = CGPoint(x: relAnchorPoint.x * size.width,
                                          y: relAnchorPoint.y * size.height)
                    lastVineX = anchorPoint.x
                }
            }
            
            let vine = VineNode(length: length, anchorPoint: anchorPoint, name: "\(i)")
            
            // 4 add to scene
            vine.addToScene(self)
            
            // 5 connect the other end of the vine to the prize
            vine.attachToPrize(prize)
        }
    }
    // MARK: - Labels
    fileprivate func setUpLabels()
    {
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.9)
        scoreLabel.zPosition = Layer.Hud
        
        addChild(scoreLabel)
        /*
        let levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(level+1)"
        levelLabel.fontSize = 35
        levelLabel.fontColor = SKColor.white
        levelLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.9)
        levelLabel.zPosition = Layer.Hud
        
        addChild(levelLabel)
 */
        
    }
    
    fileprivate func displayGameOver()
    {
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER!"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        gameOverLabel.zPosition = Layer.Hud
        
        addChild(gameOverLabel)
        
    }
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile()
    {
        crocodile = SKSpriteNode(imageNamed: ImageName.CrocMouthClosed)
        crocodile.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.312)
        crocodile.zPosition = Layer.Crocodile
        crocodile.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.CrocMask), size: crocodile.size)
        crocodile.physicsBody?.categoryBitMask = PhysicsCategory.Crocodile
        crocodile.physicsBody?.collisionBitMask = 0
        crocodile.physicsBody?.contactTestBitMask = PhysicsCategory.Prize
        crocodile.physicsBody?.isDynamic = false
        addChild(crocodile)
        animateCrocodile()
    }
    
    fileprivate func animateCrocodile()
    {
        let durationOpen = drand48()+2
        let open = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let waitOpen = SKAction.wait(forDuration: durationOpen)
        let durationClosed = drand48()+drand48()+3.0
        let close = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let waitClosed = SKAction.wait(forDuration: durationClosed)
        let sequence = SKAction.sequence([waitOpen, open, waitClosed, close])
        let loop = SKAction.repeatForever(sequence)
        crocodile.run(loop)
    }
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval)
    {
        crocodile.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        
        crocodile.run(sequence)
        // transition to next level
        switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
    }
    
    //MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        vineCut = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            
            // check if vine cut
            scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint,
                                                using: { (body, point, normal, stop) in
                                                    self.checkIfVineCutWithBody(body)
            })
            
            // produce some nice particles
            showMoveParticles(touchPosition: startPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval)
    {
        //print(score)
        if levelOver && !caughtPineapple
        {
            return
        }
        
        if prize.position.y <= 0
        {
            removeLifeAndPineapple()
            levelOver = true
            
            if lives <= 0
            {
                displayGameOver()
                returnToMenuScene()
                score = 0
                //level = 0
                lives = 3
                return
            }
            
            run(splashSoundAction)
            switchToNewGameWithTransition(SKTransition.fade(withDuration: 1.0))
        }
    }
    
    func removeLifeAndPineapple()
    {
        prize.removeFromParent()
        lives -= 1
    }
    
    func returnToMenuScene()
    {
        let menuScene = MenuScene(size: self.size)
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 3)
        menuScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(menuScene, transition: transition)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if levelOver
        {
            return
        }
        
        if (contact.bodyA.node == crocodile && contact.bodyB.node == prize)
            || (contact.bodyA.node == prize && contact.bodyB.node == crocodile)
        {
            levelOver = true
            caughtPineapple = true
            score += 1
            
            // shrink the pineapple away
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([shrink, removeNode])
            prize.run(sequence)
            runNomNomAnimationWithDelay(0.15)
            run(nomNomSoundAction)
        }
    }
    
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody)
    {
        if vineCut && !GameConfiguration.CanCutMultipleVinesAtOnce
        {
            return
        }
        let node = body.node!
        // if it has a name it must be a vine node
        if let name = node.name
        {
            // snip the vine
            node.removeFromParent()
            run(sliceSoundAction)
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
            crocodile.removeAllActions()
            crocodile.texture = SKTexture(imageNamed: ImageName.CrocMouthOpen)
            animateCrocodile()
        }
        vineCut = true
    }
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition)
    {
        let delay = SKAction.wait(forDuration: 1)
        let sceneChange = SKAction.run({
            let scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })
        
        run(SKAction.sequence([delay, sceneChange]))
    }
    
    //MARK: - Audio
    //public static var backgroundMusicPlayer: AVAudioPlayer!
    
    fileprivate func setUpAudio()
    {
            startMusic()
            if !backgroundMusicPlayer.isPlaying
            {
                backgroundMusicPlayer.play()
            }
            sliceSoundAction = SKAction.playSoundFileNamed(SoundFile.Slice, waitForCompletion: false)
            splashSoundAction = SKAction.playSoundFileNamed(SoundFile.Splash, waitForCompletion: false)
            nomNomSoundAction = SKAction.playSoundFileNamed(SoundFile.NomNom, waitForCompletion: false)
    }
}
