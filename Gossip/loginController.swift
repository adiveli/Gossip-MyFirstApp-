//
//  loginController.swift
//  Gossip
//
//  Created by Adi Veliman on 24/08/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backGround.png")!)
        
        let hideKB = UITapGestureRecognizer(target: self, action: #selector(loginController.hideKeyboard))
        view.addGestureRecognizer(hideKB)
        
        usernameText.text = "adi@ymail.com"
        passwordText.text = "mirinda10"

        
    }
    
    
    func hideKeyboard(){
        
        view.endEditing(true)
        
    }

    @IBAction func logInClicked(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { (user, error) in
            if(error != nil){
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                self.performSegue(withIdentifier: "toFeed", sender: nil)
                
            }
        }
        
    }
    
    
    
    
    @IBAction func registerCliked(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: usernameText.text!, password: passwordText.text!) { (user, error) in
            if(error != nil){
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                self.performSegue(withIdentifier: "toFeed", sender: nil)
                
            }
        }
        
        
    }
    
}
