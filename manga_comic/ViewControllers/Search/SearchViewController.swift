//
//  SearchViewController.swift
//  manga_comic
//
//  Created by gem on 7/10/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    func updateArrayIndexGenre(arrIndex: [Int])
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var nameKeyWord = ""
    var authKeyWord = ""
    var numberStar = 0
    var arrGenre = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        Contains.arrIndexGenreSelected.removeAll()
        Contains.status = ""
        Contains.yearSearch = ""
        
        searchTable.dataSource = self
        searchTable.delegate = self
        
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }

    @objc func search() {
        let resultSearchViewController = storyboard?.instantiateViewController(withIdentifier: "ResultSearchViewController") as? ResultSearchViewController
        self.navigationController?.pushViewController(resultSearchViewController!, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "KeyWordTableViewCell") as! KeyWordTableViewCell
            nameKeyWord = cell.nameKeyWord.text!
            authKeyWord = cell.nameKeyWord.text!
            return cell
        }  else if indexPath.row == 1 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "StatusSearchTableViewCell") as! StatusSearchTableViewCell
            return cell
        } else if indexPath.row == 3 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "ReleaseSearchTableViewCell") as! ReleaseSearchTableViewCell
            return cell
        } else if indexPath.row == 4 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "GenreTableViewCell") as! GenreTableViewCell
            return cell
        } else {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "FilterGenreTableViewCell") as! FilterGenreTableViewCell
            return cell
            
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let genreSearch = storyboard?.instantiateViewController(withIdentifier: "GenreSearchView") as! GenreSearchViewController
            navigationController?.pushViewController(genreSearch, animated: true)
        } else if indexPath.row == 3 {
            let releaseSearch = storyboard?.instantiateViewController(withIdentifier: "ReleaseViewController") as! ReleaseViewController
            navigationController?.pushViewController(releaseSearch, animated: true)
        }
    }
}
