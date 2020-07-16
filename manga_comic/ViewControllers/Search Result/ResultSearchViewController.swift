//
//  ResultSearchViewController.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ResultSearchViewController: UIViewController {
    @IBOutlet weak var resultSearchCollection: UICollectionView!
    @IBOutlet weak var azSort: UIButton!
    @IBOutlet weak var ratingSort: UIButton!
    @IBOutlet weak var updateSort: UIButton!
    @IBOutlet weak var createSort: UIButton!
    @IBOutlet weak var viewsSort: UIButton!
    
    var arrSearchMangaItem = [MangaItem]() // danh sách truyện trả về sau khi search
    
    let mangapark = MangaPark()
    let mangaparkCache = MangaParkCache()
    var page = 1
    var orderBy = "views_a"
    var mode = 4
    var arrSortButton = [UIButton]()
    
    var loadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchCollection.dataSource = self
        resultSearchCollection.delegate = self
        
        azSort.tag = 0
        ratingSort.tag = 1
        updateSort.tag = 2
        createSort.tag = 3
        viewsSort.tag = 4

        arrSortButton.append(azSort)
        arrSortButton.append(ratingSort)
        arrSortButton.append(updateSort)
        arrSortButton.append(createSort)
        arrSortButton.append(viewsSort)
        
        azSort.addTarget(self, action: #selector(changSort(_:)), for: .touchUpInside)
        ratingSort.addTarget(self, action: #selector(changSort(_:)), for: .touchUpInside)
        updateSort.addTarget(self, action: #selector(changSort(_:)), for: .touchUpInside)
        createSort.addTarget(self, action: #selector(changSort(_:)), for: .touchUpInside)
        viewsSort.addTarget(self, action: #selector(changSort(_:)), for: .touchUpInside)
        
        setUpButton()
        
        mangapark.search(orderBy: orderBy, page: page, callback: updateSearchResult(arr:))
    }
    
    func setUpButton() {
        for buttonSort in arrSortButton {
            if buttonSort.tag == mode {
                buttonSort.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            } else {
                buttonSort.setTitleColor(.black, for: .normal)
            }
        }
    }

    @objc func changSort(_ sender: UIButton) {
        page = 1
        arrSearchMangaItem.removeAll()
        resultSearchCollection.reloadData()
        mode = sender.tag
        if mode == 0 {
            orderBy = "a-z"
        } else if mode == 1 {
            orderBy = "rating"
        } else if mode == 2 {
            orderBy = "update"
        } else if mode == 3 {
            orderBy = "create"
        } else {
            orderBy = "views_a"
        }
        setUpButton()
        mangapark.search(orderBy: orderBy, page: page, callback: updateSearchResult(arr:))
        resultSearchCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func updateSearchResult(arr: [MangaItem]) {
        for item in arr {
            arrSearchMangaItem.append(item)
        }
        loadMore = false
        resultSearchCollection.reloadData()
    }
    
}

extension ResultSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSearchMangaItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultSearchCollection.dequeueReusableCell(withReuseIdentifier: "MangaCollectionViewCell", for: indexPath) as! MangaCollectionViewCell
        let mangaItem = arrSearchMangaItem[indexPath.row]
        cell.imageManga.sd_setImage(with: URL(string: mangaItem.imageUrl), placeholderImage: UIImage(named: "down"))
        cell.nameManga.text = mangaItem.name
        cell.newChapManga.text = mangaItem.newChap
        return cell
    }
}

extension ResultSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mangaItem = arrSearchMangaItem[indexPath.row]
        let detailManga = storyboard?.instantiateViewController(withIdentifier: "MangaViewController") as? MangaViewController
        detailManga?.urlManga = mangaItem.url
        detailManga?.nameManga = mangaItem.name
        detailManga?.imageUrl = mangaItem.imageUrl
        if mangaparkCache.checkExitItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA) {
            mangaparkCache.deleteItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA)
        }
        self.mangaparkCache.savaMangaToCoreData(mangaItem: arrSearchMangaItem[indexPath.row], nameEntity: Contains.RECENT_CORE_DATA)
        self.navigationController?.pushViewController(detailManga!, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        if offsetY > contenHeight - scrollView.frame.height && offsetY > 0 {
            if !loadMore {
                page += 1
                nextPage()
            }
        }
    }
    
    @objc func nextPage() {
        loadMore =  true
        mangapark.search(orderBy: orderBy, page: page, callback: updateSearchResult(arr:))
    }
}
