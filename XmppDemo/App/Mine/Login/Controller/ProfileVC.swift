//
//  ProfileVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/27.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
    @IBOutlet weak var avartarCell: UITableViewCell!
    
    @IBOutlet weak var accountCell: UITableViewCell!
 
    @IBOutlet weak var organizationCell: UITableViewCell!
    
    @IBOutlet weak var departmentCell: UITableViewCell!
    
    @IBOutlet weak var positionCell: UITableViewCell!
    
    @IBOutlet weak var phoneCell: UITableViewCell!
    
    @IBOutlet weak var mailCell: UITableViewCell!
    
    @IBOutlet weak var nickNameCell: UITableViewCell!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        navigationItem.title = "个人信息"
        
        let cardModel = XmppTool.sharedInstance.vCardModule?.myvCardTemp
        
        nickNameCell.textLabel?.text = "昵称"
        
        nickNameCell.detailTextLabel?.text = cardModel!.nickname
        
        accountCell.textLabel?.text = "账号"
        
        accountCell.detailTextLabel?.text = AppTool.sharedInstance.userModel!.userName
        
        organizationCell.textLabel?.text = "公司"
        
        organizationCell.detailTextLabel?.text = cardModel!.orgName
        
        if cardModel!.photo != nil{
            
            avartarCell.textLabel?.text = "头像"
            
            avartarCell.imageView?.frame = CGRectMake(0, 0, 60, 60)
            
            avartarCell.imageView?.image = UIImage(data: cardModel!.photo)
            
        }
        
        if cardModel!.orgUnits.count > 0{
            
            departmentCell.textLabel?.text = "部门"
            
            departmentCell.detailTextLabel?.text = cardModel?.orgUnits[0] as? String
            
        }
        
        positionCell.textLabel?.text = "职位"
        
        positionCell.detailTextLabel?.text = cardModel!.title
        
        
        phoneCell.textLabel?.text = "电话"
        
        phoneCell.detailTextLabel?.text = cardModel!.note
        
        mailCell.textLabel?.text = "邮箱"
        
        mailCell.detailTextLabel?.text = cardModel?.mailer

    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        switch cell!.tag{
            case 0:cell?.textLabel
            
                let vc = ProfileEditVC.controllerWithNib("ProfileEditVC") as! ProfileEditVC
                vc.editCell = cell
                vc.saveValueClosure = {[unowned self] newValue in
                    
                    cell?.detailTextLabel?.text = newValue
                    
                    self.saveEditValue()
                
                }
                navigationController?.pushViewController(vc, animated: true)
            case 2: chooseAvatarImage()
            default: break
        }
        
    }
    
    func chooseAvatarImage(){
        
        let actionSheet = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "照相", otherButtonTitles:"图片库")
        
        actionSheet.showInView(view)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        switch buttonIndex{
            case 0: imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            case 1: break
            case 2:
                imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
                self.presentViewController(imagePicker, animated: true, completion: nil)
            default: break
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //获取修改后的图片
        let editImg = info[UIImagePickerControllerEditedImage] as! UIImage
        avartarCell.imageView?.frame = CGRectMake(0, 0, 60, 60)
        //更改cell里的图片
        avartarCell.imageView?.image = editImg
        
        //移除图片选择的控制器
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //把新的图片保存到服务器
        self.saveEditValue()
        
    }
    
    
    func saveEditValue(){
        
        let cardTemp = XmppTool.sharedInstance.vCardModule?.myvCardTemp

        if let editImage = avartarCell.imageView?.image{
        
            cardTemp?.photo = UIImageJPEGRepresentation(editImage, 0.75)
        
        }
        
        cardTemp!.nickname = nickNameCell.detailTextLabel?.text
        
        cardTemp!.orgName = organizationCell.detailTextLabel?.text
        
        if let departmentValue = departmentCell.detailTextLabel?.text{
            
            cardTemp!.orgUnits = [departmentValue]
            
        }
        
        cardTemp!.title = phoneCell.detailTextLabel?.text
        
        cardTemp!.note = phoneCell.detailTextLabel?.text
        
        cardTemp!.mailer = mailCell.detailTextLabel?.text
        
        XmppTool.sharedInstance.vCardModule?.updateMyvCardTemp(cardTemp)
        
    }
    
}
