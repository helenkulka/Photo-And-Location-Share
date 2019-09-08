//
//  LoginController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/5/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.rgb(r: 176, g: 191, b: 228)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(dontHaveAccountButton)
        
        setupInputsContainerView()
        setupLoginButton()
        
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
      // a box for name, email, password
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
        
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(r: 80, g: 101, b: 161)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passTextField.text else {
            print("Form is not valid")
            return
    }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let tabBar = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else { return }
            
            tabBar.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
            
        })
    
    }
    
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
    

    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signupController = SignUpController()
        
        navigationController?.pushViewController(signupController, animated: true)
    }
    

    
    

      //~~~~~~~~setting up the box with the login requirements~~~~~~~~~~
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passTextField)
       
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        //need x,y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        //need x, y, width, height constraints
        passTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func setupLoginButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // making the top bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
}


