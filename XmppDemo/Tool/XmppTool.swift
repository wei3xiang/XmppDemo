//
//  XmppTool.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import Foundation

class XmppTool: NSObject,XMPPStreamDelegate{
    
    var xmppStream: XMPPStream?
    
    var vCardModule: XMPPvCardTempModule?
    
    var vcardStorage: XMPPvCardCoreDataStorage?
    
    var vcardAvatar: XMPPvCardAvatarModule?
    
    var roster: XMPPRoster?
    
    var rosterStorage: XMPPRosterCoreDataStorage?
    
    var messageArchiving: XMPPMessageArchiving?
    
    var messageArchivingStorage: XMPPMessageArchivingCoreDataStorage?
    
    var xmppResultClosure: ((xmppResultStatus: XmppResultStatusType)->Void)?
    
    var isFromRegister = false
    
    class var sharedInstance : XmppTool {
        
        struct Static {
            
            static let instance : XmppTool = XmppTool()
        }
        
        return Static.instance
    }
    
    //初始化xmppStream
    private func setUpXmppStream(){
        
        xmppStream = XMPPStream()
        
        vcardStorage = XMPPvCardCoreDataStorage.sharedInstance()
        
        vCardModule = XMPPvCardTempModule(withvCardStorage: vcardStorage!)
        //激活电子名片
        vCardModule!.activate(xmppStream!)
        //激活头像
        vcardAvatar = XMPPvCardAvatarModule(withvCardTempModule: vCardModule!)
        
        vcardAvatar!.activate(xmppStream!)
        
        //激活花名册
        rosterStorage = XMPPRosterCoreDataStorage.sharedInstance()
        
        roster = XMPPRoster(rosterStorage: rosterStorage!)
        
        roster!.activate(xmppStream!)
        
        //激活聊天
        messageArchivingStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        
        messageArchiving = XMPPMessageArchiving(messageArchivingStorage: messageArchivingStorage)
        
        messageArchiving?.activate(xmppStream!)
        
        //添加代理，子线程进行
        xmppStream!.addDelegate(self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        
    }
    
    //连接服务器
    private func connectToHost(){
        
        if xmppStream == nil{
        
            setUpXmppStream()
        
        }
        
        let user = AppTool.sharedInstance.userModel
        
        //1:设置jid
        let myJID = XMPPJID.jidWithUser(user!.userName, domain: "weixiangdemacbook-pro.local", resource: "iphone")
        
        xmppStream!.myJID = myJID
        //2:设置主机地址与端口号
        xmppStream!.hostName = "127.0.0.1"
        
        xmppStream!.hostPort = 5222
        
        //3:发送请求
        do {
            
            try xmppStream!.connectWithTimeout(XMPPStreamTimeoutNone)
            
        } catch {
            
            print("请求失败\(error)")
            
        }
    }
    
    //发送密码登录
    private func sendPwdToHost(){
        
        let pwd = AppTool.sharedInstance.userModel!.userPwd
        
        do{
            
            try xmppStream!.authenticateWithPassword(pwd)
            
        }catch{
            
            if let closure = xmppResultClosure{
                
                closure(xmppResultStatus: XmppResultStatusType.XmppResultStatusFailure)
            
            }
            
        }
        
    }
    
    //发送密码注册
    private func sendPwdToRegister(){
        
        let pwd = AppTool.sharedInstance.userModel!.userPwd
        
        do{
        
            try xmppStream!.registerWithPassword(pwd)
            
        }catch{

            if let closure = xmppResultClosure{
                
                closure(xmppResultStatus: XmppResultStatusType.XmppResultStatusFailure)
                
            }
            
        }
        
    }
    
//    更改服务器登录状态
    private func sendOnline(){
        
        let xmppPresence = XMPPPresence()
        
        xmppStream!.sendElement(xmppPresence)
    }
    
    //xmmppStream代理方法
    
    //请求成功返回结果
    func xmppStreamDidConnect(sender: XMPPStream!) {
        
        if isFromRegister{
            
            sendPwdToRegister()
        
        }else{
        
            sendPwdToHost()
        }
        
    }
    
    //登录认证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        
        sendOnline()
        
        AppTool.sharedInstance.userModel!.isLogin = true
        
        if let closure = xmppResultClosure{

            closure(xmppResultStatus: XmppResultStatusType.XmppResultStatusSuccess)
        }
        
    }
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        
        if let closure = xmppResultClosure{
            
            closure(xmppResultStatus: XmppResultStatusType.XmppResultStatusSuccess)
            
        }
        
    }
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        
        if let closure = xmppResultClosure{
            
            closure(xmppResultStatus: XmppResultStatusType.XmppResultStatusFailure)
            
        }
        
    }
    
    //公共方法
    
    //公共登录方法
    func xmppLogin(loginClosure: ((xmppRsultClosure: XmppResultStatusType)->Void)?){
        
        if let stream = xmppStream{
        
            stream.disconnect()
       
        }
        
        self.xmppResultClosure = loginClosure
        
        connectToHost()
        
    }
    
    //公共注册方法
    func xmppRegister(registerClosure: ((xmppRsultStatus: XmppResultStatusType)->Void)?){
    
        if let stream = xmppStream{
    
            stream.disconnect()
            
        }
        
        self.xmppResultClosure = registerClosure
        
        connectToHost()
    
    }
    
    //公共注销方法
    func xmppLoginOut(){
        
        let loginOutStatus = XMPPPresence(type: "unavailable")
        
        AppTool.sharedInstance.userModel!.isLogin = false
        
        AppTool.sharedInstance.userModel!.saveModel()
        
        if xmppStream == nil{
            print("xmppStream is nil")
        }

        xmppStream!.sendElement(loginOutStatus)
        
        xmppStream!.disconnect()
        
    }
    
    enum XmppResultStatusType{
        
        case XmppResultStatusSuccess
        
        case XmppResultStatusFailure
        
    }
    
}