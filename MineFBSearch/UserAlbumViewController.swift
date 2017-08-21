//
//  UserAlbumViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/19.
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

class UserAlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FBSDKSharingDelegate {

    @IBOutlet weak var userAlbumTableView: UITableView!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBAction func showActionSheet(_ sender: AnyObject) {
        
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
    
    var userId: String!
    var testString: String!

    var userMember = member(name: "", picUrl: "", id: "", isisFavorite: "0", type: "")
    
    var selectedIndex = -1;
    var dataArray : [[String:String]] = [["FirstName":"Hongli", "LastName":"Xu"], ["FirstName":"Iron", "LastName":"Man"], ["FirstName":"Hongli", "LastName":"Xu"], ["FirstName":"Hongli", "LastName":"Xu"], ["FirstName":"Hongli", "LastName":"Xu"]]
    
    var userAlbumNameArray = [String](){
        didSet {
            print("reload data")
            self.userAlbumTableView.reloadData()
        }
    }
    
    var userAlbumImage1Array = [String]()
    var userAlbumImage2Array = [String]()
    var userAlbumImage1IdArray = [String]()
    var userAlbumImage2IdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userAlbumTableView.tableFooterView = UIView()
        print("in album")
        SwiftSpinner.show("Waiting for album detail...")
        downloadData()
        
        if userMember.isisFavorite == "1" {
            userIdLabel.text = "in fav"
        } else {
            userIdLabel.text = "not in fav"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAlbumNameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            return 400
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userAlbumCell", for: indexPath) as! UserAlbumTableViewCell
        let obj = dataArray[indexPath.row]
        let albumName = userAlbumNameArray[indexPath.row]
        
        let url = "https://graph.facebook.com/v2.8/" + userAlbumImage1IdArray[indexPath.row] + "/picture?access_token=EAAFnSztxJcABAODu6Qpx0O6otbKsKZAOQITXXbRZAZCNIbaTvxXOzVdOyQzmGSF7vVQrTVQ85sIK0PrT0WB0RqAK8x5zLBkCXBVPI8whGghrAcGyElcdBZBa4fcXh5NKfislynXuLQBZBfZCbZAOHoH5kxFYn3oIUEZD"
        let url2 = "https://graph.facebook.com/v2.8/" + userAlbumImage2IdArray[indexPath.row] + "/picture?access_token=EAAFnSztxJcABAODu6Qpx0O6otbKsKZAOQITXXbRZAZCNIbaTvxXOzVdOyQzmGSF7vVQrTVQ85sIK0PrT0WB0RqAK8x5zLBkCXBVPI8whGghrAcGyElcdBZBa4fcXh5NKfislynXuLQBZBfZCbZAOHoH5kxFYn3oIUEZD"
        
        cell.firstViewLabel.text = albumName
        cell.secondViewLabel.text = obj["LastName"]
        
        if userAlbumImage1IdArray[indexPath.row] != "" && userAlbumImage2IdArray[indexPath.row] != "" {
            DispatchQueue.global().sync {
                
                let imgurl = URL(string: url)
                let imgurl2 = URL(string: url2)
                
                let data = try? Data(contentsOf: imgurl!)
                let data2 = try? Data(contentsOf: imgurl2!)
                
                print("the image is: \(data) and \(data2)")
                
                DispatchQueue.main.async {
                    cell.albumImage1.image = UIImage(data: data!)
                    cell.albumImage2.image = UIImage(data: data2!)
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.userAlbumTableView.beginUpdates()
        self.userAlbumTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.userAlbumTableView.endUpdates()
    }
    
    func downloadData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?detail=" + userId;
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request of album")
            let result = response.result.value
            let json = JSON(result)
            if let singleData = json["detail"]["albums"]["data"].arrayObject  as? [AnyObject] {
                for obj in singleData {
                    self.userAlbumNameArray.append(obj["name"] as! String)
                    let json2 = JSON(obj["photos"]!)
                    print("obj[photos]: \(obj["photos"])")
                    if json2["data"][0]["picture"] != nil {
                        self.userAlbumImage1Array.append(json2["data"][0]["picture"].string!)
                        self.userAlbumImage1IdArray.append(json2["data"][0]["id"].string!)
                    } else {
                        self.userAlbumImage1Array.append("")
                        self.userAlbumImage1IdArray.append("")
                    }
                    if json2["data"][1]["picture"] != nil {
                        self.userAlbumImage2Array.append(json2["data"][1]["picture"].string!)
                        self.userAlbumImage2IdArray.append(json2["data"][1]["id"].string!)
                    } else {
                        self.userAlbumImage2Array.append("")
                        self.userAlbumImage2IdArray.append("")
                    }
                }
            } else {
                self.noDataLabel.isHidden = false
                self.userAlbumTableView.isHidden = true
            }
            
            SwiftSpinner.hide()
            print("the imageid is \(self.userAlbumImage1IdArray)")
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if results.count > 0 {
            self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.view.showToast("Share with error", position: .bottom, popTime: 2, dismissOnTap: false)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        self.view.showToast("Cancel share!", position: .bottom, popTime: 2, dismissOnTap: false)
    }
}
