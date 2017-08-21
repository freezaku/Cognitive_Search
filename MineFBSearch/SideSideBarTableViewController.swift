//
//  SideSideBarTableViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/24.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class SideSideBarTableViewController: UITableViewController {

    var array = ["", "MENU", "OTHERS"]
    let image: [UIImage] = [UIImage(named: "home")!, UIImage(named: "favorite")!]
    let str: [String] = ["Home", "Favorite"]
    var TableArray = ["fbsearch", "home", "favorite", "aboutme"]
    var numberOfRows = [1,2,1]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRows[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath)
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: "fb")
            cell.textLabel?.text = "Cognitive Search"
        }
        if indexPath.section == 1 {
            cell.imageView?.image = image[indexPath.row]
            cell.textLabel?.text = str[indexPath.row]
        }
        if indexPath.section == 2 {
            cell.textLabel?.text = "About me"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section]
    }

}
