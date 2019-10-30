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
var apiInfo = API()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func loginButton(_ sender: UIButton) {

        apiInfo.authorization()
    }
    
    @IBAction func getUsers(_ sender: UIButton) {
        
        guard let url = NSURL(string: apiInfo.apiURL+"v2/users?range[login]=vp,vpz&sort=login") else {
            MyProfileVC().alert(title: "Error", message: "Wrong url")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + apiInfo.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil, let data = data else { MyProfileVC().alert(title: "Error", message: "Wrong url"); return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            print(json ?? "nil")
            
            }.resume()
    }
    
}
