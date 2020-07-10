//
//  DetailManga.swift
//  manga_comic
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class DetailManga {
    var rating: String
    var ratingOverview: String
    var popularity: String
    var alternative: String
    var authors: String
    var artist: String
    var genre: String
    var type: String
    var status: String
    var mergeBy: String
    var lastest: String
    var summary: String
    var volumAndChap: [VolumAndChap]
    
    init() {
        self.rating = ""
        self.ratingOverview = ""
        self.popularity = ""
        self.alternative = ""
        self.authors = ""
        self.artist = ""
        self.genre = ""
        self.type = ""
        self.status = ""
        self.mergeBy = ""
        self.lastest = ""
        self.summary = ""
        self.volumAndChap = []
    }
    
    init(rating: String, ratingOverview: String, popularity: String, alternative: String, authors: String, artist: String, genre: String, type: String, status: String, mergeBy: String, lastest: String, summary: String, volumAndChap: [VolumAndChap]) {
        self.rating = rating
        self.ratingOverview = ratingOverview
        self.popularity = popularity
        self.alternative = alternative
        self.authors = authors
        self.artist = artist
        self.genre = genre
        self.type = type
        self.status = status
        self.mergeBy = mergeBy
        self.lastest = lastest
        self.summary = summary
        self.volumAndChap = volumAndChap
    }
    
    public func removeDetails() {
        self.rating = ""
        self.ratingOverview = ""
        self.popularity = ""
        self.alternative = ""
        self.authors = ""
        self.artist = ""
        self.genre = ""
        self.type = ""
        self.status = ""
        self.mergeBy = ""
        self.lastest = ""
        self.summary = ""
        self.volumAndChap = []
    }
}
