//
//  UIViewController+Extension.swift
//  XmppDemo
//
//  Created by 魏翔 on 16/2/25.
//  Copyright © 2016年 魏翔. All rights reserved.
//

import UIKit

import Foundation

extension UIViewController{
    
    class func controllerWithNib(nibName: String)->UIViewController{
        
        let vc = self.init(nibName: nibName, bundle: nil)
        
        return vc
        
    }
    
}
