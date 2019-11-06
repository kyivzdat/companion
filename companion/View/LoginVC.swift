//
//  ViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AuthenticationServices

var myInfo      : ProfileInfo?
var profileInfo : ProfileInfo?

class LoginVC: UIViewController {

    var profile: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let api = API.shared
        
        api.authorization {
            api.getMyInfo(completion: { (profileInfo) in
                self.profile.personInfo = profileInfo
                self.performSegue(withIdentifier: "MainSegue", sender: nil)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let navi = segue.destination as? UINavigationController {
            if let profileVC = navi.viewControllers[0] as? ProfileVC {
                profile.eventInfo.append("Event")
                profileVC.profile = profile
            }
        }
    }
}
