//
//  AppDelegate.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/24.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
       
        self.window = window
        
        switchRootVC()
        
        //打开xmpp日志
//        DDLog.addLogger(DDTTYLogger.sharedInstance())
        
        window.makeKeyAndVisible()
        
        return true
    }
    
    func switchRootVC(){
        
        let user = AppTool.sharedInstance.readUserModel()
        
        if user.isLogin{
 
            makeTabBarVC4WindowVC()
            
            XmppTool.sharedInstance.xmppLogin(nil)
            
        }else{
            
            let loginVC = LoginVC.controllerWithNib("LoginVC")
            
            let navVC = UINavigationController(rootViewController: loginVC)
            
            self.window!.rootViewController = navVC
        }
        
    }
    
    func makeTabBarVC4WindowVC(){
        
        let messageNavVC = navVCWith(MessageVC.controllerWithNib("MessageVC"), title: "消息")
        
        let rosterNavVC = navVCWith(RosterVC.controllerWithNib("RosterVC"), title: "好友")
        
        let discoveryNavVC = navVCWith(DiscoveryVC.controllerWithNib("DiscoveryVC"), title: "发现")
        
        let mineNavVC = navVCWith(MineVC.controllerWithNib("MineVC"), title: "我")
        
        let tabVC = UITabBarController()
        
        tabVC.viewControllers = [messageNavVC, rosterNavVC, discoveryNavVC, mineNavVC]
        
        self.window!.rootViewController = tabVC
        
    }
    
    
    func navVCWith(vc: UIViewController, title: String)->UINavigationController{
        
        let navVC = UINavigationController(rootViewController: vc)
        
        navVC.title = title
        
        return navVC
        
    }
    
}
