//
//  UserModel.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import Foundation

class UserModel : NSObject{
    
    var userName: String?
    
    var userPwd: String?
    
    var isLogin: Bool = false
    
    init(userName: String, userPwd: String){
        
        self.userName = userName
        
        self.userPwd = userPwd
        
        self.isLogin = false
        
    }

    override init() {
        
        self.userName = nil
        
        self.userPwd = nil
        
    }
    
    func saveModel(){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(self.userName, forKey: "userName")
        
        userDefaults.setObject(self.userPwd, forKey: "userPwd")
        
        userDefaults.setBool(self.isLogin, forKey: "isLogin")
        
        userDefaults.synchronize()
        
    }
    
}