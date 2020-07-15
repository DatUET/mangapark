//
//  RealseViewController.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ReleaseViewController: UIViewController {
    @IBOutlet weak var yearCollection: UICollectionView!
    
    var arrYear = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearCollection.dataSource = self
        yearCollection.delegate = self

        arrYear.append("null")
        for i in 1946...2017 {
            arrYear.append("\(i)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: NSNotification.Name("reloadYear"), object: nil)
    }
}

extension ReleaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrYear.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = yearCollection.dequeueReusableCell(withReuseIdentifier: "FilterSearchItemCollectionViewCell", for: indexPath) as! FilterSearchItemCollectionViewCell
        cell.item.text = arrYear[indexPath.row]
        if arrYear[indexPath.row] == SearchViewController.yearSearch {
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

extension ReleaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchViewController.yearSearch = arrYear[indexPath.row]
        yearCollection.reloadData()
    }
}
