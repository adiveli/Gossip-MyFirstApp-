//
//  ViewController.swift
//  Gossip
//
//  Created by Adi Veliman on 21/08/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
import RSKImageCropper
import Firebase
import FirebaseDatabase
import SDWebImage
import SVProgressHUD



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController!
    
    //let userDefinition = Database.database().reference(withPath: "Definition")
    var userDefinition : DatabaseReference! = Database.database().reference(withPath: "Definition")
    //userDefinition = Database.database().reference(withPath: "Definition")
    
    
    let storageDB = Storage.storage().reference()
    
    var photoID = NSUUID().uuidString
    
    
    
    

    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        SVProgressHUD.show(withStatus: "Loading profile..")
        
        setPhotoForUser()
          
        SVProgressHUD.dismiss(withDelay: 1)
        
        
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = true;
        
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewDelegate.dequeueReusableCell(withIdentifier: <#T##String#>)
    }
*/
    
    
    func setPhotoForUser(){
        
        
        
        Database.database().reference(withPath: "Definition").observe(DataEventType.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let imageUrl = value?["image"] as? String
            let user = value?["user"] as? String
            
            
            
            
            
            //print(imageUrl)
            //print(user)
            if(Auth.auth().currentUser?.email == user){
                
                
                //print("ok")
                //controller for profil
                
               self.profileImage.sd_setImage(with: URL(string: imageUrl!))
            }
        })
        
        
    }
   

    @IBAction func changePhotoClicked(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        var cropImage = RSKImageCropViewController(image: image)
        cropImage.delegate = self
        dismiss(animated: true, completion: nil)
    
        present(cropImage, animated: true, completion: nil)

    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource {
    
    
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
     self.myImage.image = croppedImage
     self.navigationController?.popViewController(animated: true)
     }*/
    
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profileImage.image = croppedImage
        dismiss(animated: true, completion: nil)
        
        let userEmail = Auth.auth().currentUser?.email as! String
        
        
        
        
        //save photo
        let data = UIImageJPEGRepresentation(croppedImage, 0.5)
        let photoLibrary = storageDB.child("userPhotos")
        
        photoLibrary.child("\(userEmail)").putData(data!, metadata: nil) { (metadata, error) in
            if(error != nil){
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                
                //self.userDefinition = Database.database().reference(withPath: "Definition")
                let imageUrl = metadata?.downloadURL()?.absoluteString
                
                let instance = ["image" : imageUrl!,"user" : Auth.auth().currentUser?.email, "uuid" : self.photoID] as [String : Any]
                
                self.userDefinition.child("\(userEmail.makeFirebaseString())").setValue(instance)
                
                
            }
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /*func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
     
     
     
     }*/
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let maskSize : CGSize
        if(controller.isPortraitInterfaceOrientation()){
            
            maskSize = CGSize(width: 250, height: 250)
            
        }else{
            maskSize = CGSize(width: 220, height: 220)
            
        }
        
        
        var viewWidth : CGFloat = controller.view.frame.width
        var viewHeight : CGFloat = controller.view.frame.height
        
        var maskRect : CGRect = CGRect(x: viewWidth-maskSize.width, y: viewHeight-maskSize.height, width: maskSize.width, height: maskSize.height)
        
        return maskRect
        
        
    }
    
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        var rect : CGRect = controller.maskRect
        var point1 : CGPoint = CGPoint(x: rect.minX, y: rect.minY)
        var point2 : CGPoint = CGPoint(x: rect.minX, y: rect.minX)
        var point3 : CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        var triangle = UIBezierPath()
        triangle.move(to: point1)
        triangle.addLine(to: point2)
        triangle.addLine(to: point3)
        triangle.close()
        
        
        
        
        return triangle
    }
    
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    
    
}


extension String {
    func makeFirebaseString()->String{
        let arrCharacterToReplace = [".","#","$","[","]"]
        var finalString = self
        
        for character in arrCharacterToReplace{
            finalString = finalString.replacingOccurrences(of: character, with: "-")
        }
        
        return finalString
    }
}



