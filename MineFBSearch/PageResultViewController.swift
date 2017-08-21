//
//  PageResultViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/20.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class PageResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pageResultTableView: UITableView!
    
    @IBOutlet weak var pageSideBarBtn: UIBarButtonItem!
    
    var nextPageUrl: String!
    var prevPageUrl: String!
    
    @IBOutlet weak var pagePrevOutBtn: UIButton!
    
    @IBOutlet weak var pageNextOutBtn: UIButton!
    
    @IBAction func pagePrevBtn(_ sender: AnyObject) {
        downLoadPagingPageData(FINAL_URL: prevPageUrl)
    }
    
    
    @IBAction func pageNextBtn(_ sender: AnyObject) {
        downLoadPagingPageData(FINAL_URL: nextPageUrl)
    }
    
    
    var favMode: Bool!
    
    var keyword: String!
    
    var pageMemberArray = [member]()
    
    var pageNameArray = [AnyObject]() {
        didSet {
            print("something")
            self.pageResultTableView.reloadData()
        }
    }
    
    var pageUrlArray = [String]()
    var pageIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageResultTableView.tableFooterView = UIView()
        SwiftSpinner.show("Loading detail...")
        if revealViewController() != nil {
            pageSideBarBtn.target = self.revealViewController()
            pageSideBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        pageResultTableView.delegate = self
        pageResultTableView.dataSource = self
        // Do any additional setup after loading the view.
        print("the keyword in page is: \(keyword)")
        if favMode == true {
            getUserDefaultData()
        } else {
            downloadPageData()
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
        return pageNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath) as! PageResultTableViewCell
        
        let name = pageNameArray[indexPath.row]
        let url = pageUrlArray[indexPath.row]
        let id = pageIdArray[indexPath.row]
        var isisFavorite: String!
        
        cell.pageName.text = name as? String
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: url)
            let data = try? Data(contentsOf: imgurl!)
            
            DispatchQueue.main.async {
                cell.pageImage.image = UIImage(data: data!)
            }
        }
        
        if UserDefaults.standard.object(forKey: id) != nil {
            isisFavorite = "1"
            cell.pageFavoriteStateButton.setImage(UIImage(named: "filled.png"), for: UIControlState.normal)
        } else {
            isisFavorite = "0"
            cell.pageFavoriteStateButton.setImage(UIImage(named: "empty.png"), for: UIControlState.normal)
        }
        
        let pageMember = member(name: name as! String, picUrl: url, id: id, isisFavorite: isisFavorite, type: "page")
        pageMemberArray.append(pageMember)
        
        return cell
    }
    
    func downloadPageData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?keyword=" + keyword + "&center=" + center;
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["page"]["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.pageNextOutBtn.isEnabled = false
            }
            self.prevPageUrl = json["page"]["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.pagePrevOutBtn.isEnabled = false
            }
            
            let singleData = json["page"]["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.pageNameArray.append(obj["name"]! as AnyObject)
                self.pageIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.pageUrlArray.append(url!)
            }
            SwiftSpinner.hide()
            print(self.pageNameArray)
        }
    }
    
    func getUserDefaultData() {
        self.pageNextOutBtn.isEnabled = false
        self.pagePrevOutBtn.isEnabled = false
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            let idx = key.characters.startIndex
            if key[idx] >= "0" && key[idx] <= "9"{
                let pageMemberData = UserDefaults.standard.data(forKey: key)
                let pageMemberModel = NSKeyedUnarchiver.unarchiveObject(with: pageMemberData!) as! member
                if pageMemberModel.type == "page" {
                    self.pageNameArray.append(pageMemberModel.name as AnyObject)
                    self.pageUrlArray.append(pageMemberModel.picUrl)
                    self.pageIdArray.append(pageMemberModel.id)
                }
            }
        }
        SwiftSpinner.hide()
    }
    
    func downLoadPagingPageData(FINAL_URL: String) {
        self.pageNameArray.removeAll()
        self.pageIdArray.removeAll()
        self.pageUrlArray.removeAll()
        self.pageMemberArray.removeAll()
        
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request")
            let result = response.result.value
            let json = JSON(result)
            
            self.nextPageUrl = json["paging"]["next"].string
            if self.nextPageUrl == nil {
                self.pageNextOutBtn.isEnabled = false
            } else {
                self.pageNextOutBtn.isEnabled = true
            }
            
            self.prevPageUrl = json["paging"]["previous"].string
            if self.prevPageUrl == nil {
                self.pagePrevOutBtn.isEnabled = false
            } else {
                self.pagePrevOutBtn.isEnabled = true
            }
            
            print("the nextpageurl is: \(self.nextPageUrl), \(self.prevPageUrl)")
            let singleData = json["data"].arrayObject  as! [AnyObject]
            for obj in singleData {
                self.pageNameArray.append(obj["name"]! as AnyObject)
                self.pageIdArray.append(obj["id"] as! String)
                let json2 = JSON(obj["picture"]!)
                let url = json2["data"]["url"].string
                self.pageUrlArray.append(url!)
            }
            print(self.pageNameArray)
            self.pageResultTableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPageDetail" {
            if let tabVC = segue.destination as? UITabBarController{
                if let userTab = tabVC.viewControllers?[0] as? UserAlbumViewController {
                    if let IndexPath = self.pageResultTableView.indexPathForSelectedRow {
                        userTab.userId = pageIdArray[IndexPath.row]
                        userTab.userMember = pageMemberArray[IndexPath.row]
                    }
                }
                if let pageTab = tabVC.viewControllers?[1] as? UserPostViewController {
                    if let IndexPath = self.pageResultTableView.indexPathForSelectedRow {
                        pageTab.userId = pageIdArray[IndexPath.row]
                    }
                }
            }
            
            if let tabVC2 = segue.destination as? DetailViewController {
                if let IndexPath = self.pageResultTableView.indexPathForSelectedRow {
                    tabVC2.userId = pageIdArray[IndexPath.row]
                    tabVC2.userMember = pageMemberArray[IndexPath.row]
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favMode == true {
            self.pageNameArray.removeAll()
            self.pageIdArray.removeAll()
            self.pageUrlArray.removeAll()

            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                let idx = key.characters.startIndex
                if key[idx] >= "0" && key[idx] <= "9"{
                    let userMemberData = UserDefaults.standard.data(forKey: key)
                    let userMemberModel = NSKeyedUnarchiver.unarchiveObject(with: userMemberData!) as! member
                    if(userMemberModel.type == "page") {
                        self.pageNameArray.append(userMemberModel.name as AnyObject)
                        self.pageUrlArray.append(userMemberModel.picUrl)
                        self.pageIdArray.append(userMemberModel.id)
                    }
                    print("in pair: \(self.pageNameArray)")
                }
            }
        }
        
        self.pageResultTableView.reloadData()
    }

}
