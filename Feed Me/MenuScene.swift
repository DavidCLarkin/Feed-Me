//
//  MenuScene.swift
//  Feed Me
//
//  Created by David on 30/11/2018.
//  Copyright © 2018 David Larkin. All rights reserved.
//

import SpriteKit
import AVFoundation

var menuButton: ButtonNode!
var optionsButton: ButtonNode!

class MenuScene: SKScene
{
    override func didMove(to view: SKView)
    {
        self.anchorPoint = CGPoint(x: 0,y: 0)
        setUpImage()
        setUpButtons()
    }
    
    fileprivate func setUpImage()
    {
        var background: SKSpriteNode!
        background = SKSpriteNode(imageNamed: ImageName.Background)
        background.anchorPoint = CGPoint(x: 0, y:0)
        background.position = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = Layer.Background
        addChild(background)
        
    }
    
    fileprivate func setUpButtons()
    {
        // Add menu button
        menuButton = ButtonNode(iconName: ImageName.ButtonRestart,text: String("Start"), onButtonPress: startButtonPressed)
        menuButton.zPosition = Layer.Hud
        menuButton.position = CGPoint(x: size.width * 0.5, y: menuButton.size.height / 2 + size.height / 2)
        self.addChild(menuButton)
        
        // Add options button
        
        optionsButton = ButtonNode(iconName: ImageName.ButtonMenu,text: String("Cut Many Vines? \(GameConfiguration.CanCutMultipleVinesAtOnce)"), onButtonPress: optionsButtonPressed)
        optionsButton.zPosition = Layer.Hud
        optionsButton.label.fontSize = 22
        optionsButton.position = CGPoint(x: size.width * 0.5, y: optionsButton.size.height / 2 + size.height * 0.4)
        self.addChild(optionsButton)
        
    }
    
    func startButtonPressed()
    {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(gameScene, transition: transition)
        
    }
    
    func optionsButtonPressed()
    {
        // I couldn't find out how to actually update this button when the variable changed, using didSet didn't seem to work either
        GameConfiguration.CanCutMultipleVinesAtOnce = !GameConfiguration.CanCutMultipleVinesAtOnce
        optionsButton.label.text = "Cut Many Vines? \(!GameConfiguration.CanCutMultipleVinesAtOnce)"
    }
 
    
    override func update(_ currentTime: TimeInterval)
    {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else
        {
            return
        }
        let touchLocation = touch.location(in: self)
        print("\(touchLocation)")
    }
}
