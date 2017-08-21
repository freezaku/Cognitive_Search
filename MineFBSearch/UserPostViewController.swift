//
//  UserPostViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/20.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userPostTableView: UITableView!
    
    @IBOutlet weak var noPostDataLabel: UILabel!
    
    var userId: String!
    
    var userImageUrl: String!
    
    var userPostTimeArray = [String]()
    
    var userPostMessageArray = [String]() {
        didSet {
            print("user post")
            self.userPostTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userPostTableView.tableFooterView = UIView()
        self.userPostTableView.estimatedRowHeight = 80
        self.userPostTableView.rowHeight = UITableViewAutomaticDimension
        
        downloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostMessageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPostCell", for: indexPath) as? UserPostTableViewCell
        let message = userPostMessageArray[indexPath.row]
        let created_time = userPostTimeArray[indexPath.row]
        
        let dataFormatter =  DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+zzzz"
        dataFormatter.locale = Locale.init(identifier: "en_US")
        
        let dataObj = dataFormatter.date(from: created_time)
        dataFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        let date = dataFormatter.string(from: dataObj!)
        
        cell?.userPostLabel.text = message + "\n\n" + date
        
        DispatchQueue.global().sync {
            let imgurl = URL(string: userImageUrl)
            let data = try? Data(contentsOf: imgurl!)

            DispatchQueue.main.async {
                cell?.userHeadImageView.image = UIImage(data: data!)
            }
        }
        
        return cell!
    }
    
    func downloadData() {
        let FINAL_URL = "http://sample-env-1.pgykeptvd2.us-west-2.elasticbeanstalk.com/homework8.php?detail=" + userId;
        print("in post the user id is: \(userId)")
        Alamofire.request(FINAL_URL).responseJSON { response in
            print("in request of post")
            let result = response.result.value
            let json = JSON(result)
            
            self.userImageUrl = json["detail"]["picture"]["data"]["url"].string
            
            if let singleData = json["detail"]["posts"]["data"].arrayObject  as? [AnyObject] {
                for obj in singleData {
                    print(obj)
                    let message = obj["message"]
                    
                    if message != nil {
                        print(obj["message"])
                        self.userPostMessageArray.append(obj["message"] as! String)
                    } else {
                        self.userPostMessageArray.append("")
                    }
                    
                    if obj["created_time"] != nil {
                        self.userPostTimeArray.append(obj["created_time"] as! String)
                    } else {
                        self.userPostTimeArray.append("")
                    }
                    
                }
            } else {
                self.noPostDataLabel.isHidden = false
                self.userPostTableView.isHidden = true
            }
            print("the message is \(self.userPostMessageArray)")
        }
    }

}
