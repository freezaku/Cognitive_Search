//
//  SideBarTableViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/22.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {

    var array = ["", "MENU", "OTHERS"]
    var numberOfRows = [1, 2, 1]
    var TableArray = ["sideBarHomeCell", "sideFavoriteCell", "sideBarMeCell", "sideBarMeCell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarHomeCell", for: indexPath)
            
            cell.imageView?.image = UIImage(named:"home.png")
            cell.textLabel?.text = "Home"
            
            return cell
        } else if indexPath.row == 3 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "sideBarFavoriteCell", for: indexPath)
            cell2.imageView?.image = UIImage(named:"favorite.png")
            cell2.textLabel?.text = "Favorite"
            return cell2
        } else if indexPath.row == 5 {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "sideBarMeCell", for: indexPath)
            cell3.textLabel?.text = "About me"
            return cell3
        } else if indexPath.row == 0{
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "sideBarFbCell", for: indexPath)
            cell4.imageView?.image = UIImage(named:"fb.png")
            cell4.textLabel?.text = "FB Search"
            return cell4
        } else if indexPath.row == 1{
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
            cell5.textLabel?.text = "MENU"
            cell5.textLabel?.frame = CGRect(x: 0, y: 0, width: 200, height: 21)
            cell5.backgroundColor = UIColor.lightGray
            return cell5
        } else {
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "testCell2", for: indexPath)
            cell6.textLabel?.text = "OTHERS"
            cell6.backgroundColor = UIColor.lightGray
            return cell6
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFavorite" {
            if let detailTab = segue.destination as? UITabBarController {
                if let userDetailNavVC = detailTab.viewControllers?[0] as? UINavigationController {
                    if let userDetailVC = userDetailNavVC.childViewControllers[0] as? UserResultViewController {
                        userDetailVC.keyword = ""
                        userDetailVC.favMode = true
                    }
                }
                if let pageDetailNavVC = detailTab.viewControllers?[1] as? UINavigationController {
                    if let pageDetailVC = pageDetailNavVC.childViewControllers[0] as? PageResultViewController {
                        pageDetailVC.keyword = ""
                        pageDetailVC.favMode = true
                    }
                }
                if let eventDetailNavVC = detailTab.viewControllers?[2] as? UINavigationController {
                    if let eventDetailVC = eventDetailNavVC.childViewControllers[0] as? EventResultViewController {
                        eventDetailVC.keyword = ""
                        eventDetailVC.favMode = true
                    }
                }
                if let placeDetailNavVC = detailTab.viewControllers?[3] as? UINavigationController {
                    if let placeDetailVC = placeDetailNavVC.childViewControllers[0] as? PlaceResultViewController {
                        placeDetailVC.keyword = ""
                        placeDetailVC.favMode = true
                    }
                }
                if let groupDetailNavVC = detailTab.viewControllers?[4] as? UINavigationController {
                    if let groupDetailVC = groupDetailNavVC.childViewControllers[0] as? GroupResultViewController{
                        groupDetailVC.keyword = ""
                        groupDetailVC.favMode = true
                    }
                }
            }
        }
    }
}
