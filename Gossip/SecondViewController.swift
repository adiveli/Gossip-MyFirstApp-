//
//  SecondViewController.swift
//  Gossip
//
//  Created by Adi Veliman on 21/08/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class SecondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    
    //database definition for posts
    var userDefinition : DatabaseReference! = Database.database().reference(withPath: "Posts")
    let storageDB = Storage.storage().reference(withPath: "PostPhotos")
    
    //-----------------------------------
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var earButton: UIButton!
    @IBOutlet weak var uploadImageTrue: UIImageView!

    @IBOutlet weak var gossipText: UITextView!
    
    //------------------------------------
    
    var earContor : Bool = false
    var eyeContor : Bool = false
    
    
    //-------------------------------------
    
    var postPhotoID = NSUUID().uuidString
    var timeToSave : Timer!
    
    
    
    
    
    @IBAction func addPhotoClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image : UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        uploadImageTrue.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        resetUploadLayout() //size,delimitation,color,shape textView
        
        let hideKB = UITapGestureRecognizer(target: self, action: #selector(loginController.hideKeyboard))
        view.addGestureRecognizer(hideKB)
        resetUploadLayout()
    
    }
    
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if gossipText.textColor == UIColor.lightGray {
            gossipText.text = nil
            gossipText.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if gossipText.text.isEmpty {
            gossipText.text = "Don't hesitate!"
            gossipText.textColor = UIColor.lightGray
        }
    }
    
    
    func hideKeyboard(){
        
        view.endEditing(true)
        
    }
    
    func textViewOptions(){
        
        gossipText.clipsToBounds = true
        gossipText.layer.cornerRadius = 10
        gossipText.delegate = self
        
        gossipText.text = "Don't hesitate!"
        gossipText.textColor = UIColor.lightGray
        gossipText.textAlignment = .center
        
    }
    
    
    @IBAction func tellButtonClicked(_ sender: Any) {
        
        let data = UIImageJPEGRepresentation(uploadImageTrue.image!, 0.5)
        
        
        storageDB.child("\(postPhotoID)").putData(data!, metadata: nil) { (metadata, error) in
            if(error != nil){
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                
                let imageUrl = metadata?.downloadURL()?.absoluteString
                
                let instance = ["image" : imageUrl!,"user" : Auth.auth().currentUser?.email! as Any, "uuid" : self.postPhotoID, "message" : self.gossipText.text, "eye" : self.eyeContor , "ear" : self.earContor] as [String : Any]
                
                self.userDefinition.childByAutoId().setValue(instance)
                
                
                
            }
        }

        self.tabBarController?.selectedIndex = 0
        //hardCode
        timeToSave = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(resetUploadLayout), userInfo: nil, repeats: true)
        //textViewOptions()
        //self.uploadImageTrue.image = nil
        //self.earContor = false
        //earButton.setImage(#imageLiteral(resourceName: "earIcon"), for: UIControlState.normal)
        //self.eyeContor = false
        //eyeButton.setImage(#imageLiteral(resourceName: "eyeIcon"), for: UIControlState.normal)
        self.tabBarController?.selectedIndex = 0
        //if(Timer.)
        
    
    }
    
    @IBAction func earClicked(_ sender: Any) {
        
        earContor = !earContor
        if(earContor == false)
        {
            earButton.setImage(#imageLiteral(resourceName: "earIcon"), for: UIControlState.normal)
        }else{
            earButton.setImage(#imageLiteral(resourceName: "earIconColor"), for: UIControlState.normal)
        }
        //earContor = !earContor
        
    }
    
    @IBAction func eyeClicked(_ sender: Any) {
        
        eyeContor = !eyeContor
        if(eyeContor == false)
        {
            eyeButton.setImage(#imageLiteral(resourceName: "eyeIcon"), for: UIControlState.normal)
            
        }else{
            eyeButton.setImage(#imageLiteral(resourceName: "eyeIconColor"), for: UIControlState.normal)
        }
        //eyeContor = !eyeContor
        
    }
    
    func resetUploadLayout(){
        
        textViewOptions()
        self.uploadImageTrue.image = nil
        self.earContor = false
        earButton.setImage(#imageLiteral(resourceName: "earIcon"), for: UIControlState.normal)
        self.eyeContor = false
        eyeButton.setImage(#imageLiteral(resourceName: "eyeIcon"), for: UIControlState.normal)
        
    }
    
    
    
    
    
    
    
    
    
}






