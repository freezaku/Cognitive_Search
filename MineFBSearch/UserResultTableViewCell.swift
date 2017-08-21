//
//  UserResultTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/19.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class UserResultTableViewCell: UITableViewCell {
    
    //var userFavoriteItem = FavoriteItem()
    
    var userCellName: String!
    var userCellId: String!
    var userCellImgUrl: String!
    var userCellIsFav: Bool!
    var userCellIsisFav: String!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userFavoriteStateBtn: UIButton!
    
    @IBAction func userFavoriteBtn(_ sender: AnyObject) {
        let userMember = member(name: userCellName, picUrl: userCellImgUrl, id: userCellId, isisFavorite: userCellIsisFav, type: "user")
        let userMemberData = NSKeyedArchiver.archivedData(withRootObject: userMember)
        if UserDefaults.standard.object(forKey: userCellId) != nil {
            print("in")
            sender.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
            UserDefaults.standard.removeObject(forKey: userCellId)
        } else {
            print("out")
            sender.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
            UserDefaults.standard.set(userMemberData, forKey: userCellId)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
