//
//  UserProfileHeader.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/13/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else { return }
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
            
            nameLabel.text = user?.name
        }
    }

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let gridButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return butt
    }()
    
    let listButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(#imageLiteral(resourceName: "view-list"), for: .normal)
        butt.tintColor = UIColor(white: 0, alpha: 0.1)
        return butt
    }()
    
    let bookmarkButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        butt.tintColor = UIColor(white: 0, alpha: 0.1)
        return butt
    }()
    
    let postsLabel: UILabel = {
       let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        lbl.attributedText = attributedText
        //lbl.text = "11\nposts"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let followersLabel: UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        lbl.attributedText = attributedText
        //lbl.text = "22\nfollowers"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let followingLabel: UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        lbl.attributedText = attributedText
        //lbl.text = "14\nfollowing"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let editProfileButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setTitle("Edit Profile", for: .normal)
        butt.setTitleColor(.black, for: .normal)
        butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        butt.layer.borderColor = UIColor.lightGray.cgColor
        butt.layer.borderWidth = 1
        butt.layer.cornerRadius = 3
        return butt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)

        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
 
        //setNameAndPictureLabel()
        setupBottomToolbar()
        
        addSubview(nameLabel)
            nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right:rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setUpUserStatsView()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        

    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
       
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
    
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
    }
    
    fileprivate func setUpUserStatsView() {
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    
    
//    fileprivate func setNameAndPictureLabel() {
//        //setting up name label
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
//            guard let dictionary = DataSnapshot.value as? [String: AnyObject] else { return }
//            let username = dictionary["name"] as? String
//            self.nameLabel.text = username
//            if let url = dictionary["profileImageURL"] as? String {
//                self.profileImageView.loadImageUsingCacheWithUrlString(urlString: url)
//            }
//            else {
//                self.profileImageView.image = UIImage(named: "person")
//            }
//
//            //self.collectionView?.reloadData()
//        }
//            , withCancel: nil)
//
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
