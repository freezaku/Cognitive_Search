//
//  GroupResultTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/23.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class GroupResultTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupFavoriteStateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
