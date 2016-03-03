//
//  RosterAddVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/3/1.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class RosterAddVC: UIViewController {

    @IBOutlet weak var rosterNameTF: UITextField!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        navigationItem.title = "添加好友"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "didClickCompletion")

    }
    
    func didClickCompletion(){
        
        if rosterNameTF.text! == AppTool.sharedInstance.userModel?.userName{
            print("不能添加自己为好友")
            return
        }
        
        let jid = XMPPJID.jidWithUser(rosterNameTF.text!, domain: "weixiangdemacbook-pro.local", resource: nil)
        
        if XmppTool.sharedInstance.rosterStorage!.userExistsWithJID(jid, xmppStream: XmppTool.sharedInstance.xmppStream){
            print("该好友已存在")
            return
        }
        
        
        XmppTool.sharedInstance.roster?.subscribePresenceToUser(jid)
        
        navigationController?.popViewControllerAnimated(true)
        
    }


}
