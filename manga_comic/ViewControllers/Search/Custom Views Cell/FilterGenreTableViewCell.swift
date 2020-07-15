//
//  FilterGenreTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class FilterGenreTableViewCell: UITableViewCell {
    @IBOutlet weak var filerGenreCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filerGenreCollection.dataSource = self
        filerGenreCollection.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadFilter"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func reload() {
        filerGenreCollection.reloadData()
    }

}

extension FilterGenreTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchViewController.arrIndexGenreSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filerGenreCollection.dequeueReusableCell(withReuseIdentifier: "FilterSearchItemCollectionViewCell", for: indexPath) as! FilterSearchItemCollectionViewCell
        cell.item.text = Contains.arrGenre[SearchViewController.arrIndexGenreSelected[indexPath.row]]
        cell.item.layer.cornerRadius = 10.0
        cell.item.layer.masksToBounds = true
        return cell
    }
}

extension FilterGenreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchViewController.arrIndexGenreSelected.remove(at: indexPath.row)
        filerGenreCollection.reloadData()
    }
}
