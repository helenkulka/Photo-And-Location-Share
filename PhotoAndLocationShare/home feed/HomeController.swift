//
//  HomeController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/15/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellid = "cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellid)
        
        setupNavigationItems()
        
        fetchPosts()

    }
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
   Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
    
        guard let userDictionary = snapshot.value as? [String: Any] else { return }
    
        let user = User(dictionary: userDictionary)
       
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else {
                    return
                }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
                
                
            })
            
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    })
    }
    
    
    
    func setupNavigationItems() {
        navigationItem.title = "Home"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 56 //40 + 8 + 8
        height += view.frame.width
        height += 50 //bottom row of buttons
        height += 60 //caption text
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
}
