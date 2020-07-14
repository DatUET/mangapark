//
//  RatingTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    
    var arrBtn = [UIButton]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        oneStar.tag = 0
        twoStar.tag = 1
        threeStar.tag = 2
        fourStar.tag = 3
        fiveStar.tag = 4
        
        arrBtn.append(oneStar)
        arrBtn.append(twoStar)
        arrBtn.append(threeStar)
        arrBtn.append(fourStar)
        arrBtn.append(fiveStar)
        
        oneStar.addTarget(self, action: #selector(changeStar), for: .touchUpInside)
        twoStar.addTarget(self, action: #selector(changeStar), for: .touchUpInside)
        threeStar.addTarget(self, action: #selector(changeStar), for: .touchUpInside)
        fourStar.addTarget(self, action: #selector(changeStar), for: .touchUpInside)
        fiveStar.addTarget(self, action: #selector(changeStar), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func changeStar(_ sender: UIButton) {
        Contains.rating = sender.tag
        for i in 0...Contains.rating {
            let btnImage = UIImage(named: "star yellow")
            arrBtn[i].setImage(btnImage , for: .normal)
        }
        if Contains.rating < 4 {
            for i in (Contains.rating + 1)...4 {
                let btnImage = UIImage(named: "star")
                arrBtn[i].setImage(btnImage , for: .normal)
            }
        }
    }

}
