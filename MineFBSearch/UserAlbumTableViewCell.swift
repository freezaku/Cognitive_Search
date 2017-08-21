//
//  UserAlbumTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/19.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class UserAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var firstview: UIView!
    
    @IBOutlet weak var firstViewLabel: UILabel!
    
    @IBOutlet weak var secondview: UIView!
    
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var albumImage1: UIImageView!
    
    @IBOutlet weak var albumImage2: UIImageView!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showsDetails = false {
        didSet {
            secondHeightConstraint.priority = showsDetails ? 250 : 999
        }
    }
}
