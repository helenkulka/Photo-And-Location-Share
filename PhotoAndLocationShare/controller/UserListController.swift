//
//  NewMessageController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/6/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class UserListController: UITableViewController {

    let cellid = "cellid"
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Users"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        fetchUser()
        
        
    }
    
    func fetchUser() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User(dictionary: value as! [String : Any])
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    //user.name = name
                   // user.email = email
                    
                    //if let url = value["profileImageURL"] as? String {
                   //     user.profileImageURL = url
                   // }
                    
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if user.profileImageURL != nil {
            let urlString = user.profileImageURL
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: urlString!)
        }
        else {
            cell.imageView?.image = UIImage(named: "person")
        }
        
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

    class UserCell: UITableViewCell {
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
            detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

        }
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "person")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            addSubview(profileImageView)
            
            //x,y,width,height constraints
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
}
