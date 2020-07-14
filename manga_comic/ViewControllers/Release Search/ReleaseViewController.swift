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
        cell.genre.text = arrYear[indexPath.row]
        if arrYear[indexPath.row] == Contains.yearSearch {
            cell.genre.textColor = .blue
        } else {
            cell.genre.textColor = .black
        }
        return cell
    }
}

extension ReleaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Contains.yearSearch = arrYear[indexPath.row]
        yearCollection.reloadData()
    }
}
