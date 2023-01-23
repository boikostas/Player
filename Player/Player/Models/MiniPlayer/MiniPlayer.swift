//
//  MiniPlayer.swift
//  Player
//
//  Created by Стас Бойко on 14.12.2022.
//

import UIKit

class MiniPlayer: UIView {
   
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var miniPlayerStackView: UIStackView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var player: Player!
    var vc: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MiniPlayerView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerRunning)))
    }
    
    @objc func tapOnPlayerRunning() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let playerVC = storyboard.instantiateViewController(withIdentifier: "playerViewController") as? PlayerViewController else { return }
    
        playerVC.player = player
        
        //MARK: Song chanded action
        playerVC.songDidChange = { [self] in
            setupUI(player.list[player.songNumber])
            player.checkPlayAndPauseButtomsState(playButton: playButton)
            
        }
        
        //MARK: Song played to end action
        player.songDidPlayToEnd = { [self] song in
            setupUI(player.list[song])
            playerVC.setupUI()
        }
        
        vc.present(playerVC, animated: true)
    }
    
    func setupUI(_ song: Song) {
        titleLabel.text = song.title
        iconImageView.image = song.icon
        player.checkPrevAndNextButtonsState(nextButton: forwardButton, previousButton: nil)
    }
    
    func activateConstraints(with view: UIView) {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        player.chechSongState(playButton: playButton)
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        player.list[player.songNumber].state = .pause
        player.currentSongTime = nil
        player.songNumber += 1
        
        player.chechSongState(playButton: playButton)
        setupUI(player.list[player.songNumber])
    }
    
    

}
