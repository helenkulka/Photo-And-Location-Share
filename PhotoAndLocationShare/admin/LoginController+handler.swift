//
//  LoginController+handler.swift
//  gameOfChats
//
//  Created by Helen Kulka on 8/7/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//


import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        var selectedImageFromPicker: UIImage?
        profileImageView.setNeedsDisplay()
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        profileImageView.setNeedsDisplay()
        profileImageView.image = selectedImageFromPicker
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passTextField.text, let name = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = authResult?.user.uid else {
                return
            }
        
            //successfully authenticated user, storing their information in the database, uploading image file to storage
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: {
                    (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print("Error downloading image file, \(err.localizedDescription)")
                            return
                        }
                        
                        guard let url = url else { return }
                    
                        let urlString = url.absoluteString
                        let values = ["name": name, "email": email, "profileImageURL": urlString]
                        self.registerUserIntoDatabase(uid: uid, values: values)
                    })
                })
            }
        }
    }
                        
                        
                        
               
    private func registerUserIntoDatabase(uid: String, values: [String: String]) {
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://gameofchats-16ac3.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            self.messagesController?.navigationItem.title = values["name"]
            self.dismiss(animated: true, completion: nil)
            print("saved user successfully into DB")
        })
    }
    
   
}
