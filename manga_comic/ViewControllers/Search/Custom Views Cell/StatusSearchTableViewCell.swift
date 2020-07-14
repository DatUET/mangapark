//
//  StatusSearchTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class StatusSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var completed: UIButton!
    @IBOutlet weak var ongoing: UIButton!
    @IBOutlet weak var noStatus: UIButton!
    
    var arrButton = [UIButton]()
    
    var mode = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completed.tag = 0
        ongoing.tag = 1
        noStatus.tag = 2
        arrButton = [completed, ongoing, noStatus]
        setUpButton()
        
        completed.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
        ongoing.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
        noStatus.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setUpButton() {
        for buttonSort in arrButton {
            if buttonSort.tag == mode {
                buttonSort.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            } else {
                buttonSort.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @objc func changeStatus(_ sender: UIButton) {
        mode = sender.tag
        if mode == 0 {
            Contains.status = "completed"
        } else if mode == 1 {
            Contains.status = "ongoing"
        } else {
            Contains.status = ""
        }
        setUpButton()
    }
}
