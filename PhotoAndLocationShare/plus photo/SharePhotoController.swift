//
//  SharePhotoController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/15/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SharePhotoController: UIViewController, UISearchBarDelegate, LocationSearchControllerDelegate {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    
    var locationName: String = ""
    var locationCoordinates: CLLocationCoordinate2D? = nil
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
       
        setupContainerViews()
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func searchControllerFindName(Name: String) {
        self.locationName = Name
        locationPicked.text = self.locationName
        
    }
    
    func searchControllerFindLocation(Location: CLLocationCoordinate2D) {
        self.locationCoordinates = Location
    }
    
   
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    let locationPicked: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    @objc func handleSearch() {
       let locationSearchVC = LocationSearchController()
        locationSearchVC.delegate = self
        navigationController?.pushViewController(locationSearchVC, animated: true)
    
    }
    
    fileprivate func setupContainerViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
     
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        
        containerView.addSubview(searchButton)
        searchButton.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width:20, height: 20)
        
        
        containerView.addSubview(locationPicked)
        locationPicked.anchor(top: containerView.topAnchor, left: searchButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        
 
        containerView.addSubview(imageView)
        imageView.anchor(top: searchButton.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        
        containerView.addSubview(textView)
        textView.anchor(top: searchButton.bottomAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func handleShare() {
        if textView.text.characters.count == 0 {
            textView.text = " "
        }
        
        guard let image = selectedImage else { return }
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image: ", err)
                return
            }
            
            print("Successfully uploaded post image: ")
            
            Storage.storage().reference().child("posts").child(filename).downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error downloading image file, \(err.localizedDescription)")
                    return
                }
                
                guard let url = url else { return }
                let urlString = url.absoluteString
                
                self.saveToDatabaseWithImageUrl(urlString)
                
            })
            
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(_ imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let location = locationPicked.text else { return }
        guard let locationLatitude = self.locationCoordinates?.latitude else { return }
        guard let locationLongitude = self.locationCoordinates?.longitude else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970, "locationName": location, "locationLatitude": locationLatitude, "locationLongitude": locationLongitude] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to save post to DB!!! SAD", err)
                return
            }
            
            print("SUCCess")
            self.dismiss(animated: true, completion: nil)
        }
    }
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


