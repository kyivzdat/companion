//
//  projectUsersStructAPI.swift
//  companion
//
//  Created by kyivzdat on 11/16/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

struct ProjectsUsers: Decodable {
    var status: String?
    var project: Project?
    var final_mark: Int?
    var validated: Int?
}

struct Project: Decodable {
    var name: String?
    var parent_id: Int?
    var slug: String?
}
