//
//  GenreSearchViewController.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class GenreSearchViewController: UIViewController {
    @IBOutlet weak var genreCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollection.dataSource = self
        genreCollection.delegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: NSNotification.Name("reloadFilter"), object: nil)
    }
}

extension GenreSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreCollection.dequeueReusableCell(withReuseIdentifier: "FilterSearchItemCollectionViewCell", for: indexPath) as! FilterSearchItemCollectionViewCell
        cell.item.text = Contains.arrGenre[indexPath.row]
        if SearchViewController.arrIndexGenreSelected.contains(indexPath.row) {
            cell.item.layer.cornerRadius = 10.0
            cell.item.layer.masksToBounds = true
            cell.item.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            cell.item.textColor = .white
        } else {
            cell.item.layer.cornerRadius = 10.0
            cell.item.layer.masksToBounds = false
            cell.item.backgroundColor = .none
            cell.item.textColor = .black
        }
        return cell
    }
}

extension GenreSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !SearchViewController.arrIndexGenreSelected.contains(indexPath.row) {
            SearchViewController.arrIndexGenreSelected.append(indexPath.row)
        } else {
            if let index = SearchViewController.arrIndexGenreSelected.firstIndex(of: indexPath.row) {
                SearchViewController.arrIndexGenreSelected.remove(at: index)
            }
        }
        genreCollection.reloadData()
    }
}
