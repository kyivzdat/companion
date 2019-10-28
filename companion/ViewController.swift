//
//  ViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AuthenticationServices

var myInfo : ProfileInfo?

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let apiInfo = API()


        apiInfo.authorization()
        

    

    }
    
    
}

