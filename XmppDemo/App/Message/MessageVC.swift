//
//  MessageVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        navigationItem.title = "消息"
        
        view.backgroundColor = UIColor.grayColor()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let vc = LoginVC.controllerWithNib("LoginVC")
        
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
