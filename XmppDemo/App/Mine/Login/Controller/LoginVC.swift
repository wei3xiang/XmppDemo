//
//  LoginVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {


    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var pwdTF: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()

    }
    
    
    @IBAction func didClickRegister(sender: AnyObject) {
        
        let registerVC = RegisterVC.controllerWithNib("RegisterVC")
        
        navigationController?.pushViewController(registerVC, animated: true)
        
    }

    @IBAction func didClickLogin(sender: AnyObject) {
        
        let userName = userNameTF.text
        
        let pwd = pwdTF.text
        
        let user = UserModel(userName: userName!, userPwd: pwd!)
        
        AppTool.sharedInstance.userModel = user
        
        XmppTool.sharedInstance.isFromRegister = false
        
        XmppTool.sharedInstance.xmppLogin {(xmppRsultClosure) -> Void in
            
            switch xmppRsultClosure{
                
                case .XmppResultStatusSuccess:
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        AppTool.sharedInstance.userModel!.isLogin = true
                        
                        AppTool.sharedInstance.userModel!.saveModel()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.makeTabBarVC4WindowVC()
                        
                    })
                
                case .XmppResultStatusFailure:
                    print("login Failure")
            }
        
        }
        
    }
}
