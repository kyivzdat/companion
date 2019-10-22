//
//  SelfModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/21/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class SelfModel: NSObject {

    let name                : String
    let surname             : String
    let login               : String
    let level               : String
    let cursus              : Int
    let campus              : Int
    let id                  : Int
    let correctionPoints    : Int
    let location            : String
    let photo               : UIImage?
    
    override var description: String {

        return """
            login: \(login)
            name: \(name)
            surname: \(surname)
            level: \(level)
            cursus: \(cursus)
            campus: \(campus)
            id: \(id)
            correction points: \(correctionPoints)
            location: \(location)
        """
    }
    
    init(json : NSDictionary) {
        
        name                = json["first_name"] as! String
        surname             = json["last_name"] as! String
        login               = json["login"] as! String
        level               = String(describing: ((json["cursus_users"] as! NSArray)[0] as! NSDictionary)["level"] as! NSNumber)
        cursus              = ((json["cursus_users"] as! NSArray)[0] as! NSDictionary)["cursus_id"] as! Int
        campus              = ((json["campus_users"] as! NSArray)[0] as! NSDictionary)["campus_id"] as! Int
        id                  = json["id"] as! Int
        correctionPoints    = json["correction_point"] as! Int
        location            = json["location"] as! String
        
        let urlPhoto = URL(string: String(describing: json["image_url"]))
        let data = try? Data(contentsOf: urlPhoto!)
        if let data = data {
            photo = UIImage(data: data)
        } else {
            photo = UIImage(named: "no_photo")
        }
        
        
    }
}
