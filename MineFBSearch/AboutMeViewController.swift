//
//  AboutMeViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/22.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var aboutMeSideBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if revealViewController() != nil {
            aboutMeSideBarBtn.target = self.revealViewController()
            aboutMeSideBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
