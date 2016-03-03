//
//  HomeVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/24.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class MineVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "我"
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注销", style: UIBarButtonItemStyle.Plain, target: self, action: "didClickLoginOut")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "mineCell")
        
        cell.imageView?.image = UIImage(data: XmppTool.sharedInstance.vCardModule!.myvCardTemp.photo)
        
        cell.textLabel?.text = AppTool.sharedInstance.userModel?.userName
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyBoard = UIStoryboard(name: "ProfileVC", bundle: nil)
        
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ProfileVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didClickLoginOut(){
        
        XmppTool.sharedInstance.xmppLoginOut()
        
        //回到登录界面
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        appDelegate.switchRootVC()
    
    }
    
}
