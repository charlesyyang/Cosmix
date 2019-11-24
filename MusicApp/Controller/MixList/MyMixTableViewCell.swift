//
//  MyMixTableViewCell.swift
//  MusicApp
//
//  Created by Charles Yang on 11/9/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import UIKit

class MyMixTableViewCell: UITableViewCell {

    @IBOutlet weak var mixName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
