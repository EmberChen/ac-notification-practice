//
//  ItemListTableViewController.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit

class ItemListTableViewController: UITableViewController {

    let path = NSHomeDirectory() + "/Documents/item.array"
    var itemArray:[Dictionary<String, String>] = []

        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempArray = NSArray(contentsOfFile: path) {
            itemArray = tempArray as! Array
        }
        
        let editNotificationName = Notification.Name("editItem")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: editNotificationName,
                                               object: nil)
        let addNotificationName = Notification.Name("addItem")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: addNotificationName,
                                               object: nil)

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let notificationName = Notification.Name("gotoDetail")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["item" : itemArray, "indexPath" : indexPath])
        } else {
            let notificationName = Notification.Name("gotoAdd")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["item" : itemArray])
        }
    }
    
    func getItem(noti: Notification) {
        switch noti.name._rawValue {
        case "editItem":
            itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
            tableView.reloadData()
        case "addItem":
            itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
            let insertIndexPath = IndexPath(row: itemArray.count - 1, section: 0)
            tableView.insertRows(at: [insertIndexPath], with: .right)
        default:
            break
        }
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemDict = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemDict["name"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "刪除") {
            (action, indexPath) in
            self.itemArray.remove(at: indexPath.row)
            let arrayToSave = self.itemArray as NSArray
            arrayToSave.write(toFile: self.path, atomically: true)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [deleteAction]

    }
    

}
