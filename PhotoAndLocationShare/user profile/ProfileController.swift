//
//  ProfileController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/7/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //var user: User?
    let cellid = "cellid"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid")
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellid)

        setupLogoutButton()
        
        fetchOrderedPosts()
    }
    
    var posts = [Post]()
    
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch ordered posts")
        }
    }

    
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))

    }
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginVC = LoginController()
                let navVC = UINavigationController(rootViewController: loginVC)
                self.present(navVC, animated: true, completion: nil)
            } catch let logoutError {
                print(logoutError)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! UserProfilePhotoCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 ) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerid", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.name
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
 
}

