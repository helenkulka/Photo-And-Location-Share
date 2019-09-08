//
//  Post.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/15/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import Foundation
import MapKit

struct Post {
    let imageUrl: String
    let user: User
    let caption: String
    let locationName: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.locationName = dictionary["locationName"] as? String ?? ""
        
    }
}
