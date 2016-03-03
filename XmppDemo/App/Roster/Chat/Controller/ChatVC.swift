//
//  ChatVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/3/1.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var bottomCS: NSLayoutConstraint!

    @IBOutlet weak var chatTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchResultVC: NSFetchedResultsController!
    
    var rosterJid: XMPPJID?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.registerKeyBoardNotification()
        
        chatTF.delegate = self
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        //上下文
        let context = XmppTool.sharedInstance.messageArchivingStorage?.mainThreadManagedObjectContext
        
        let request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")
        
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        
        request.sortDescriptors = [sort]
        
        let currentUserJidStr = XmppTool.sharedInstance.xmppStream?.myJID.bare()
        
        let rosterJidStr = rosterJid?.bare()
        
        let pre = NSPredicate(format: "streamBareJidStr = %@ AND bareJidStr = %@", argumentArray: [currentUserJidStr!, rosterJidStr!])
        
        request.predicate = pre
        
        fetchResultVC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultVC.delegate = self
        
        do{
        
            try fetchResultVC.performFetch()
            
        }catch{
            print(error)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let message = XMPPMessage(type: "chat", to: rosterJid)
        
        message.addBody(textField.text)
        
        XmppTool.sharedInstance.xmppStream?.sendElement(message)
        
        textField.text = nil
        
        return true
        
    }
    
    private func sendAttachment(bodyType: ChatType, content: NSData){
     
        let message = XMPPMessage(type: "chat", to: rosterJid)
        
        message.addAttributeWithName("bodyType", stringValue: bodyType.rawValue)
        
        message.addBody(bodyType.rawValue)
        //转码
//         NSString *base64Str = [data base64EncodedStringWithOptions:0];
        let base64Str = content.base64EncodedStringWithOptions(NSDataBase64EncodingOptions)
//        let decodedData = NSData(base64EncodedString: base64String!, options: .allZeros)
        
        //定义附件
        let attachment = XMPPElement(name: "attachment", stringValue: base64Str)
        
        message.addChild(attachment)
        
        XmppTool.sharedInstance.xmppStream?.sendElement(message)
    }
    
    @IBAction func didClickSendImage(sender: AnyObject) {
        
        let imagePickerVC = UIImagePickerController()
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        imagePickerVC.delegate = self
        
        presentViewController(imagePickerVC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chooseImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        let imageData = UIImagePNGRepresentation(chooseImage)

        self.sendAttachment(ChatType.Image, content: imageData!)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //注册键盘变化通知
    func registerKeyBoardNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyBoardWillShow(notifi: NSNotification){
        
        if let kBoardFrame = notifi.userInfo?["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue{
            
            bottomCS.constant = kBoardFrame.size.height
        
        }
    }
    
    func keyBoardWillHide(notifi: NSNotification){
        bottomCS.constant = 5
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchResultVC.fetchedObjects?.count
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "chatCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
            
        }
        
        let messageObj = fetchResultVC!.fetchedObjects![indexPath.row] as! XMPPMessageArchiving_Message_CoreDataObject
        
        let message = messageObj.message
        
        let bodyType = message.attributeStringValueForName("bodyType")
        
        if bodyType != nil{
            
            let childrenNotes = message.children()
            
            for note in childrenNotes{
                
                if note.name == "attachment"{
                    
                    let imageBase64Str = note.stringValue
                    
                    let imageData = NSData(base64EncodedString: imageBase64Str, options: NSDataBase64DecodingOptions())
                    
                    cell?.imageView?.image = UIImage(data: imageData!)
                    
                    cell?.textLabel?.text = nil

                }
                
            }
        }else{

            cell?.textLabel?.text = messageObj.body
            
            cell?.imageView?.image = nil
        }
        
        return cell!
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        view.endEditing(true)
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.reloadData()
        
        //表格滚动到底部
        let count = fetchResultVC.fetchedObjects?.count
        
        let lastIndex = NSIndexPath(forRow: count! - 1, inSection: 0)
        
        tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
    }

}
