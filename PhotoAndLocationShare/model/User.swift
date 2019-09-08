//
//  User.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/6/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit

struct User {
    var name: String?
    var email: String?
    var profileImageURL: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.profileImageURL = dictionary["profileImageURL"] as? String
        
    }
}
