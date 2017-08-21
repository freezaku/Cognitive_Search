//
//  DetailViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/26.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import EasyToast
import SwiftSpinner
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class DetailViewController: UITabBarController, FBSDKSharingDelegate {

    var userId: String!
    var userMember = member(name: "", picUrl: "", id: "", isisFavorite: "0", type: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        let button1 = UIBarButtonItem(image: UIImage(named: "options"), style: .plain, target: self, action: #selector(showShareSheet(sender:)))
        self.navigationItem.rightBarButtonItem = button1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showShareSheet(sender: UIBarButtonItem) {
        var favState: String
        
        if userMember.isisFavorite == "1" {
            favState = "Remove from favorites"
        } else {
            favState = "Add to favorites"
        }
        
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: favState, style: .default, handler: {(action:UIAlertAction) in
            let userMemberData = NSKeyedArchiver.archivedData(withRootObject: self.userMember)
            if UserDefaults.standard.object(forKey: self.userMember.id) != nil {
                print("in fav, change it out fav")
                UserDefaults.standard.removeObject(forKey: self.userMember.id)
                self.userMember.isisFavorite = "0"
                self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            } else {
                print("out fav, change it in fav")
                UserDefaults.standard.set(userMemberData, forKey: self.userMember.id)
                self.userMember.isisFavorite = "1"
                self.view.showToast("Add to favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: {(action:UIAlertAction) in
            let shareContent: FBSDKShareLinkContent = FBSDKShareLinkContent()
            shareContent.contentTitle = self.userMember.name
            shareContent.contentDescription = "FB Share for CSCI 571"
            shareContent.imageURL = URL(string: self.userMember.picUrl)
            FBSDKShareDialog.show(from: self, with: shareContent, delegate: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if results.count > 0 {
            self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: false)
        } else {
            self.view.showToast("Cancel share!", position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.view.showToast("Share with error", position: .bottom, popTime: 2, dismissOnTap: false)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        self.view.showToast("Cancel share!", position: .bottom, popTime: 2, dismissOnTap: false)
    }
}
