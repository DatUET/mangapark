//
// swift
//  manga_comic
//
//  Created by gem on 7/6/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var colectionManga: UICollectionView!
    @IBOutlet weak var mangaSegment: UISegmentedControl!
    
    var arrCurrentMangaItem = [MangaItem]()
    var arrMangaLastestItem = [MangaItem]() // danh sách truyện mới cập nhật
    var arrMangaHotItem = [MangaItem]() // danh sách truyện thịnh hành
    var arrMangaNewItem = [MangaItem]()
    
    var mangapark = MangaPark()
    let mangaparkCache = MangaParkCache()
    var currentPageLastest = 1
    var currentPageNew = 1
    var currentPageHot = 1
    var yLastest = CGFloat(0.0)
    var yNew = CGFloat(0.0)
    var yHot = CGFloat(0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colectionManga.dataSource = self
        colectionManga.delegate = self
        self.tabBarController?.delegate = self
        self.tabBarController?.title = "Manga"
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(goToSearch))
        tabBarController?.navigationItem.rightBarButtonItem = button
        mangapark.getMangaLatest(page: currentPageLastest, callback: addMangaLatest(arr:))
        mangapark.getNewManga(page: currentPageNew, callback: addMangaNew(arr:))
        mangapark.getMangaHot(page: currentPageHot, callback: addMangaHot(arr:))
        mangaSegment.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
    }
    
    @objc func goToSearch() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }
    
    func reload() {
        if mangaSegment.selectedSegmentIndex == 0 {
            arrCurrentMangaItem = arrMangaLastestItem
        } else if mangaSegment.selectedSegmentIndex == 1 {
            arrCurrentMangaItem = arrMangaNewItem
        } else if mangaSegment.selectedSegmentIndex == 2 {
            arrCurrentMangaItem = arrMangaHotItem
        }
        colectionManga.reloadData()
    }

    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             colectionManga.setContentOffset(CGPoint(x:0,y:yLastest), animated: true)
            arrCurrentMangaItem = arrMangaLastestItem
        } else if sender.selectedSegmentIndex == 1 {
            colectionManga.setContentOffset(CGPoint(x:0,y:yNew), animated: true)
            arrCurrentMangaItem = arrMangaNewItem
        } else if sender.selectedSegmentIndex == 2 {
            colectionManga.setContentOffset(CGPoint(x:0,y:yHot), animated: true)
            arrCurrentMangaItem = arrMangaHotItem
        }
        colectionManga.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCurrentMangaItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaCollectionViewCell", for: indexPath) as! MangaCollectionViewCell
        let mangaItem = arrCurrentMangaItem[indexPath.row]
        cell.imageManga.sd_setImage(with: URL(string: mangaItem.imageUrl), placeholderImage: UIImage(named: "down"))
        cell.nameManga.text = mangaItem.name
        cell.newChapManga.text = mangaItem.newChap
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mangaItem = arrCurrentMangaItem[indexPath.row]
        let detailManga = storyboard?.instantiateViewController(withIdentifier: "MangaViewController") as? MangaViewController
        detailManga?.urlManga = mangaItem.url
        detailManga?.nameManga = mangaItem.name
        detailManga?.imageUrl = mangaItem.imageUrl
        if mangaparkCache.checkExitItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA) {
            mangaparkCache.deleteItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA)
        }
        self.mangaparkCache.savaMangaToCoreData(mangaItem: arrCurrentMangaItem[indexPath.row], nameEntity: Contains.RECENT_CORE_DATA)
        self.navigationController?.pushViewController(detailManga!, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if mangaSegment.selectedSegmentIndex == 0 {
            yLastest = offsetY
        } else if mangaSegment.selectedSegmentIndex == 1 {
            yNew = offsetY
        } else {
            yHot = offsetY
        }
        let contenHeight = scrollView.contentSize.height
        if offsetY > contenHeight - scrollView.frame.height {
            if !Contains.loadMore {
                nextPage()
            }
        }
    }
    
    @objc func nextPage() {
        Contains.loadMore =  true
        if mangaSegment.selectedSegmentIndex == 0 {
            currentPageLastest += 1
            mangapark.getMangaLatest(page: currentPageLastest, callback: addMangaLatest(arr:))
        } else if mangaSegment.selectedSegmentIndex == 1 {
            currentPageNew += 1
            mangapark.getNewManga(page: currentPageNew, callback: addMangaNew(arr:))
        } else if mangaSegment.selectedSegmentIndex == 2 {
            currentPageHot += 1
            mangapark.getMangaHot(page: currentPageHot, callback: addMangaHot(arr:))
        }
    }
    
    func addMangaLatest(arr: [MangaItem]) {
        for item in arr {
            arrMangaLastestItem.append(item)
        }
        reload()
    }
    
    func addMangaNew(arr: [MangaItem]) {
        for item in arr {
            arrMangaNewItem.append(item)
        }
        reload()
    }
    
    func addMangaHot(arr: [MangaItem]) {
        for item in arr {
            arrMangaHotItem.append(item)
        }
        reload()
    }
}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            (viewController as! ReadingViewController).reload()
        }
    }
}
