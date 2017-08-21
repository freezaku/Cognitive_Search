//
//  EventResultViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/23.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class EventResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventResultTableView: UITableView!
    
    @IBOutlet weak var eventSideBarButton: UIBarButtonItem!
    
    var nextPageUrl: String!
    var prevPageUrl: String!
    
    @IBOutlet weak var eventPrevOutBtn: UIButton!
    
    @IBOutlet weak var eventNextOutBtn: UIButton!
    
    @IBAction func eventPrevBtn(_ sender: AnyObject) {
        downLoadPaingEventData(FINAL_URL: prevPageUrl)
    }
    
    @IBAction func eventNextBtn(_ sender: AnyObject) {
        downLoadPaingEventData(FINAL_URL: nextPageUrl)
    }
    
    
    
    
    
    var favMode: Bool!
    
    var keyword: String!
    
    var eventMemberArray = [member]()
    
    var eventNameArray = [AnyObject]() {
        didSet {
            self.eventResultTableView.reloadData()
        }
    }
    
    var eventUrlArray = [String]()
    var eventIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventResultTableView.tableFooterView = UIView()
        SwiftSpinner.show("Loading data...")
        if revealViewController() != nil {
            eventSideBarButton.target = self.revealViewController()
            eventSideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        print("the keyword in event is \(keyword)")
        if favMode == true {
            self.title = "Favorite"
            getEventDefaultData()
        } else {
            downloadEventData()
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
        return eventNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventResultTableViewCell
        
        let name = eventNameArray[indexPath.row]
        let url = eventUrlArray[indexPath.row]
        let id = eventIdArray[indexPath.row]
        var isisFavorite: String!
        
        cell.eventName.text = name as? String
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: url)
            let data = try? Data(contentsOf: imgurl!)
            
            DispatchQueue.main.async {
                cell.eventImage.image = UIImage(data: data!)
            }
        }
        
        if UserDefaults.standard.object(forKey: id) != nil {
            isisFavorite = "1"
            cell.eventFavoriteStateButton.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
        } else {
            isisFavorite = "0"
            cell.eventFavoriteStateButton.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
        }
        
        let eventMember = member(name: name as! String, picUrl: url, id: id, isisFavorite: isisFavorite, type: "event")
        
        eventMemberArray.append(eventMember)
        
        return cell
    }
    
    func downloadEventData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?keyword=" + keyword + "&center=" + center;
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["event"]["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.eventNextOutBtn.isEnabled = false
            }
            
            self.prevPageUrl = json["event"]["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.eventPrevOutBtn.isEnabled = false
            }
            
            let singleData = json["event"]["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.eventNameArray.append(obj["name"]! as AnyObject)
                self.eventIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.eventUrlArray.append(url!)
            }
            SwiftSpinner.hide()
            print(self.eventNameArray)
        }
    }
    
    func getEventDefaultData() {
        self.eventNextOutBtn.isEnabled = false
        self.eventPrevOutBtn.isEnabled = false
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            if key[idx] >= "0" && key[idx] <= "9"{
                let pageMemberData = UserDefaults.standard.data(forKey: key)
                let pageMemberModel = NSKeyedUnarchiver.unarchiveObject(with: pageMemberData!) as! member
                if pageMemberModel.type == "event" {
                    self.eventNameArray.append(pageMemberModel.name as AnyObject)
                    self.eventUrlArray.append(pageMemberModel.picUrl)
                    self.eventIdArray.append(pageMemberModel.id)
                }
            }
        }
        SwiftSpinner.hide()
    }
    
    func downLoadPaingEventData(FINAL_URL: String) {
        self.eventNameArray.removeAll()
        self.eventIdArray.removeAll()
        self.eventUrlArray.removeAll()
        self.eventMemberArray.removeAll()
        
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value

            let json = JSON(result)
            
            self.nextPageUrl = json["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.eventNextOutBtn.isEnabled = false
            } else {
                self.eventNextOutBtn.isEnabled = true
            }
            
            self.prevPageUrl = json["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.eventPrevOutBtn.isEnabled = false
            } else {
                self.eventPrevOutBtn.isEnabled = true
            }

            let singleData = json["data"].arrayObject  as! [AnyObject]
            for obj in singleData {

                self.eventNameArray.append(obj["name"]! as AnyObject)

                self.eventIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.eventUrlArray.append(url!)

            }
            self.eventResultTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getEventDetail" {
            if let tabVC = segue.destination as? UITabBarController{
                if let userTab = tabVC.viewControllers?[0] as? UserAlbumViewController {
                    if let IndexPath = self.eventResultTableView.indexPathForSelectedRow {
                        userTab.userId = eventIdArray[IndexPath.row]
                        userTab.userMember = eventMemberArray[IndexPath.row]
                    }
                }
                if let pageTab = tabVC.viewControllers?[1] as? UserPostViewController {
                    if let IndexPath = self.eventResultTableView.indexPathForSelectedRow {
                        pageTab.userId = eventIdArray[IndexPath.row]
                    }
                }
            }
            
            if let tabVC2 = segue.destination as? DetailViewController {
                if let IndexPath = self.eventResultTableView.indexPathForSelectedRow {
                    tabVC2.userId = eventIdArray[IndexPath.row]
                    tabVC2.userMember = eventMemberArray[IndexPath.row]
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favMode == true {
            self.eventNameArray.removeAll()
            self.eventIdArray.removeAll()
            self.eventUrlArray.removeAll()
            
            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                let idx = key.characters.startIndex
                if key[idx] >= "0" && key[idx] <= "9"{
                    let userMemberData = UserDefaults.standard.data(forKey: key)
                    let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                    if(userMemberModel.type == "event") {
                        self.eventNameArray.append(userMemberModel.name as AnyObject)
                        self.eventUrlArray.append(userMemberModel.picUrl)
                        self.eventIdArray.append(userMemberModel.id)
                    }
                    print("in pair: \(self.eventNameArray)")
                }
            }
        }
        
        self.eventResultTableView.reloadData()
    }

}
