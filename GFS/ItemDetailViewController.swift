//
//  ItemDetailViewController.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDescLabel: UILabel!
    
    var itemArray: [Dictionary<String, String>]!
    var indexPath: IndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //observe notification
        let notificationName = Notification.Name("gotoDetail")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: notificationName,
                                               object: nil)
        let editNotificationName = Notification.Name("editItem")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: editNotificationName,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        //post notification
        let notificationName = Notification.Name("gotoEdit")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: ["item": itemArray, "indexPath": indexPath])
    }

    //do what while receiving notification
    func getItem(noti: Notification) {
        switch noti.name._rawValue {
        case "gotoDetail":
            itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
            indexPath = noti.userInfo!["indexPath"] as! IndexPath
            let itemDict = itemArray[indexPath.row]
            detailNameLabel.text = itemDict["name"]
            detailDescLabel.text = itemDict["desc"]
        case "editItem":
            itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
            let itemDict = itemArray[indexPath.row]
            detailNameLabel.text = itemDict["name"]
            detailDescLabel.text = itemDict["desc"]
        default:
            break
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
