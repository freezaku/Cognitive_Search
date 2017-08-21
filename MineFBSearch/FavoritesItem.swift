//
//  FavoritesItem.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/21.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class FavoriteItem {
    //var favoriteArray = [member]()
    var favoriteArray = [String: member]()
    
    func inFavorite(itemId: String)->Bool {
        if favoriteArray[itemId] == nil {
            return false
        } else {
            return false
        }
    }
    
    func addToFavorite(itemId: String, oneMember: member) {
        favoriteArray[itemId] = oneMember
    }
    
    func removeFromFavorite(itemId: String) {
        
    }
    
    func printFavorite() {
        let len = favoriteArray.count - 1
        print("the len of array is \(len)")
        print("the favorite array is: ")
        for (itemId, oneMember) in favoriteArray {
            print("\(itemId): \(oneMember.name)")
        }
    }
}
