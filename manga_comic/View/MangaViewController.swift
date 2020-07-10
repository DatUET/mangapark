//
//  DetailMangaViewController.swift
//  manga_comic
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class MangaViewController: UIViewController {
    @IBOutlet weak var mangaTable: UITableView!
    
    var urlManga = ""
    var nameManga = ""
    var imageUrl = ""
    var exitBookmark = false
    
    let mangapark = MangaPark()
    let mangaparkChache = MangaParkCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nameManga
        mangaTable.dataSource = self
        mangaTable.delegate = self
        exitBookmark = mangaparkChache.checkExitItem(nameManga: nameManga, nameEntity: Contains.BOOKMARK_CORE_DATA)
        if !Contains.didLoadDetailManga {
            mangapark.getDetailManga(url: urlManga)
        }
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(addBookmark))
        if exitBookmark {
            button.tintColor = .black
        }
        navigationItem.rightBarButtonItem = button
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadDetail"), object: nil)
    }
    
    @objc func reload() {
        mangaTable.reloadData()
        self.viewDidLoad()
    }
    
    @objc func addBookmark() {
        if exitBookmark {
            mangaparkChache.deleteItem(nameManga: nameManga, nameEntity: Contains.BOOKMARK_CORE_DATA)
        } else {
            mangaparkChache.savaMangaToCoreData(mangaItem: MangaItem.init(name: nameManga, url: urlManga, imageUrl: imageUrl, newChap: ""), nameEntity: Contains.BOOKMARK_CORE_DATA)
        }
        viewDidLoad()
    }
}

extension MangaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.currentManga.volumAndChap.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell") as! MangaDetailTableViewCell
            cell.nameLb.text = nameManga
            cell.imageManga.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "down"))
            cell.ratingOverview.text = "Rating: " + Contains.currentManga.ratingOverview
            cell.popularity.text = "Popularity: " + Contains.currentManga.popularity
            cell.alternative.text = "Alternative: " + Contains.currentManga.alternative
            cell.authors.text = "Author(s): " + Contains.currentManga.authors
            cell.artists.text = "Artist(s): "  + Contains.currentManga.artist
            cell.genre.text = "Genre(s): " + Contains.currentManga.genre
            cell.type.text = "Type: " + Contains.currentManga.type
            cell.status.text = "Status: " + Contains.currentManga.status
            cell.mergeBy.text = "Merged By: " + Contains.currentManga.mergeBy
            cell.lastest.text = "Latest: " + Contains.currentManga.lastest
            cell.summary.text = "Summary: " + Contains.currentManga.summary
            return cell
        } else {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "ChapterTableViewCell") as! ChapterTableViewCell
            let chapter = Contains.currentManga.volumAndChap[indexPath.row - 1]
            cell.nameChapter.text = chapter.name
            return cell
        }
    }
}

extension MangaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let contentChater = storyboard?.instantiateViewController(withIdentifier: "ContentChapterViewController") as? ContentChapterViewController
            contentChater?.urlContentChap = Contains.currentManga.volumAndChap[indexPath.row - 1].urlVolumAndChap
            self.navigationController?.pushViewController(contentChater!, animated: true)
        }
    }
}
