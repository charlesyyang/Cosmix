//
//  MixTableViewCell.swift
//  MusicApp
//
//  Created by Charles Yang on 11/14/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit

class MixTableViewCell: UITableViewCell {

    @IBOutlet weak var mixName: UILabel!
    @IBOutlet weak var mixID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
