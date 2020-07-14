//
//  Manga.swift
//  manga_comic
//
//  Created by gem on 7/6/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class MangaItem {
    var name: String
    var url: String
    var imageUrl: String
    var newChap: String
    
    init(name: String, url: String, imageUrl: String, newChap: String) {
        self.name = name
        self.url = url
        self.imageUrl = imageUrl
        self.newChap = newChap
    }
    
    init() {
        self.name = ""
        self.url = ""
        self.imageUrl = ""
        self.newChap = ""
    }
}
