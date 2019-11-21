//
//  PlaylistTableViewCell.swift
//  MusicApp
//
//  Created by shaina on 11/20/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import UIKit
import Foundation
class PlaylistTableViewCell: UITableViewCell {
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var playlistImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
