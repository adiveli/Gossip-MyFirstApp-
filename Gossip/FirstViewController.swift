//
//  FirstViewController.swift
//  Gossip
//
//  Created by Adi Veliman on 21/08/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentChanger: UISegmentedControl!
    
  
    
    //POJO Preferrences table ----------------------------------------------------------------
     class useriPreferrencesObject {
        
        var approve = Bool()
        var disapprove = Bool()
        var user = String()
        var comment = String()
        var key = String()
        
        
        
        func initialize(approveP : Bool, disapproveP : Bool, userP: String, commentP : String, keyP : String){
            
            self.approve = approveP
            self.disapprove = disapproveP
            self.user = userP
            self.comment = commentP
            self.key = keyP
            
        }
        
        
        func getApprove() ->Bool{
            return self.approve
        }
        
        func getDisapprove() ->Bool{
            return self.disapprove
        }
        
        func getUser() -> String{
            return self.user
        }
        
        func getComment() -> String{
            return self.comment
        }
        
        func getKey() -> String{
            return self.key
        }
        
        
        func show(){
            
            
            print("approve: \(self.approve)--- comment: \(self.comment) ---- key \(self.key)----reject \(self.disapprove)--- user: \(self.user)")
        }
        
        
        
        
        
    }
    
    
    //----------------------------------------------
    
    
    //----------------------------------------------
    var posts : DatabaseReference! = Database.database().reference(withPath: "Posts")
    var preferrences : DatabaseReference! = Database.database().reference(withPath: "Preferrences")
    
    
    //arrays for data on Firebase
    //-----------------------------------------------
    
    var imageUrls = [String]()
    var userArray = [String]()
    var earArray = [Bool]()
    var eyeArray = [Bool]()
    var textViewsArray = [String]()
    var uuidArray = [String]()
    var keyArray = [String]()
    
    
    //------------------------------------------------
    
    var userPreferrences = [useriPreferrencesObject]()

    //array for keeping track of number of accepts and rejects
    var likeDictionary = NSMutableDictionary()
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.reloadData()
        
        let hideKB = UITapGestureRecognizer(target: self, action: #selector(loginController.hideKeyboard))
        view.addGestureRecognizer(hideKB)
        

        getPreferrencesFromServer()
        getDataFromServer()
        
        
        
        
        
        
        
        
        
        
        tableView.reloadData()
        
        
    }
    
    func hideKeyboard(){
        
        view.endEditing(true)
        
    }
    
    
    func getLikesDislikesNumber(){
        
        
        for keyPost in keyArray{
            var numberApprovals = Int()
            var numberRejects = Int()
            for keyPreferrence in userPreferrences{
                if(keyPost == keyPreferrence.key){
                    if(keyPreferrence.approve == true){
                        numberApprovals += 1
                        
                    }else if(keyPreferrence.disapprove == true){
                        numberRejects += 1
                    }
                    
                    
                }
                
            likeDictionary["\(keyPost)"] = [numberApprovals,numberRejects]
            }
    
            
        }
        
        
    
    }
  
 
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return userArray.count + 1
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var celula : UITableViewCell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
            // Set up cell.label
            cell.layer.backgroundColor = UIColor.clear.cgColor
            //return cell
            celula = cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! postCell
            // Set up cell.button
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.postImage.sd_setShowActivityIndicatorView(true)
            cell.postImage.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            cell.postImage.sd_setImage(with: URL(string: self.imageUrls[indexPath.row - 1]))
            
            
            cell.labelComment.text = textViewsArray[indexPath.row - 1]
            if(earArray[indexPath.row - 1] == false){
                cell.earImage.image = #imageLiteral(resourceName: "earIcon")
            }else{
                cell.earImage.image = #imageLiteral(resourceName: "earIconColor")
            }
            if(eyeArray[indexPath.row - 1] == false){
                cell.eyeImage.image = #imageLiteral(resourceName: "eyeIcon")
            }else{
                cell.eyeImage.image = #imageLiteral(resourceName: "eyeIconColor")
            }
            cell.usernameLabel.text = userArray[indexPath.row - 1]
            
            cell.sendArray(array: keyArray, index: (indexPath.row - 1))
            
            getLikesDislikesNumber()
            
            var sir = likeDictionary.value(forKey: "\(keyArray[indexPath.row - 1])") as! [Int]
            
            
            cell.numberApprovesDisapprovesLabel.text = "\(sir[0]) approvals ---- \(sir[1]) rejections"
            
            
            
            
            
            
            
            //cell.usernameLabel.text = "\(indexPath.row)"
            
            //return cell
            celula = cell
        }
        
        return celula
        
    }
    
    
    
    
    func salut(index : Int){
        print("salut\(index)")
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 170
        }
        else {
            height = 370
        }
        
        return height
    }
    
    //load posts from firebase Database
    
    func getDataFromServer(){
        
        
        posts.observe(DataEventType.childAdded, with: { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            
        
                self.userArray.append(values["user"] as! String)
                self.imageUrls.append(values["image"] as! String)
                self.eyeArray.append(values["eye"] as! Bool)
                self.earArray.append(values["ear"] as! Bool)
                self.textViewsArray.append(values["message"] as! String)
                self.uuidArray.append(values["uuid"] as! String)
            self.keyArray.append(snapshot.key)
            //print("\(snapshot.key)")
            //}
            
            self.tableView.reloadData()
            
            
            
            
            
        })
        
        
        
        
        
    }
    
    
    func getPreferrencesFromServer(){
        
        
        preferrences.observe(DataEventType.childAdded, with: { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            
            //var obiect = useriPreferrencesObject()
            
            let valuesChildren = values.allKeys
            
            

            for entry in valuesChildren{
                let singleEntry = values[entry] as! NSDictionary
                
                var obiect = useriPreferrencesObject()
                
                //print(singleEntry["reject"] as! Bool)
                obiect.initialize(approveP: singleEntry["approve"] as! Bool, disapproveP: singleEntry["reject"] as! Bool, userP: singleEntry["user"] as! String, commentP: singleEntry["comment"] as! String , keyP: singleEntry["key"] as! String)
                
                self.userPreferrences.append(obiect)
            
            }
            
            
            
        
            
            
            self.tableView.reloadData()
            
           
            
            
        })
        
        
        
    }
    




    
        
    
    

    @IBAction func contentChangerClicked(_ sender: Any)
    {
        
        
        //self.getLikesDislikesNumber()
        
        print(likeDictionary)
        
    }
    


}

