//
//  postCell.swift
//  Gossip
//
//  Created by Adi Veliman on 02/09/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase

class postCell: UITableViewCell {

    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var earImage: UIImageView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var numberApprovesDisapprovesLabel: UILabel!
    
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    
    var approveContor : Bool = false
    var rejectContor : Bool = false
    
    
    var approved : Bool = false
    var rejected : Bool = false
    
    var keyArray = [String]()
    var receivedIndex = Int()
    
    var posts : DatabaseReference! = Database.database().reference(withPath: "Posts")
    
    var preferrences : DatabaseReference! = Database.database().reference(withPath: "Preferrences")
    
    
    let userEmail = Auth.auth().currentUser?.email as! String
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        postImage.layer.cornerRadius = 8.0
        postImage.clipsToBounds = true
        postText.isEditable = false
        
        labelComment.layer.borderColor = UIColor(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        labelComment.layer.borderWidth = 1.0
        labelComment.layer.cornerRadius = 5.0
        
        
        
        
        
        
        
        
        
    }
    
    func sendArray(array : [String], index : Int){
        
        keyArray = array
        receivedIndex = index
        
        
    }
    
    func likesDislikes(){
        
        
        let instance = ["approve" : approved, "reject" : rejected, "comment" : "comment", "user" : userEmail, "key" : keyArray[receivedIndex]] as [String : Any]
        
        
        
        preferrences.child("\(keyArray[receivedIndex])").child("\(userEmail.makeFirebaseString())").setValue(instance)
        
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func approveClicked(_ sender: Any) {
        
        
        approveContor = !approveContor
        //likesDislikes()
        if(approveContor == false){
            approved = false
            approveButton.setImage(#imageLiteral(resourceName: "approveIcon"), for: UIControlState.normal)
        }else{
            approved = true
            rejected = false
            approveButton.setImage(#imageLiteral(resourceName: "approveIconGreen"), for: UIControlState.normal)
            rejectButton.setImage(#imageLiteral(resourceName: "RejectIcon"), for: UIControlState.normal)
        }
        
        likesDislikes()
        
        
        
    }
    
    @IBAction func rejectClicked(_ sender: Any) {
        rejectContor = !rejectContor
        //likesDislikes()
        if(rejectContor == false){
            rejected = false
            rejectButton.setImage(#imageLiteral(resourceName: "RejectIcon"), for: UIControlState.normal)
        }else{
            rejected = true
            approved = false
            rejectButton.setImage(#imageLiteral(resourceName: "RejectIconRed"), for: UIControlState.normal)
            approveButton.setImage(#imageLiteral(resourceName: "approveIcon"), for: UIControlState.normal)
        }
        
        likesDislikes()
    }
    
    
    
    
    

}


extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
