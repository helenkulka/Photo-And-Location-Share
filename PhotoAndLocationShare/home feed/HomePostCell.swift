//
//  HomePostCell.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/16/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImageUsingCacheWithUrlString(urlString: postImageUrl)
        
            usernameLabel.text = post?.user.name
            locationButton.setTitle(post?.locationName, for: .normal)
            
            guard let profileImageUrl = post?.user.profileImageURL else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.name!, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    
    }
    

    
    let userProfileImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal),for: .normal)
        return button
    }()
    
    let commentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let locationButton: UIButton = {
         let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
         return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(optionsButton)
        addSubview(usernameLabel)
        addSubview(locationButton)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //making photo image a square to give room for caption & buttons
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        locationButton.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 44, height: 0)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likesButton, commentsButton])

        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
