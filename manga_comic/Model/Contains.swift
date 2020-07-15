//
//  Contains.swift
//  manga_comic
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class Contains {
    public static let BASE_URL = "https://mangapark.net"
    public static let BOOKMARK_CORE_DATA = "BookmarkMangaPark"
    public static let RECENT_CORE_DATA = "RecentMangaPark"
    
    public static let arrGenre = ["4-komaAction", "Action", "Adaptation", "Adult", "Adventure", "Aliens", "Animals", "Anthology", "Award-winning", "Comedy", "Cooking", "Crime", "Crossdressing"," Delinquents", "Demons", "Doujinshi", "Drama", "Ecchi", "Fan colored", "Fantasy", "Food", "Full color", "Game", "Gender-bender", "Genderswap", "Ghosts", "Gore", "Gossip", "Gyaru", "Harem", "Historical", "Horror", "Incest", "Isekai", "Josei", "Kids", "Loli", "Lolicon", "Long strip", "Mafia", "Magic", "Magical-girls", "Manhwa", "Martial-arts", "Mature", "Mecha", "Medical", "Military", "Monster-girls", "Monsters", "Music", "Mystery", "Ninja", "Office-workers", "Official-colored", "One-shot", "Parody", "Philosophical", "Police", "Post-apocalyptic", "Psychological", "Reincarnation", "Reverse-harem", "Romance", "Samurai", "School-life", "Sci-fi", "Seinen", "Shota", "Shotacon", "Shoujo", "Shoujo-ai", "Shounen", "Shounen-ai", "Slice-of-life", "Smut", "Space", "Sports", "Super-power", "Superhero", "Supernatural", "Survival", "Suspense", "Thriller", "Time-travel", "Toomics", "Traditional-games", "Tragedy", "User-created", "Vampire", "Vampires", "Video-games", "Virtual-reality", "Web-comic", "Webtoon", "Wuxia", "Yaoi", "Yuri", "Zombies"]
    
    public static var loadMore = false
    public static var didLoadDetailManga = false // kiểm tra đã load và parse xong details hay chưa
    public static var didLoadListImage = false // kiểm tra load xong toàn bộ ảnh của 1 chap hay chưa
    public static var listImageOfChapter = [String]() // danh sách link imaga cho mỗi chap, sẽ đc thay đổi khi đọc 1 chap
}
