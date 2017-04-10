//
//  AddViewController.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addDescTextField: UITextField!
    
    //prepare for catch data
    var itemArray: [Dictionary<String, String>] = []

    @IBAction func addDoneButton(_ sender: UIBarButtonItem) {
        //error handling
        guard addNameTextField.text != "" else {
            present(alerter.alert(message: "\n Please enter name!"), animated: true, completion: nil)
            return
        }
        
        guard addDescTextField.text != "" else {
            present(alerter.alert(message: "\n Please enter description!"), animated: true, completion: nil)
            return
        }
        
        //catch data from text field
        let itemDict: Dictionary<String, String> = ["name":addNameTextField.text!,
                                                    "desc":addDescTextField.text!]
        //append data to the bottom of array
        itemArray.append(itemDict)
        
        //save array to file
        let path = NSHomeDirectory() + "/Documents/item.array"
        let arrayToSave = itemArray as NSArray
        arrayToSave.write(toFile: path, atomically: true)
        
        //post notification
        let notificationName = Notification.Name("addItem")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: ["item": itemArray])
      
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get notification
        let notificationName = Notification.Name("gotoAdd")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    //to get array while receiving
    func getItem(noti: Notification) {
        itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}
