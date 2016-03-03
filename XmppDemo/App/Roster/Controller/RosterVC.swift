//
//  RosterVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/29.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class RosterVC: UITableViewController,NSFetchedResultsControllerDelegate{
    
    var fetchRequestVC: NSFetchedResultsController!
        
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        navigationItem.title = "好友"
        
        prepareForRoster()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "didClickAddRoster")
    
    }

    func didClickAddRoster(){
        
        navigationController?.pushViewController(RosterAddVC.controllerWithNib("RosterAddVC"), animated: true)
        
    }
    
    func prepareForRoster(){
        //显示好友数据 （保存XMPPRoster.sqlite文件）
        //1.上下文 关联XMPPRoster.sqlite文件
        let manageContext = XmppTool.sharedInstance.rosterStorage!.mainThreadManagedObjectContext
        //2.Request 请求查询哪张表
        let request = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject")
        //设置排序
        let sort = NSSortDescriptor(key: "displayName", ascending: true)
        
        request.sortDescriptors = [sort]
        
//         NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
        
        let pre = NSPredicate(format: "subscription != %@", argumentArray: ["none"])
        
        request.predicate = pre
        //3.执行请求
        //3.1创建结果控制器
        // 数据库查询，如果数据很多，会放在子线程查询
        // 移动客户端的数据库里数据不会很多，所以很多数据库的查询操作都主线程
        
        fetchRequestVC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: manageContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchRequestVC.delegate = self
        //3.2执行
        do{
        
            try fetchRequestVC!.performFetch()
            
        }catch{
            print("error=\(error)")
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchRequestVC.fetchedObjects!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "rosterCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        
        if nil == cell{
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellID)
            
        }
        
        let user = fetchRequestVC.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
        
        cell?.textLabel?.text = user.displayName
        
        switch user.sectionNum.integerValue{
            
            case 0: cell?.detailTextLabel?.text = "在线"
            case 1: cell?.detailTextLabel?.text = "离开"
            case 2: cell?.detailTextLabel?.text = "离线"
            default: break
            
        }
        
        if user.photo == nil{
            
            let imageData = XmppTool.sharedInstance.vcardAvatar?.photoDataForJID(user.jid)
            
            cell?.imageView?.image = UIImage(data: imageData!)
            
        }else{
            
            cell?.imageView?.image = user.photo
            
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            
            let roster = fetchRequestVC.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject

            XmppTool.sharedInstance.roster?.removeUser(roster.jid)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = fetchRequestVC.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let chatVC = ChatVC.controllerWithNib("ChatVC") as! ChatVC
        
        chatVC.hidesBottomBarWhenPushed = true
        
        chatVC.rosterJid = user.jid
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
