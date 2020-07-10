//
//  ChapterTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/8/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {
    @IBOutlet weak var nameChapter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
