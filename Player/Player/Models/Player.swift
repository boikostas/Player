//
//  Player.swift
//  Player
//
//  Created by Стас Бойко on 30.11.2022.
//

import Foundation
import AVFoundation
import UIKit


class Player: AVPlayer {
    
    var player = AVPlayer()
    var isRunning = false
    var songNumber = 0
    var currentSongTime: CMTime?
    var list: [Song]! //= MusicList.shared.list
    var songDidPlayToEnd: ((Int) -> Void)?

    //MARK: Play mthd
    func playSong(at time: CMTime?) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let url = list[songNumber].url
            
            player = AVPlayer(url: url)
            
            if time == nil {
                player.play()
                isRunning = true
            } else {
                player.seek(to: time ?? CMTime())
                player.play()
                isRunning = true
            }

            NotificationCenter.default.addObserver(self, selector: #selector(songDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            
        } catch {
            print(error.localizedDescription)
        }
            
    }
    
    @objc private func songDidEnd() {
        currentSongTime = nil
        list[songNumber].state = .pause
        songNumber += 1
        chechSongState(playButton: nil)
        songDidPlayToEnd?(songNumber)
        print("ended")
        NotificationCenter.default.removeObserver(self)
    }

    
    //MARK: Pause mthd
    func pauseSong() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let url = list[songNumber].url
            
            player = AVPlayer(url: url)
            player.pause()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Check song state mthd
    func chechSongState(playButton: UIButton?) {
        switch list[songNumber].state {
        case .play:
            currentSongTime = player.currentTime()
            pauseSong()
            playButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
            list[songNumber].state = .pause
        case .pause:
            playSong(at: currentSongTime)
            playButton?.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            list[songNumber].state = .play
        }
    }
  
    //MARK: Check play/pause buttons state mthd
    func checkPlayAndPauseButtomsState(playButton: UIButton) {
        switch list[songNumber].state {
        case .play:
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .pause:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    //MARK: Check previous/next buttons state mthd 
    func checkPrevAndNextButtonsState(nextButton: UIButton, previousButton: UIButton?) {
        if songNumber == list.count - 1 {
            nextButton.isEnabled = false
        } else if songNumber < list.count - 1 {
            nextButton.isEnabled = true
        }
        
        if songNumber == 0 {
            previousButton?.isEnabled = false
        } else if songNumber > 0 {
            previousButton?.isEnabled = true
        }
    }

}
