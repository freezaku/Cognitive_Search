//
//  PageResultTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/20.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class PageResultTableViewCell: UITableViewCell {

    @IBOutlet weak var pageImage: UIImageView!
    
    @IBOutlet weak var pageName: UILabel!
    
    @IBOutlet weak var pageFavoriteStateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
