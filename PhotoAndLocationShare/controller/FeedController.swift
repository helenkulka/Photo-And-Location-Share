//
//  ViewController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/5/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FeedController: UITableViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //user is not logged in
        checkIfUserIsLoggedIn()
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            fetchUserAndSetupNavBarTitle()
        }
        
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        }
            , withCancel: nil)
    }
    
    @objc func handleLogout() {
        
        do {
        try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
       //let loginVC = LoginController()
       //present(loginVC, animated: true, completion: nil)
        
        
    }

   

}

