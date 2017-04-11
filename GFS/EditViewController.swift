//
//  EditViewController.swift
//  GFS
//
//  Created by Ember on 2017/4/9.
//  Copyright © 2017年 Ember. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var indexPath: IndexPath!
    var itemArray: [Dictionary<String, String>]! // e.g. [["name":"apple","desc":"fruit"],
                                                 //       ["name":"dog","desc":"animal"],...]
    
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editDescTextField: UITextField!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editImage: UIImageView!
    
    @IBAction func editDoneButton(_ sender: UIBarButtonItem) {
        
        //error handling
        guard editNameTextField.text != "" else {
            present(alerter.alert(message: "\n Please enter name!"), animated: true, completion: nil)
            return
        }
        
        guard editDescTextField.text != "" else {
            present(alerter.alert(message: "\n Please enter description!"), animated: true, completion: nil)
            return
        }
 
        //catch data from text field
        let itemDict: Dictionary<String, String> = ["name":editNameTextField.text!,
                                                    "desc":editDescTextField.text!]
        //data edited
        itemArray[indexPath.row] = itemDict
        
        //save to file
        let path = NSHomeDirectory() + "/Documents/item.array"
        let arrayToSave = itemArray as NSArray
        arrayToSave.write(toFile: path, atomically: true)
        
        //***********************************************************************************
        //to save picture , Data type
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(editNameTextField.text!).data"
        let imageURL = URL(fileURLWithPath: imagePath) //路徑轉URL
        //data transformation to picture
        let imageToSave = UIImageJPEGRepresentation(editImage.image!, 1.0)
        do{
            try imageToSave?.write(to: imageURL)
        }catch{
            print(error.localizedDescription)
        }
        //***********************************************************************************
        
        //post notification
        let notificationName = Notification.Name("editItem")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: ["item": itemArray])
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tap on picture zone
        editView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callAlbum)))
        
        //observe the notification
        let editNotificationName = Notification.Name("gotoEdit")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getItem(noti:)),
                                               name: editNotificationName,
                                               object: nil)
    }
    
    //UIImagePickerViewController <need to be make>
    func callAlbum(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.show(imagePicker, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        editImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //do what while receiving notification
    func getItem(noti: Notification) {
        itemArray = noti.userInfo!["item"] as! [Dictionary<String, String>]
        indexPath = noti.userInfo!["indexPath"] as! IndexPath
        let itemDict = itemArray[indexPath.row]
        editNameTextField.text = itemDict["name"]
        editDescTextField.text = itemDict["desc"]
        
        //take out pictures to display
        let imagePath = NSHomeDirectory() + "/Documents/" + "\(editNameTextField.text!).data"
        let loadedImage = UIImage(contentsOfFile: imagePath)
        editImage.image = loadedImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
