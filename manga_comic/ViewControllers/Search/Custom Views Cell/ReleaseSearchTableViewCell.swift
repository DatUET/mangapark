//
//  ReleaseSearchTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ReleaseSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var year: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        year.text = SearchViewController.yearSearch
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadYear"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func reload() {
        year.text = SearchViewController.yearSearch
    }
}
