//
//  SignUpController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/7/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.rgb(r: 176, g: 191, b: 228)
        
        view.addSubview(profileImageView)
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(inputsContainerView)
        view.addSubview(RegisterButton)
        view.addSubview(alreadyHaveAccountButton)
        
        setupInputsContainerView()
        setupRegisterButton()
        setupProfileImageButton()
        
        
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

    
    }
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
        
    }()
    
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //email box
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //password box
    let passTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //registration button
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccount() {
     _ = navigationController?.popViewController(animated: true)
    }
    
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
            
            self.dismiss(animated: true, completion: nil)
            print("saved user successfully into DB")
            
            guard let tabBar = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else { return }
            
            tabBar.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
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
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
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
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        

        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(usernameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passTextField)
        
        
        //need x, y, width, height constraints
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x,y, width, height constraints
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x,y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //need x, y, width, height constraints
        passTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupRegisterButton() {
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        RegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageButton() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    


}

//extension UIColor {
//    
//    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
//        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
//        
//    }
//}
