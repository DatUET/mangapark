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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readingCollection.dataSource = self
        readingCollection.delegate = self
        if readSegment.selectedSegmentIndex == 0 {
            Contains.arrReadingItem = Contains.arrBookmarkManga.reversed()
        } else {
            Contains.arrReadingItem = Contains.arrRecentManga.reversed()
        }
        readingCollection.reloadData()
        readSegment.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
    }
    
    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Contains.arrReadingItem = Contains.arrBookmarkManga.reversed()
        } else {
            Contains.arrReadingItem = Contains.arrRecentManga.reversed()
        }
        readingCollection.reloadData()
    }
}

extension ReadingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrReadingItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaCollectionViewCell", for: indexPath) as! MangaCollectionViewCell
        let mangaItem = Contains.arrReadingItem[indexPath.row]
        cell.imageManga.sd_setImage(with: URL(string: mangaItem.imageUrl), placeholderImage: UIImage(named: "down"))
        cell.nameManga.text = mangaItem.name
        cell.newChapManga.text = mangaItem.newChap
        return cell
    }
}

extension ReadingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailManga = storyboard?.instantiateViewController(withIdentifier: "MangaViewController") as? MangaViewController
        detailManga?.urlManga = Contains.arrReadingItem[indexPath.row].url
        detailManga?.nameManga = Contains.arrReadingItem[indexPath.row].name
        detailManga?.imageUrl = Contains.arrReadingItem[indexPath.row].imageUrl
        Contains.didLoadDetailManga = false
        Contains.currentManga.removeDetails()
        self.navigationController?.pushViewController(detailManga!, animated: true)
    }
}
