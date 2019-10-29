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
    var cursus_users        : [Cursus_users?]
    var id                  : Int?
    var correction_point    : Int?
    var location            : String?
    var image_url           : String?
    var campus              : [Campus?]
    
    mutating func description() {
        
        if cursus_users.count == 0 {
            let newCursus = Cursus_users(cursus_id: nil, level: nil)
            self.cursus_users.append(newCursus)
        }
        if campus.count == 0 {
            let newCampus = Campus(country: nil, city: nil, address: nil, facebook: nil, website: nil, id: nil)
            self.campus.append(newCampus)
        }
        
        print("""

            name \(first_name ?? "nil")
            surname \(last_name ?? "nil")
            login \(login ?? "nil")
            id \(id ?? -1)
            correction_point \(correction_point ?? -1)
            location \(location ?? "nil")
            image_url \(image_url ?? "nil")

            cursus_users
            level \(cursus_users[0]?.level ?? -1)
            cursus \(cursus_users[0]?.cursus_id ?? -1)
            
            campus
            country \(campus[0]?.country ?? "nil")
            city \(campus[0]?.city ?? "nil")
            address \(campus[0]!.address ?? "nil")
            facebook \(campus[0]!.facebook ?? "nil")
            website \(campus[0]!.website ?? "nil")
            id \(campus[0]!.id ?? -1)

            """)
    }
}
struct Campus: Decodable {

    var country:    String?
    var city:       String?
    var address:    String?
    var facebook:   String?
    var website:    String?
    var id:         Int?
}

struct Cursus_users: Decodable {
    
    var cursus_id: Int?
    var level: Double?
}

func clearProfile(profile: inout ProfileInfo) {

    profile.first_name          = nil
    profile.last_name           = nil
    profile.login               = nil
    profile.id                  = nil
    profile.correction_point    = nil
    profile.location            = nil
    profile.image_url           = nil
    profile.cursus_users.removeAll()
    profile.campus.removeAll()
}
