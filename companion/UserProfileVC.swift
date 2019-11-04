//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 11/2/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {

    var profile: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        profile = userLogin
        
        if profile != nil {
            API.shared.getProfile(user: profile!)
//            apiInfo.getProfile(user: profile!)
            profileInfo?.description()
        }
    }
}
