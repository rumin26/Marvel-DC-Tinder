//
//  MatchesTableViewCell.swift
//  Tinder Clone
//
//  Created by Rumin on 12/15/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgview_User: UIImageView!
    @IBOutlet weak var lbl_username: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
