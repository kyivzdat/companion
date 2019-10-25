//
//  profileInfoStruct.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

struct ProfileInfo: Decodable {
    
    var first_name          : String?
    var last_name           : String?
    var login               : String?
    var lvl                 : String?
    var cursusNotDecod      : Int?
    var campusNotDecod      : Int?
    var id                  : Int?
    var correction_point    : Int?
    var location            : String?
    var image_url           : String?
    var campus              : [Campus?]
    
    func description() {
        print("""
            name \(first_name ?? "nil")
            surname \(last_name ?? "nil")
            login \(login ?? "nil")
            level \(lvl ?? "nil")
            cursus \(cursusNotDecod ?? -1)
            campus\(campusNotDecod ?? -1)
            id \(id ?? -1)
            correction_point \(correction_point ?? -1)
            location \(location ?? "nil")
            image_url \(image_url ?? "nil")
            campus \(campus)
            """)
    }
}

struct Campus: Decodable {
    var address: String?
    var city:   String?
}
