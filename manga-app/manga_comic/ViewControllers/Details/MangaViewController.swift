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
    
    var currentManga = DetailManga.init() // mỗi lần bấm vào 1 bộ truyện currentManga sẽ thay đổi
    
    let mangapark = MangaPark()
    let mangaparkChache = MangaParkCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nameManga
        mangaTable.dataSource = self
        mangaTable.delegate = self
        mangapark.getDetailManga(url: urlManga, callback: updateDetail(detail:))
        addButtonBookmark()
    }
    
    func addButtonBookmark() {
        exitBookmark = mangaparkChache.checkExitItem(nameManga: nameManga, nameEntity: Contains.BOOKMARK_CORE_DATA)
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(addBookmark))
        if exitBookmark {
            button.tintColor = .black
        }
        navigationItem.rightBarButtonItem = button
    }
    
    func updateDetail(detail: DetailManga) {
        currentManga = detail
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
        return currentManga.volumAndChap.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell") as! MangaDetailTableViewCell
            cell.nameLb.text = nameManga
            cell.imageManga.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "down"))
            cell.ratingOverview.text = "Rating: " + currentManga.ratingOverview
            cell.popularity.text = "Popularity: " + currentManga.popularity
            cell.alternative.text = "Alternative: " + currentManga.alternative
            cell.authors.text = "Author(s): " + currentManga.authors
            cell.artists.text = "Artist(s): "  + currentManga.artist
            cell.genre.text = "Genre(s): " + currentManga.genre
            cell.type.text = "Type: " + currentManga.type
            cell.status.text = "Status: " + currentManga.status
            cell.mergeBy.text = "Merged By: " + currentManga.mergeBy
            cell.lastest.text = "Latest: " + currentManga.lastest
            cell.summary.text = "Summary: " + currentManga.summary
            return cell
        } else {
            let cell = mangaTable.dequeueReusableCell(withIdentifier: "ChapterTableViewCell") as! ChapterTableViewCell
            let chapter = currentManga.volumAndChap[indexPath.row - 1]
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
            contentChater?.urlContentChap = currentManga.volumAndChap[indexPath.row - 1].urlVolumAndChap
            self.navigationController?.pushViewController(contentChater!, animated: true)
        }
    }
}
