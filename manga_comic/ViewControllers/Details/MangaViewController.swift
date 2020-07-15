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
    
    public static var currentManga = DetailManga.init() // mỗi lần bấm vào 1 bộ truyện currentManga sẽ thay đổi
    
    let mangapark = MangaPark()
    let mangaparkChache = MangaParkCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nameManga
        mangaTable.dataSource = self
        mangaTable.delegate = self
        if !Contains.didLoadDetailManga {
            mangapark.getDetailManga(url: urlManga)
        }
        addButtonBookmark()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadDetail"), object: nil)
    }
    
    func addButtonBookmark() {
        exitBookmark = mangaparkChache.checkExitItem(nameManga: nameManga, nameEntity: Contains.BOOKMARK_CORE_DATA)
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(addBookmark))
        if exitBookmark {
            button.tintColor = .black
        }
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func reload() {
        mangaTable.reloadData()
    }
    
    @objc func addBookmark() {
        if exitBookmark {
            mangaparkChache.deleteItem(nameManga: nameManga, nameEntity: Contains.BOOKMARK_CORE_DATA)
        } else {
            mangaparkChache.savaMangaToCoreData(mangaItem: MangaItem.init(name: nameManga, url: urlManga, imageUrl: imageUrl, newChap: ""), nameEntity: Contains.BOOKMARK_CORE_DATA)
        }
        NotificationCenter.default.post(name: NSNotification.Name("reloadReading"), object: nil)
        addButtonBookmark()
    }
}

extension MangaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MangaViewController.currentManga.volumAndChap.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell") as! MangaDetailTableViewCell
            cell.nameLb.text = nameManga
            cell.imageManga.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "down"))
            cell.ratingOverview.text = "Rating: " + MangaViewController.currentManga.ratingOverview
            cell.popularity.text = "Popularity: " + MangaViewController.currentManga.popularity
            cell.alternative.text = "Alternative: " + MangaViewController.currentManga.alternative
            cell.authors.text = "Author(s): " + MangaViewController.currentManga.authors
            cell.artists.text = "Artist(s): "  + MangaViewController.currentManga.artist
            cell.genre.text = "Genre(s): " + MangaViewController.currentManga.genre
            cell.type.text = "Type: " + MangaViewController.currentManga.type
            cell.status.text = "Status: " + MangaViewController.currentManga.status
            cell.mergeBy.text = "Merged By: " + MangaViewController.currentManga.mergeBy
            cell.lastest.text = "Latest: " + MangaViewController.currentManga.lastest
            cell.summary.text = "Summary: " + MangaViewController.currentManga.summary
            return cell
        } else {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "ChapterTableViewCell") as! ChapterTableViewCell
            let chapter = MangaViewController.currentManga.volumAndChap[indexPath.row - 1]
            cell.nameChapter.text = chapter.name
            return cell
        }
    }
}

extension MangaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if indexPath.row > 0 {
            let contentChater = storyboard.instantiateViewController(withIdentifier: "ContentChapterViewController") as? ContentChapterViewController
            contentChater?.urlContentChap = MangaViewController.currentManga.volumAndChap[indexPath.row - 1].urlVolumAndChap
            self.navigationController?.pushViewController(contentChater!, animated: true)
        }
    }
}
