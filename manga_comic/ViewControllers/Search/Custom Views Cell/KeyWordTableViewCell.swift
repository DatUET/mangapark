//
//  KeyWordTableViewCell.swift
//  manga_comic
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class KeyWordTableViewCell: UITableViewCell {
    @IBOutlet weak var nameKeyWord: UITextField!
    @IBOutlet weak var authorKeyWord: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameKeyWord.addTarget(self, action: #selector(nameTextFieldDidChange(_:)),
                            for: .editingChanged)
        authorKeyWord.addTarget(self, action: #selector(authTextFieldDidChange(_:)),
                                for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        Contains.nameKeyWord = textField.text!
    }
    
    @objc func authTextFieldDidChange(_ textField: UITextField) {
        Contains.authKeyWord = textField.text!
    }
}
