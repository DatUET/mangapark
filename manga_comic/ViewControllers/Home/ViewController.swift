//
//  ViewController.swift
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
        mangapark.loadAfterLauchApp(collectionView: colectionManga)
        mangaSegment.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    @objc func goToSearch() {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }
    
    @objc func reload() {
        Contains.arrCurrentMangaItem = Contains.arrMangaLastestItem
        colectionManga.reloadData()
    }

    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             colectionManga.setContentOffset(CGPoint(x:0,y:yLastest), animated: true)
            Contains.arrCurrentMangaItem = Contains.arrMangaLastestItem
        } else if sender.selectedSegmentIndex == 1 {
            colectionManga.setContentOffset(CGPoint(x:0,y:yNew), animated: true)
            Contains.arrCurrentMangaItem = Contains.arrMangaNewItem
        } else if sender.selectedSegmentIndex == 2 {
            colectionManga.setContentOffset(CGPoint(x:0,y:yHot), animated: true)
            Contains.arrCurrentMangaItem = Contains.arrMangaHotItem
        }
        colectionManga.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrCurrentMangaItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaCollectionViewCell", for: indexPath) as! MangaCollectionViewCell
        let mangaItem = Contains.arrCurrentMangaItem[indexPath.row]
        cell.imageManga.sd_setImage(with: URL(string: mangaItem.imageUrl), placeholderImage: UIImage(named: "down"))
        cell.nameManga.text = mangaItem.name
        cell.newChapManga.text = mangaItem.newChap
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mangaItem = Contains.arrCurrentMangaItem[indexPath.row]
        let detailManga = storyboard?.instantiateViewController(withIdentifier: "MangaViewController") as? MangaViewController
        detailManga?.urlManga = mangaItem.url
        detailManga?.nameManga = mangaItem.name
        detailManga?.imageUrl = mangaItem.imageUrl
        if mangaparkCache.checkExitItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA) {
            mangaparkCache.deleteItem(nameManga: mangaItem.name, nameEntity: Contains.RECENT_CORE_DATA)
        }
        self.mangaparkCache.savaMangaToCoreData(mangaItem: Contains.arrCurrentMangaItem[indexPath.row], nameEntity: Contains.RECENT_CORE_DATA)
        Contains.didLoadDetailManga = false
        Contains.currentManga.removeDetails()
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
            mangapark.getMangaLatest(page: currentPageLastest, collectionView: colectionManga)
        } else if mangaSegment.selectedSegmentIndex == 1 {
            currentPageNew += 1
            debugPrint(currentPageNew)
            mangapark.getNewManga(page: currentPageNew, collectionView: colectionManga)
        } else if mangaSegment.selectedSegmentIndex == 2 {
            currentPageHot += 1
            mangapark.getMangaHot(page: currentPageHot, collectionView: colectionManga)
        }
    }
}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            Contains.arrBookmarkManga = self.mangaparkCache.getMangaparkCoreData(nameEntity: Contains.BOOKMARK_CORE_DATA)
            Contains.arrRecentManga = self.mangaparkCache.getMangaparkCoreData(nameEntity: Contains.RECENT_CORE_DATA)
            viewController.viewDidLoad()
        }
    }
}
