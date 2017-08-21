//
//  PlaceResultTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/23.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class PlaceResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var placeName: UILabel!

    @IBOutlet weak var placeFavoriteStateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
