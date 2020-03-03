//
//  tmp.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 3/3/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class tmp: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func tapedButton(_ sender: UIButton) {
        AlamofireAPI.shared.getToken()
    }
    
    @IBAction func timeLogTapped(_ sender: UIButton) {
        AlamofireAPI.shared.getTimeLog(ofUser: "vpalamar", pageOfRequest: 1) {_ in
            
        }
    }
}
