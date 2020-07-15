//
//  MangaDetailTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/9/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageManga: UIImageView!
    @IBOutlet weak var ratingOverview: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var alternative: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var artists: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mergeBy: UILabel!
    @IBOutlet weak var lastest: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var summary: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
