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
    var cursus_users        : [CursusUsers?]
    var id                  : Int?
    var correction_point    : Int?
    var location            : String?
    var image_url           : String?
    var campus              : [Campus?]
    var wallet              : Int?
    var projects_users      : [ProjectsUsers?]
    var passedExams         : Int?
}

extension ProfileInfo {

    public func description(withSkills: Bool, withProjects: Bool) {
        print("\tfirst_name ", first_name ?? "nil")
        print("\tlast_name ", last_name ?? "nil")
        print("\tlogin ", login ?? "nil")
        print("\tid ", id ?? "nil")
        print("\tcorrection_point ", correction_point ?? "nil")
        print("\tlocation ", location ?? "nil")
        print("\timage_url ", image_url ?? "nil")
        print("\twallet ", wallet ?? "nil")
        print("\tpassedExams ", passedExams ?? "nil")
        
        print("\n\tCursus_users")
        for i in cursus_users {
            print("\t\tcursus_id ", i?.cursus_id ?? "nil")
            print("\t\tlevel ", i?.level ?? "nil")
            
            if withSkills == true {
                print("\n\t\t🍳Skills🍳")
                for j in i!.skills {
                    print("\t\t\tid ", j?.id ?? "nil")
                    print("\t\t\tlevel ", j?.level ?? "nil")
                    print("\t\t\tname ", j?.name ?? "nil")
                }
            }
        }
        
        print("\n\tCampus")
        for i in campus {
            print("\t\tcountry ", i?.country ?? "nil")
            print("\t\tcity ", i?.city ?? "nil")
            print("\t\taddress ", i?.address ?? "nil")
            print("\t\tfacebook ", i?.facebook ?? "nil")
            print("\t\twebsite ", i?.website ?? "nil")
            print("\t\tid ", i?.id ?? "nil")
        }
        
        if withProjects == true {
            print("\n\t📄Projects_users📄")
            for i in projects_users {
                print("\t\tslug ", i?.project?.slug ?? "nil")
                print("\t\tname ", i?.project?.name ?? "nil")
                print("\t\t\tparent_id ", i?.project?.parent_id ?? "nil")
                print("\t\t\tstatus ", i?.status ?? "nil")
                print("\t\t\tfinal_mark ", i?.final_mark ?? "nil")
                print("\t\t\tvalidated ", i?.validated ?? "nil")
            }
        }
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

struct CursusUsers: Decodable {
    
    var cursus_id: Int?
    var level: Double?
    var skills: [Skills?]
}

struct Skills: Decodable {
    var id: Int?
    var level: Double?
    var name: String?
    
}
