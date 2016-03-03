//
//  ProfileEditVC.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/29.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

class ProfileEditVC: UIViewController {
    
    var saveValueClosure: ((newValue: String)->Void)!
    
    var editCell: UITableViewCell?{
        
        didSet{
            
            navigationItem.title = editCell?.textLabel?.text
            
        }
        
    }
    
    @IBOutlet weak var editTF: UITextField!
    
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "didClickSave")
        
        editTF.text = editCell!.detailTextLabel!.text

    }
    
    func didClickSave(){
        
        navigationController?.popViewControllerAnimated(true)
        
        saveValueClosure(newValue: editTF.text!)
        
    }
}
