//
//  SongTableViewCell.swift
//  Player
//
//  Created by Стас Бойко on 30.11.2022.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    var songWasLiked: (() -> Void)?
    var songWasRemoved: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ song: Song) {
        iconImage.image = song.icon
        titleLable.text = song.title
        authorLabel.text = song.author
        iconImage.layer.cornerRadius = 5
        
        if song.liked == true {
            optionsButton.menu = UIMenu(children: [
//                UICommand(title: "Unike", image: UIImage(systemName: "heart.slash"), action: #selector(likedSong)),
//                UICommand(title: "Remove", image: UIImage(systemName: "trash"), action: #selector(removeSong))
                UIAction(title: "Unlike", image: UIImage(systemName: "heart.slash"), handler: { [self] _ in
                    songWasLiked?()
                }),
                UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [self] _ in
                    songWasRemoved?()
                })
            ])
        } else {
            optionsButton.menu = UIMenu(children: [
//                UICommand(title: "Like", image: UIImage(systemName: "heart"), action: #selector(likedSong)),
//                UICommand(title: "Remove", image: UIImage(systemName: "trash"), action: #selector(removeSong))
            UIAction(title: "Like", image: UIImage(systemName: "heart"), handler: { [self] _ in
                songWasLiked?()
            }),
            UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [self] _ in
                songWasRemoved?()
            })
            ])
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
    }
    
    @objc func likedSong() {
        songWasLiked?()
    }
    
    @objc func removeSong() {
        songWasRemoved?()
    }
 
    
}
