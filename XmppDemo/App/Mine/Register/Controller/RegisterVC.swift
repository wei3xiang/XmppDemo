//
//  RegisterVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var pwdTF: UITextField!
    

    override func viewDidLoad() {

        super.viewDidLoad()
        
        navigationItem.title = "注册"
    }
    
    @IBAction func didClickRegister(sender: AnyObject) {
        
        let userName = userNameTF.text
        
        let pwd = pwdTF.text
        
        let userModel = UserModel(userName: userName!, userPwd: pwd!)
        
        AppTool.sharedInstance.userModel = userModel
        
        XmppTool.sharedInstance.isFromRegister = true
        
        XmppTool.sharedInstance.xmppRegister {(xmppRsultStatus) -> Void in
            
            switch xmppRsultStatus{
                
                case .XmppResultStatusSuccess:
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.navigationController?.popViewControllerAnimated(true)
                   
                    })
                case .XmppResultStatusFailure:
                    print("注册失败")
            }
            
        }
        
    }
    

}
