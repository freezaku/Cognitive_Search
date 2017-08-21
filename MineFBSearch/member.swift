//
//  member.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/21.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import Foundation
import UIKit

class member: NSObject, NSCoding {
    var name: String!
    var picUrl: String!
    var id: String!
    //var isFav: Bool
    var isisFavorite: String!
    var type: String!
    
    required init(name: String!, picUrl: String!, id: String!, isisFavorite: String!, type: String!) {
        self.name = name
        self.picUrl = picUrl
        self.id = id
        self.isisFavorite = isisFavorite
        self.type = type
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "Name") as! String!
        self.picUrl = decoder.decodeObject(forKey: "PicUrl") as! String!
        self.id = decoder.decodeObject(forKey: "Id") as! String!
        self.isisFavorite = decoder.decodeObject(forKey: "IsisFavorite") as! String!
        self.type = decoder.decodeObject(forKey: "Type") as! String!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(picUrl, forKey: "PicUrl")
        aCoder.encode(id, forKey: "Id")
        aCoder.encode(isisFavorite, forKey: "IsisFavorite")
        aCoder.encode(type, forKey: "Type")
    }
}
