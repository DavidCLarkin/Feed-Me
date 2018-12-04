
//
//  ButtonNode.swift
//  FeedMe
//
//  Created by David on 30/11/2018.
//  Copyright © 2018 David Larkin. All rights reserved.
//

import SpriteKit

class ButtonNode : SKSpriteNode
{
    
    let onButtonPress: () -> ()
    var label = SKLabelNode(fontNamed: "Chalkduster")
    
    init(iconName: String, text: String, onButtonPress: @escaping () -> ())
    {
        self.onButtonPress = onButtonPress
        
        let texture = SKTexture(imageNamed: ImageName.Button)
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        
        let icon = SKSpriteNode(imageNamed: iconName)
        icon.position = CGPoint(x: -size.width * 0.5, y: 0)
        icon.zPosition = Layer.Hud
        self.addChild(icon)
        
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width * 0.01, y: 0)
        label.zPosition = Layer.Hud
        label.verticalAlignmentMode = .center
        label.text = text
        self.addChild(label)
        
        isUserInteractionEnabled = true
        
    }
    
    private func updateText(text: String)
    {
        label.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onButtonPress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
