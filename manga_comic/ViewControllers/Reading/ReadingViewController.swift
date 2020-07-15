//
//  ReadingViewController.swift
//  manga_comic
//
//  Created by gem on 7/10/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController {
    @IBOutlet weak var readingCollection: UICollectionView!
    @IBOutlet weak var readSegment: UISegmentedControl!
    
    let mangaparkChache = MangaParkCache()
    var arrReadingItem = [MangaItem]()
    public static var arrBookmarkManga = [MangaItem]() // danh sách truyện đã đc bookmark
    public static var arrRecentManga = [MangaItem]() // danh sách truyện vửa đọc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readingCollection.dataSource = self
        readingCollection.delegate = self
        setUpCollection()
        readSegment.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadReading"), object: nil)
    }
    
    func setUpCollection() {
        if readSegment.selectedSegmentIndex == 0 {
            arrReadingItem = ReadingViewController.arrBookmarkManga.reversed()
        } else {
            arrReadingItem = ReadingViewController.arrRecentManga.reversed()
        }
        readingCollection.reloadData()
    }
    
    @objc func reload() {
        ReadingViewController.arrBookmarkManga = mangaparkChache.getMangaparkCoreData(nameEntity: Contains.BOOKMARK_CORE_DATA)
        ReadingViewController.arrRecentManga = mangaparkChache.getMangaparkCoreData(nameEntity: Contains.RECENT_CORE_DATA)
        setUpCollection()
    }
    
    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            arrReadingItem = ReadingViewController.arrBookmarkManga.reversed()
        } else {
            arrReadingItem = ReadingViewController.arrRecentManga.reversed()
        }
        readingCollection.reloadData()
    }
}

extension ReadingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrReadingItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaCollectionViewCell", for: indexPath) as! MangaCollectionViewCell
        let mangaItem = arrReadingItem[indexPath.row]
        cell.imageManga.sd_setImage(with: URL(string: mangaItem.imageUrl), placeholderImage: UIImage(named: "down"))
        cell.nameManga.text = mangaItem.name
        cell.newChapManga.text = mangaItem.newChap
        return cell
    }
}

extension ReadingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let detailManga = storyboard.instantiateViewController(withIdentifier: "MangaViewController") as? MangaViewController
        detailManga?.urlManga = arrReadingItem[indexPath.row].url
        detailManga?.nameManga = arrReadingItem[indexPath.row].name
        detailManga?.imageUrl = arrReadingItem[indexPath.row].imageUrl
        Contains.didLoadDetailManga = false
        MangaViewController.currentManga.removeDetails()
        self.navigationController?.pushViewController(detailManga!, animated: true)
    }
}
