//
//  TabBarControllerViewController.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/6/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    //stops from launching the plus view controller, allows us launch custom pho selector 
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        //show if user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        tabBar.tintColor = .black
        
        setupViewControllers()
        
        
    }
    
    func setupViewControllers() {
        
        //home controller
        let homeNavController = templateNavController(#imageLiteral(resourceName: "home2"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
       
        
        //map controller
        let mapNavController = templateNavController(#imageLiteral(resourceName: "map"), rootViewController: MapController())
        
        //search controller
        let searchNavController = templateNavController(#imageLiteral(resourceName: "view-list"), rootViewController: UserListController())
        
        //new photo
        let plusNavController = templateNavController(#imageLiteral(resourceName: "pluz"))
        
        
        
        
        //user profile controller
        let layout = UICollectionViewFlowLayout()
        let userProfileController = ProfileController(collectionViewLayout: layout)
        let userNavController = UINavigationController(rootViewController: userProfileController)
        userNavController.tabBarItem.image = UIImage(named: "person")
        
    
        viewControllers = [homeNavController, mapNavController, plusNavController, searchNavController, userNavController]
        
        //modify tab bar item insets to make icon centered
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    fileprivate func templateNavController(_ tabImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let NavController = UINavigationController(rootViewController: viewController)
        NavController.tabBarItem.image = tabImage
        return NavController
    }

}

