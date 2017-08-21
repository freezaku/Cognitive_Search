//
//  PlaceResultViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/23.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire

class PlaceResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var placeResultTableView: UITableView!
    
    @IBOutlet weak var placeSideBarBtn: UIBarButtonItem!
    
    var nextPageUrl: String!
    var prevPageUrl: String!
    
    @IBOutlet weak var placePrevOutBtn: UIButton!
    
    @IBOutlet weak var placeNextOutBtn: UIButton!
    
    @IBAction func placePrevBtn(_ sender: AnyObject) {
        downLoadPaingPlaceData(FINAL_URL: prevPageUrl)
    }
    
    @IBAction func placeNextBtn(_ sender: AnyObject) {
        downLoadPaingPlaceData(FINAL_URL: nextPageUrl)
    }
    
    var favMode: Bool!
    
    var keyword: String!
    
    var placeMemberArray = [member]()
    var placeNameArray = [AnyObject]() {
        didSet {
            self.placeResultTableView.reloadData()
        }
    }

    var placeUrlArray = [String]()
    var placeIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeResultTableView.tableFooterView = UIView()
        SwiftSpinner.show("Loading detail")
        if revealViewController() != nil {
            placeSideBarBtn.target = self.revealViewController()
            placeSideBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
        print("the keyword in page is: \(keyword)")
        if favMode == true {
            self.title = "Favorite"
            getPlaceDefaultData()
        } else {
            downloadPlaceData()
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
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceResultTableViewCell
        
        let name = placeNameArray[indexPath.row]
        let url = placeUrlArray[indexPath.row]
        let id = placeIdArray[indexPath.row]
        var isisFavorite: String!
        
        cell.placeName.text = name as? String
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: url)
            let data = try? Data(contentsOf: imgurl!)
            
            DispatchQueue.main.async {
                cell.placeImage.image = UIImage(data: data!)
            }
        }
        
        if UserDefaults.standard.object(forKey: id) != nil {
            isisFavorite = "1"
            cell.placeFavoriteStateButton.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
        } else {
            isisFavorite = "0"
            cell.placeFavoriteStateButton.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
        }
        
        let placeMember = member(name: name as! String, picUrl: url, id: id, isisFavorite: isisFavorite, type: "place")
        
        placeMemberArray.append(placeMember)
        
        return cell
        
    }
    
    func downloadPlaceData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?keyword=" + keyword + "&center=" + center;
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["place"]["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.placeNextOutBtn.isEnabled = false
            }
            self.prevPageUrl = json["place"]["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.placePrevOutBtn.isEnabled = false
            }
            
            let singleData = json["place"]["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.placeNameArray.append(obj["name"]! as AnyObject)
                self.placeIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.placeUrlArray.append(url!)
            }
            SwiftSpinner.hide()
            print(self.placeNameArray)
        }
    }
    
    func getPlaceDefaultData() {
        self.placeNextOutBtn.isEnabled = false
        self.placePrevOutBtn.isEnabled = false
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            if key[idx] >= "0" && key[idx] <= "9"{
                let pageMemberData = UserDefaults.standard.data(forKey: key)
                let pageMemberModel = NSKeyedUnarchiver.unarchiveObject(with: pageMemberData!) as! member
                if pageMemberModel.type == "place" {
                    self.placeNameArray.append(pageMemberModel.name as AnyObject)
                    self.placeUrlArray.append(pageMemberModel.picUrl)
                    self.placeIdArray.append(pageMemberModel.id)
                }
            }
        }
        SwiftSpinner.hide()
    }
    
    func downLoadPaingPlaceData(FINAL_URL: String) {
        self.placeNameArray.removeAll()
        self.placeIdArray.removeAll()
        self.placeUrlArray.removeAll()
        self.placeMemberArray.removeAll()
        
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            
            let json = JSON(result)
            
            self.nextPageUrl = json["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.placeNextOutBtn.isEnabled = false
            } else {
                self.placeNextOutBtn.isEnabled = true
            }
            
            self.prevPageUrl = json["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.placePrevOutBtn.isEnabled = false
            } else {
                self.placePrevOutBtn.isEnabled = true
            }
            
            let singleData = json["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                
                self.placeNameArray.append(obj["name"]! as AnyObject)
                
                self.placeIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.placeUrlArray.append(url!)
                
            }

            self.placeResultTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPlaceDetail" {
            if let tabVC = segue.destination as? UITabBarController{
                if let userTab = tabVC.viewControllers?[0] as? UserAlbumViewController {
                    if let IndexPath = self.placeResultTableView.indexPathForSelectedRow {
                        userTab.userId = placeIdArray[IndexPath.row]
                        userTab.userMember = placeMemberArray[IndexPath.row]
                    }
                }
                if let pageTab = tabVC.viewControllers?[1] as? UserPostViewController {
                    if let IndexPath = self.placeResultTableView.indexPathForSelectedRow {
                        pageTab.userId = placeIdArray[IndexPath.row]
                    }
                }
            }
            
            if let tabVC2 = segue.destination as? DetailViewController {
                if let IndexPath = self.placeResultTableView.indexPathForSelectedRow {
                    tabVC2.userId = placeIdArray[IndexPath.row]
                    tabVC2.userMember = placeMemberArray[IndexPath.row]
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favMode == true {
            self.placeNameArray.removeAll()
            self.placeIdArray.removeAll()
            self.placeUrlArray.removeAll()
            
            for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
                let idx = key.characters.startIndex
                if key[idx] >= "0" && key[idx] <= "9"{
                    let userMemberData = UserDefaults.standard.data(forKey: key)
                    let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                    if(userMemberModel.type == "place") {
                        self.placeNameArray.append(userMemberModel.name as AnyObject)
                        self.placeUrlArray.append(userMemberModel.picUrl)
                        self.placeIdArray.append(userMemberModel.id)
                    }
                    print("in pair: \(self.placeNameArray)")
                }
            }
        }
        
        self.placeResultTableView.reloadData()
    }

}
