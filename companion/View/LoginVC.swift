//
//  ViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginVC: UIViewController {

    var profile: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let api = API.shared

        api.authorization {
            api.getMyInfo(completion: { (result) in
                api.getDataOfProject(id: 11)
                switch result {
                case .success(let myInfo):
                    self.profile.myInfo = myInfo
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                case .failure(let error):
                    print("Failed to fetch self info: ", error)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let tabBar = segue.destination as? UITabBarController {
            if let navi = tabBar.viewControllers?[0] as? UINavigationController {
                if let vc = navi.viewControllers[0] as? ProfileVC {
                    profile.eventInfo.append("Event")
                    vc.profile = profile
                }
            }
        }
    }
}
