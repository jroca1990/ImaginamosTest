//
//  AppTableViewCell.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appCategory: UILabel!
    @IBOutlet weak var appCounter: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
