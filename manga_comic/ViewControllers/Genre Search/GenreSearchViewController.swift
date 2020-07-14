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
        cell.genre.text = Contains.arrGenre[indexPath.row]
        if Contains.arrIndexGenreSelected.contains(indexPath.row) {
            cell.genre.textColor = .blue
        } else {
            cell.genre.textColor = .black
        }
        return cell
    }
}

extension GenreSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !Contains.arrIndexGenreSelected.contains(indexPath.row) {
            Contains.arrIndexGenreSelected.append(indexPath.row)
        } else {
            if let index = Contains.arrIndexGenreSelected.firstIndex(of: indexPath.row) {
                Contains.arrIndexGenreSelected.remove(at: index)
            }
        }
        genreCollection.reloadData()
    }
}
