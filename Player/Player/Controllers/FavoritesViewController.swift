//
//  FavoritesViewController.swift
//  Player
//
//  Created by Стас Бойко on 13.12.2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerRunningView: MiniPlayer!
    @IBOutlet weak var playerRunningHeightConstraint: NSLayoutConstraint!
    
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "songCell")
        
        playerRunningView.player = player
        playerRunningView.vc = self

        
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        if player != nil {
            if player.isRunning == true {
                playerRunningView.isHidden = false
                playerRunningHeightConstraint.constant = 60
                
                playerRunningView.activateConstraints(with: playerRunningView)
                
                playerRunningView.setupUI(player.list[player.songNumber])
                player.checkPlayAndPauseButtomsState(playButton: playerRunningView.playButton)
            } else {
                playerRunningView.isHidden = true
                playerRunningHeightConstraint.constant = 0
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        player.list = FavoriteSongs.shared.list
        
        playerRunningHeightConstraint.constant = 60
        playerRunningView.miniPlayerStackView.isHidden = false
        
        playerRunningView.activateConstraints(with: playerRunningView)
        
        playerRunningView.iconImageView.layer.cornerRadius = 5
        
        player.currentSongTime = nil
        player.list[player.songNumber].state = .pause
        
        player.songNumber = indexPath.row
        
        playerRunningView.setupUI(player.list[player.songNumber])
        
        player.chechSongState(playButton: playerRunningView.playButton)
        
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoriteSongs.shared.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as? SongTableViewCell else { return UITableViewCell() }
        
        let song = FavoriteSongs.shared.list[indexPath.row]
        
        cell.configureCell(song)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
