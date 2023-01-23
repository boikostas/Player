//
//  Song.swift
//  Player
//
//  Created by Стас Бойко on 18.11.2022.
//

import Foundation
import UIKit

struct Song {
    var title: String
    var author: String
    var icon: UIImage? {
        UIImage(named: title)
    }
    var url: URL {
        Bundle.main.url(forResource: title, withExtension: "mp3")!
    }
    var state: SongState = .pause
    var liked: Bool = false
    
    enum SongState {
        case play, pause
    }
}

