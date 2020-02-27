//
//  newModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/6/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - arrayOfTitlesOfSkills
let arrayOfTitlesOfSkills = [
"Adaptation\n& creativity",
"Algorithms\n& AI",
"Company\nexperience",
"DB\n& Data",
"Functional\nprogramming",
"Graphics",
"Group &\ninterpersonal",
"Imperative\nprogramming",
"Network\n& system\nadministration",
"Object-oriented\nprogramming",
"Organization",
"Parallel\ncomputing",
"Rigor",
"Security",
"Technology\nintegration",
"Unix",
"Web"]

// for searchUsers
struct UserPreview: Decodable {
    let id: Int?
    let lastName, login, firstName, displayname: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case displayname
        case firstName = "first_name"
        case id
        case imageURL = "image_url"
        case lastName = "last_name"
        case login
    }
}

// MARK: - UserData
struct UserData: Decodable {
    let achievements: [Achievement]?
    let campus: [Campus]?
    let campusUsers: [CampusUser]?
    let correctionPoint: Int?
    let cursusUsers: [CursusUser]?
    let displayname, email: String?
    let firstName: String?
    let id: Int?
    let imageURL: String?
    let languagesUsers: [LanguagesUser]?
    let lastName, location, login: String?
    let patroned: [Patroned]?
    let phone, poolMonth: String?
    let poolYear: String?
    var projectsUsers: [ProjectsUser]?
    let staff: Bool?
    let url: String?
    let wallet: Int?

    enum CodingKeys: String, CodingKey {
        case achievements, campus
        case campusUsers = "campus_users"
        case correctionPoint = "correction_point"
        case cursusUsers = "cursus_users"
        case displayname, email
        case firstName = "first_name"
        case id
        case imageURL = "image_url"
        case languagesUsers = "languages_users"
        case lastName = "last_name"
        case location, login, patroned, phone
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case projectsUsers = "projects_users"
        case staff = "staff?"
        case url, wallet
    }
}

// MARK: - Achievement(UserData)
struct Achievement: Decodable {
    let achievementDescription: String?
    let id: Int?
    let image, kind, name: String?
    let nbrOfSuccess: Int?
    let tier: String?
    let usersURL: String?
    let visible: Bool?

    enum CodingKeys: String, CodingKey {
        case achievementDescription = "description"
        case id, image, kind, name
        case nbrOfSuccess = "nbr_of_success"
        case tier
        case usersURL = "users_url"
        case visible
    }
}

// MARK: - Campus(UserData)
struct Campus: Decodable {
    let address, city, country: String?
    let facebook: String?
    let id: Int?
    let language: Language?
    let name, timeZone, twitter: String?
    let usersCount, vogsphereID: Int?
    let website: String?
    let zip: String?

    enum CodingKeys: String, CodingKey {
        case address, city, country, facebook, id, language, name
        case timeZone = "time_zone"
        case twitter
        case usersCount = "users_count"
        case vogsphereID = "vogsphere_id"
        case website, zip
    }
}

// MARK: - Language (Campus(UserData))
struct Language: Decodable {
    let createdAt: String?
    let id: Int?
    let identifier, name, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, identifier, name
        case updatedAt = "updated_at"
    }
}

// MARK: - CampusUser
struct CampusUser: Decodable {
    let campusID, id, userID: Int?
    let isPrimary: Bool?

    enum CodingKeys: String, CodingKey {
        case campusID = "campus_id"
        case id
        case isPrimary = "is_primary"
        case userID = "user_id"
    }
}

// MARK: - CursusUser
struct CursusUser: Decodable {
    let beginAt, blackholedAt: String?
    let cursus: Cursus?
    let cursusID: Int?
    let endAt, grade: String?
    let hasCoalition: Bool?
    let id: Int?
    
    let level: Float?
    let skills: [Skill]?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case beginAt = "begin_at"
        case blackholedAt = "blackholed_at"
        case cursus
        case cursusID = "cursus_id"
        case endAt = "end_at"
        case grade
        case hasCoalition = "has_coalition"
        case id, level, skills, user
    }
}

// MARK: - Cursus
struct Cursus: Decodable {
    let createdAt: String?
    let id: Int?
    let name, slug: String?
    let parentID: Int?
    enum CodingKeys: String, CodingKey {

case createdAt = "created_at"
        case id, name, slug
        case parentID = "parent_id"
    }
}

// MARK: - Skill
struct Skill: Decodable {
    let id: Int?
    let level: Float?
    let name: String?
}

// MARK: - User
struct User: Decodable {
    let id: Int?
    let login: String?
    let url: String?
}

// MARK: - LanguagesUser
struct LanguagesUser: Decodable {
    let createdAt: String?
    let id, languageID, position, userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case languageID = "language_id"
        case position
        case userID = "user_id"
    }
}

// MARK: - Patroned
struct Patroned: Decodable {
    let createdAt: String?
    let godfatherID, id: Int?
    let ongoing: Bool?
    let updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case godfatherID = "godfather_id"
        case id, ongoing
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

// MARK: - ProjectsUser
struct ProjectsUser: Decodable {
    let currentTeamID: Int?
    let cursusIDS: [Int]?
    let finalMark: Int?
    let id: Int?
    let marked: Bool?
    let markedAt: String?
    let occurrence: Int?
    let project: Cursus?
    let retriableAt, status: String?
    let validated: Bool?
    var teams: [Team]?

    enum CodingKeys: String, CodingKey {
        case currentTeamID = "current_team_id"
        case cursusIDS = "cursus_ids"
        case finalMark = "final_mark"
        case id
        case marked
        case markedAt = "marked_at"
        case occurrence, project
        case retriableAt = "retriable_at"
        case status
        case validated = "validated?"
        case teams
    }
    
    struct Team: Decodable {
        let id: Int?
        let name: String?
        let url: String?
        let finalMark, projectID: Int?
        let createdAt, updatedAt, status: String?
        let users: [UserElement]?
        let locked, validated, closed: Bool?
        let repoUUID, lockedAt, closedAt: String?
        let projectSessionID: Int?

        enum CodingKeys: String, CodingKey {
            case id, name, url
            case finalMark = "final_mark"
            case projectID = "project_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case status
            case users
            case locked = "locked?"
            case validated = "validated?"
            case closed = "closed?"
            case repoUUID = "repo_uuid"
            case lockedAt = "locked_at"
            case closedAt = "closed_at"
            case projectSessionID = "project_session_id"
        }
        
        struct UserElement: Decodable {
            let id: Int?
            let login: String?
            let url: String?
            let leader: Bool?
            let occurrence: Int?
            let validated: Bool?
            let projectsUserID: Int?

            enum CodingKeys: String, CodingKey {
                case id, login, url, leader, occurrence, validated
                case projectsUserID = "projects_user_id"
            }
        }
    }
}
