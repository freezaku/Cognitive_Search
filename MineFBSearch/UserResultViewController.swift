//
//  UserResultViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/19.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class UserResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userResultTableView: UITableView!
    
    @IBOutlet weak var userSideBarButton: UIBarButtonItem!
    
    var nextPageUrl: String!
    var prevPageUrl: String!
    
    @IBOutlet weak var userPrevOutBtn: UIButton!
    
    @IBOutlet weak var userNextOutBtn: UIButton!
    
    
    @IBAction func userPrevBtn(_ sender: AnyObject) {
        downLoadPagingUserData(FINAL_URL: prevPageUrl)
    }
    
    @IBAction func userNextBtn(_ sender: AnyObject) {
        downLoadPagingUserData(FINAL_URL: nextPageUrl)
    }
    
    
    var favMode: Bool!
    
    var keyword: String!
    
    var userMemberArray = [member]()
    
    var userNameArray = [AnyObject]()  {
        didSet {
            print("something")
            self.userResultTableView.reloadData();
        }
    }
    var userUrlArray = [String]()
    
    var userIdArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userResultTableView.tableFooterView = UIView()
        print("The location is result is \(center)")
        if revealViewController() != nil {
            userSideBarButton.target = self.revealViewController()
            userSideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        SwiftSpinner.show("Loading data...")
        userResultTableView.delegate = self
        userResultTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        print("the keyword is: \(keyword)")
        print("the userdefault is ")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            print(key)
            if key[idx] >= "0" && key[idx] <= "9"{
                print("pair: \(key)")
            }
            
        }
        if favMode == true {
            self.title = "Favorite"
            getUserDefaultData()
        } else {
            downloadUserData()
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
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserResultTableViewCell
        
        let name = userNameArray[indexPath.row]
        let url = userUrlArray[indexPath.row]
        let id = userIdArray[indexPath.row]
        //var isFavorite: Bool
        var isisFavorite: String!
        
        cell.userName.text = name as? String
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: url)
            let data = try? Data(contentsOf: imgurl!)
            
            DispatchQueue.main.async {
                cell.userImage.image = UIImage(data: data!)
            }
        }
        
        cell.userCellName = userNameArray[indexPath.row] as! String
        cell.userCellImgUrl = userUrlArray[indexPath.row]
        cell.userCellId = userIdArray[indexPath.row]
        
        if UserDefaults.standard.object(forKey: id) != nil {
            isisFavorite = "1"
            cell.userCellIsFav = true
            cell.userFavoriteStateBtn.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
        } else {
            print("reset star???")
            isisFavorite = "0"
            cell.userCellIsFav = false
            cell.userFavoriteStateBtn.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
        }
        
        let userMember = member(name: name as! String, picUrl: url, id: id, isisFavorite: isisFavorite, type: "user")
        userMemberArray.append(userMember)
        
        return cell
    }
    
    func downloadUserData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?keyword=" + keyword + "&center=" + center;

        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            print(result)
            let json = JSON(result)
            
            self.nextPageUrl = json["user"]["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.userNextOutBtn.isEnabled = false
            }
            self.prevPageUrl = json["user"]["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.userPrevOutBtn.isEnabled = false
            }
            print("the nextpageurl is: \(self.nextPageUrl), \(self.prevPageUrl)")
            let singleData = json["user"]["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                print(obj["name"])
                print(obj["id"])
                self.userNameArray.append(obj["name"]! as AnyObject)
                self.userIdArray.append(obj["id"] as! String)
                print(obj["picture"])
                let json2 = JSON(obj["picture"]!)
                print("json2: \(json2)")
                let url = json2["data"]["url"].string
                print("the url is \(url)")
                self.userUrlArray.append(url!)
            }
            SwiftSpinner.hide()
            print(self.userNameArray)
        }
    }
    
    
    
    func getUserDefaultData() {
        self.userNextOutBtn.isEnabled = false
        self.userPrevOutBtn.isEnabled = false
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            if key[idx] >= "0" && key[idx] <= "9"{
                let userMemberData = UserDefaults.standard.data(forKey: key)
                let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                if(userMemberModel.type == "user") {
                    self.userNameArray.append(userMemberModel.name as AnyObject)
                    self.userUrlArray.append(userMemberModel.picUrl)
                    self.userIdArray.append(userMemberModel.id)
                }
                
            }
        }
        SwiftSpinner.hide()
    }
    
    func downLoadPagingUserData(FINAL_URL: String) {
        
        self.userNameArray.removeAll()
        self.userIdArray.removeAll()
        self.userUrlArray.removeAll()
        self.userMemberArray.removeAll()
        
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.userNextOutBtn.isEnabled = false
            } else {
                self.userNextOutBtn.isEnabled = true
            }
            self.prevPageUrl = json["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.userPrevOutBtn.isEnabled = false
            } else {
                self.userPrevOutBtn.isEnabled = true
            }
            print("the nextpageurl is: \(self.nextPageUrl), \(self.prevPageUrl)")
            let singleData = json["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.userNameArray.append(obj["name"]! as AnyObject)
                self.userIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.userUrlArray.append(url!)
            }
            print(self.userNameArray)
            self.userResultTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare1")
        if segue.identifier == "getUserDetail" {
            print("in prepare2")
            if let tabVC = segue.destination as? UITabBarController {
                print("in prepare3")
                if let userTab = tabVC.viewControllers?[0] as? UserAlbumViewController {
                    print("in prepare4")
                    if let IndexPath = self.userResultTableView.indexPathForSelectedRow {
                        print("in prepare5")
                        userTab.userId = userIdArray[IndexPath.row]
                        userTab.userMember = userMemberArray[IndexPath.row]
                    }
                }
                
                if let userPostTab = tabVC.viewControllers?[1] as? UserPostViewController {
                        print("in prepare6")
                    if let IndexPath = self.userResultTableView.indexPathForSelectedRow {
                        
                        userPostTab.userId = userIdArray[IndexPath.row]
                        print("in prepare7: \(userPostTab.userId)")
                    }
                }
            }
            
            if let tabVC2 = segue.destination as? DetailViewController {
                print("in prepare what1")
                if let IndexPath = self.userResultTableView.indexPathForSelectedRow {
                    print("in prepare what2")
                    tabVC2.userId = userIdArray[IndexPath.row]
                    tabVC2.userMember = userMemberArray[IndexPath.row]
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favMode == true {
            self.userNameArray.removeAll()
            self.userUrlArray.removeAll()
            self.userIdArray.removeAll()
            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                let idx = key.characters.startIndex
                if key[idx] >= "0" && key[idx] <= "9"{
                    let userMemberData = UserDefaults.standard.data(forKey: key)
                    let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                    if(userMemberModel.type == "user") {
                        self.userNameArray.append(userMemberModel.name as AnyObject)
                        self.userUrlArray.append(userMemberModel.picUrl)
                        self.userIdArray.append(userMemberModel.id)
                    }
                    print("in pair: \(self.userNameArray)")
                }
            }
        }
        self.userResultTableView.reloadData()
    }
}
