//
//  AppTool.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import Foundation

class AppTool{
    
    var userModel: UserModel?{
        
        didSet{
            userModel!.saveModel()
        }
    }
    
    
    func saveModel(){
        
    }
    
    class var sharedInstance : AppTool {
        
        struct Static {
            
            static let instance : AppTool = AppTool()
        }
        
        return Static.instance
    }
    
    func readUserModel() -> UserModel{
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userModel == nil{
            
            userModel = UserModel()
            
        }
        
        userModel!.userName = userDefaults.valueForKey("userName") as? String
        
        userModel!.userPwd = userDefaults.valueForKey("userPwd") as? String
        
        var isLogin: Bool = false
        
        if userDefaults.valueForKey("isLogin") != nil{
            isLogin = userDefaults.valueForKey("isLogin") as! Bool
        }
        
        userModel!.isLogin = isLogin
        
        return userModel!
        
    }
    
}