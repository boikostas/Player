//
//  ViewController.swift
//  Player
//
//  Created by Стас Бойко on 18.11.2022.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var progressSlider: CustomSlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var player: Player!
    var songDidChange: (() -> Void)?
    
    var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLoadSetup()
        
    }
    
    //MARK: Full player first load mthd
    private func firstLoadSetup() {
        
        volumeSlider.value = player.player.volume
        
        setupUI()
        
        let timeLeft = Double(progressSlider.maximumValue) - Double(player.currentSongTime?.seconds ?? 0)
        
        switch player.list[player.songNumber].state {
        case .pause:
            progressSlider.value = Float(player.currentSongTime?.seconds ?? 0)
            currentTimeLabel.text = player.currentSongTime?.seconds.asString(style: .positional)
            lastTimeLabel.text = "-\(timeLeft.asString(style: .positional))"
        case .play:
            timeLabelAndSliderUpdate()
        }
    }
    
    //MARK: Volume slider change value
    @IBAction func volumeValueChanged(_ sender: UISlider) {
        player.player.volume = sender.value
    }
    
    //MARK: Time slider change value
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        displayLink?.invalidate()
        
        let newSongTime = CMTime(seconds: Double(sender.value), preferredTimescale: 10000)
        let timeLeft = Double(progressSlider.maximumValue) - Double(newSongTime.seconds)
        
        switch player.list[player.songNumber].state {
        case .pause:
            player.currentSongTime = newSongTime
            currentTimeLabel.text = newSongTime.seconds.asString(style: .positional)
            lastTimeLabel.text = "-\(timeLeft.asString(style: .positional))"
        case .play:
            currentTimeLabel.text = newSongTime.seconds.asString(style: .positional)
            lastTimeLabel.text = "-\(timeLeft.asString(style: .positional))"
            player.playSong(at: newSongTime)
            timeLabelAndSliderUpdate()
        }
    }
    
    //MARK: Time labels and slider update mthd
    func timeLabelAndSliderUpdate() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateSongCurrentTime))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc func updateSongCurrentTime() {
        
        let timeLeft = Double(progressSlider.maximumValue) - Double(player.player.currentTime().seconds)
        
        currentTimeLabel.text = player.player.currentTime().seconds.asString(style: .positional)
        progressSlider.value = Float(player.player.currentTime().seconds)
        lastTimeLabel.text = "-\(timeLeft.asString(style: .positional))"
    }
    
    //MARK: UI setup mthd
    func setupUI() {
        
        iconImage.layer.cornerRadius = 24
        iconImage.image = player.list[player.songNumber].icon
        titleLabel.text = player.list[player.songNumber].title
        authorLabel.text = player.list[player.songNumber].author
        
        backgroundView.backgroundColor = iconImage.image?.darkened()?.averageColor
        backgroundView.addBlurToView()
        
       
        
        player.checkPlayAndPauseButtomsState(playButton: playButton)
        player.checkPrevAndNextButtonsState(nextButton: nextButton, previousButton: previousButton)
        
        
        if let duration = player.player.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)
            progressSlider.minimumValue = 0.0
            progressSlider.maximumValue = Float(seconds)
        }
    }
    
    
    //MARK: Play/Pause button pressed
    @IBAction func playButtonPressed(_ sender: Any) {
        player.chechSongState(playButton: playButton)
        songDidChange?()
        
        switch player.list[player.songNumber].state {
        case .pause:
            displayLink?.invalidate()
        case .play:
            timeLabelAndSliderUpdate()
        }
    }
    
    //MARK: Previous button pressed
    @IBAction func previousButtonPressed(_ sender: Any) {
        
        player.currentSongTime = nil
        displayLink?.invalidate()
        player.list[player.songNumber].state = .pause
        player.songNumber -= 1
        timeLabelAndSliderUpdate()
        player.chechSongState(playButton: playButton)
        setupUI()
        songDidChange?()
    }
    
    //MARK: Next button pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        player.currentSongTime = nil
        displayLink?.invalidate()
        player.list[player.songNumber].state = .pause
        player.songNumber += 1
        timeLabelAndSliderUpdate()
        player.chechSongState(playButton: playButton)
        setupUI()
        songDidChange?()
    }
}





