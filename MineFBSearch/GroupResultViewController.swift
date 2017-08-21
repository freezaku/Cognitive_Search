//
//  GroupResultViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/23.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class GroupResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupResultTableView: UITableView!
    
    @IBOutlet weak var groupSideBarButton: UIBarButtonItem!
    
    var nextPageUrl: String!
    var prevPageUrl: String!
    
    @IBOutlet weak var groupPrevOutBtn: UIButton!
    
    @IBOutlet weak var groupNextOutBtn: UIButton!
    

    @IBAction func groupPrevBtn(_ sender: AnyObject) {
        downLoadPaingGroupData(FINAL_URL: prevPageUrl)
    }
    
    
    @IBAction func groupNextBtn(_ sender: AnyObject) {
        downLoadPaingGroupData(FINAL_URL: nextPageUrl)
    }
    
    var favMode: Bool!
    
    var keyword: String!
    
    var groupMemberArray = [member]()
    
    var groupNameArray = [AnyObject]() {
        didSet {
            self.groupResultTableView.reloadData()
        }
    }
    
    var groupUrlArray = [String]()
    var groupIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupResultTableView.tableFooterView = UIView()
        SwiftSpinner.show("Loading data...")
        if revealViewController() != nil {
            groupSideBarButton.target = self.revealViewController()
            groupSideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        if favMode == true {
            self.title = "Favorite"
            getGroupDefaultData()
        } else {
            downloadGroupData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupResultTableViewCell
        
        let name = groupNameArray[indexPath.row]
        let url = groupUrlArray[indexPath.row]
        let id = groupIdArray[indexPath.row]
        var isisFavorite: String!
        
        cell.groupName.text = name as? String
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: url)
            let data = try? Data(contentsOf: imgurl!)
            
            DispatchQueue.main.async {
                cell.groupImage.image = UIImage(data: data!)
            }
        }
        
        if UserDefaults.standard.object(forKey: id) != nil {
            isisFavorite = "1"
            cell.groupFavoriteStateButton.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
        } else {
            isisFavorite = "0"
            cell.groupFavoriteStateButton.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
        }
        
        let groupMember = member(name: name as! String, picUrl: url, id: id, isisFavorite: isisFavorite, type: "group")
        
        groupMemberArray.append(groupMember)
        
        return cell
    }
    
    func downloadGroupData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?keyword=" + keyword + "&center=" + center;
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["group"]["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.groupNextOutBtn.isEnabled = false
            }
            
            self.prevPageUrl = json["group"]["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.groupPrevOutBtn.isEnabled = false
            }
            
            let singleData = json["group"]["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.groupNameArray.append(obj["name"]! as AnyObject)
                self.groupIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.groupUrlArray.append(url!)
            }
            SwiftSpinner.hide()
            print(self.groupNameArray)
        }
    }
    
    func getGroupDefaultData() {
        self.groupNextOutBtn.isEnabled = false
        self.groupPrevOutBtn.isEnabled = false
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            if key[idx] >= "0" && key[idx] <= "9"{
                let pageMemberData = UserDefaults.standard.data(forKey: key)
                let pageMemberModel = NSKeyedUnarchiver.unarchiveObject(with: pageMemberData!) as! member
                if pageMemberModel.type == "group" {
                    self.groupNameArray.append(pageMemberModel.name as AnyObject)
                    self.groupUrlArray.append(pageMemberModel.picUrl)
                    self.groupIdArray.append(pageMemberModel.id)
                }
            }
        }
        SwiftSpinner.hide()
    }
    
    func downLoadPaingGroupData(FINAL_URL: String) {
        self.groupNameArray.removeAll()
        self.groupIdArray.removeAll()
        self.groupUrlArray.removeAll()
        self.groupMemberArray.removeAll()
        
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            
            let json = JSON(result)
            
            self.nextPageUrl = json["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.groupNextOutBtn.isEnabled = false
            } else {
                self.groupNextOutBtn.isEnabled = true
            }
            
            self.prevPageUrl = json["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.groupPrevOutBtn.isEnabled = false
            } else {
                self.groupPrevOutBtn.isEnabled = true
            }
            
            let singleData = json["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                
                self.groupNameArray.append(obj["name"]! as AnyObject)
                
                self.groupIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.groupUrlArray.append(url!)
                
            }

            self.groupResultTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getGroupDetail" {
            if let tabVC = segue.destination as? UITabBarController{
                if let userTab = tabVC.viewControllers?[0] as? UserAlbumViewController {
                    if let IndexPath = self.groupResultTableView.indexPathForSelectedRow {
                        userTab.userId = groupIdArray[IndexPath.row]
                        userTab.userMember = groupMemberArray[IndexPath.row]
                    }
                }
                if let pageTab = tabVC.viewControllers?[1] as? UserPostViewController {
                    if let IndexPath = self.groupResultTableView.indexPathForSelectedRow {
                        pageTab.userId = groupIdArray[IndexPath.row]
                    }
                }
            }
            
            if let tabVC2 = segue.destination as? DetailViewController {
                if let IndexPath = self.groupResultTableView.indexPathForSelectedRow {
                    tabVC2.userId = groupIdArray[IndexPath.row]
                    tabVC2.userMember = groupMemberArray[IndexPath.row]
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favMode == true {
            self.groupNameArray.removeAll()
            self.groupIdArray.removeAll()
            self.groupUrlArray.removeAll()
            
            for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
                let idx = key.characters.startIndex
                if key[idx] >= "0" && key[idx] <= "9"{
                    let userMemberData = UserDefaults.standard.data(forKey: key)
                    let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                    if(userMemberModel.type == "group") {
                        self.groupNameArray.append(userMemberModel.name as AnyObject)
                        self.groupUrlArray.append(userMemberModel.picUrl)
                        self.groupIdArray.append(userMemberModel.id)
                    }
                    print("in pair: \(self.groupNameArray)")
                }
            }
        }
        
        self.groupResultTableView.reloadData()
    }
}
