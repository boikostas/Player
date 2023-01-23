//
//  MusicListViewController.swift
//  Player
//
//  Created by Стас Бойко on 30.11.2022.
//

import UIKit

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerRunningHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerRunningView: MiniPlayer!
    
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerRunningView.player = player
        playerRunningView.vc = self
        
        player.list = MusicList.shared.list
        
        let navOnt = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let favTab = navOnt.topViewController as! FavoritesViewController
        
        favTab.player = player
        
        firstLoadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playerRunningView.setupUI(player.list[player.songNumber])
    }
    
    //MARK: First load mthd
    private func firstLoadSetup() {
        miniplayerSetup()
        tableViewRegister()
    }
    
    //MARK: Miniplayer first setup mthd
    private func miniplayerSetup() {
        playerRunningHeightConstraint.isActive = true
        playerRunningHeightConstraint.constant = 0
        playerRunningView.miniPlayerStackView.isHidden = true
    }
    
    //MARK: Table view register mthd
    private func tableViewRegister() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "songCell")
    }
}


extension MusicListViewController: UITableViewDelegate {
    
    //MARK: Tap on song from list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        player.list = MusicList.shared.list
       
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

extension MusicListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MusicList.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as? SongTableViewCell else { return UITableViewCell() }
        
        cell.songWasLiked = {
            if MusicList.shared.list[indexPath.row].liked == false {
                MusicList.shared.list[indexPath.row].liked = true
                FavoriteSongs.shared.list.append(MusicList.shared.list[indexPath.row])
            } else {
                MusicList.shared.list[indexPath.row].liked = false
                for index in 0..<FavoriteSongs.shared.list.count {
                    if FavoriteSongs.shared.list[index].title == MusicList.shared.list[indexPath.row].title {
                        FavoriteSongs.shared.list.remove(at: index)
                    }
                }
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.songWasRemoved = {
            for index in 0..<MusicList.shared.list.count {
                if MusicList.shared.list[index].title == MusicList.shared.list[indexPath.row].title {
                    MusicList.shared.list.remove(at: index)
                    break
                }
            }
            tableView.reloadData()
        }
        
        cell.selectionStyle = .none
        cell.configureCell(MusicList.shared.list[indexPath.row])
        
        return cell
    }
}
