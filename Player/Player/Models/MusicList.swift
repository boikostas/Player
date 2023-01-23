//
//  File.swift
//  Player
//
//  Created by Стас Бойко on 30.11.2022.
//

import Foundation
import UIKit


class MusicList {
    static var shared = MusicList()
    
    var list = [
        Song(title: "Дай руку мне", author: "Агаркин Николай"),
        Song(title: "Рідна сторона", author: "Іван Гаврищук"),
        Song(title: "17 лет", author: "Макс Корж"),
        Song(title: "Дивна Ніч", author: "Monatik"),
        Song(title: "Інша любов", author: "Enleo"),
        Song(title: "Приятная (feat. Ollane)", author: "Эндшпиль"),
        Song(title: "Думав Вона Янгол", author: "Колін"),
        Song(title: "Люблю", author: "Remeslo"),
        Song(title: "Буревестник (feat. Andy Panda)", author: "MiyaGi"),
        Song(title: "Камеры Врут", author: "10AGE"),
        Song(title: "Дай руку мне", author: "Агаркин Николай")
    ]
    
    private init() {}
}

class FavoriteSongs {
    static var shared = FavoriteSongs()
    
    var list = [Song]()
    
    private init() {}
}
