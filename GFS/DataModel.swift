//
//  DataModel.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit


class alerter{
    static func alert(title: String = "Error !", message: String) -> UIAlertController {
        let nowAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        nowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return nowAlert
    }
}
