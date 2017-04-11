//
//  AddViewController.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit

class AddViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addDescTextField: UITextField!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addView: UIView!
    
    
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
        
        //***********************************************************************************
        //to save picture , Data type
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(addNameTextField.text!).data"
        let imageURL = URL(fileURLWithPath: imagePath) //路徑轉URL
        //data transformation to picture
        let imageToSave = UIImageJPEGRepresentation(addImage.image!, 1.0)
        do{
            try imageToSave?.write(to: imageURL)
        }catch{
            print(error.localizedDescription)
        }
        //***********************************************************************************
        
        //post notification
        let notificationName = Notification.Name("addItem")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: ["item": itemArray])
      
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func callAlbum(){
        let imagePicker = UIImagePickerController()
    
        //UIImagePickerControllerDelegate,UINavigationControllerDelegate
        imagePicker.delegate = self
    
        self.show(imagePicker, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        addImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callAlbum)))
        
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
