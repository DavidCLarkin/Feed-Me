//
//  MusicHandler.swift
//  Feed Me
//
//  Created by David on 03/12/2018.
//  Copyright © 2018 David Larkin. All rights reserved.
//

import Foundation
import AVFoundation

public var backgroundMusicPlayer: AVAudioPlayer!

func startMusic()
{
    if backgroundMusicPlayer == nil
    {
        let backgroundMusicURL = Bundle.main.url(forResource: SoundFile.BackgroundMusic, withExtension: nil)
        
        do
        {
            let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
            backgroundMusicPlayer = theme
            
            if !backgroundMusicPlayer.isPlaying
            {
                backgroundMusicPlayer.play()
            }
        }
        catch
        {
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
    }
}
