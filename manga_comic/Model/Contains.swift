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
    
    public static var arrMangaLastestItem = [MangaItem]()
    public static var arrMangaHotItem = [MangaItem]()
    public static var arrMangaNewItem = [MangaItem]()
    public static var arrCurrentMangaItem = [MangaItem]()
    public static var arrReadingItem = [MangaItem]()
    public static var arrBookmarkManga = [MangaItem]()
    public static var arrRecentManga = [MangaItem]()
    
    public static var loadMore = false
    public static var didLoadDetailManga = false
    public static var didLoadListImage = false
    public static var currentManga = DetailManga.init()
    public static var listImageOfChapter = [String]()
}
