//
//  MenuScene.swift
//  Feed Me
//
//  Created by David on 30/11/2018.
//  Copyright © 2018 David Larkin. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene
{
    override func didMove(to view: SKView)
    {
        print("started menu")
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
        
    }
}
