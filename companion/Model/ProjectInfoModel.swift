//
//  ProjectInfoModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

// MARK: - ProjectInfo
struct ProjectInfo: Decodable {
    let id: Int?
    let name, slug: String?
    let parent: Parent?
    let children: [Child]?
    let createdAt, updatedAt: String?
    let exam: Bool?
    let recommendation: String?
    let projectSessions: [ProjectSession]?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, parent, children
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case exam
        case recommendation
        case projectSessions = "project_sessions"
    }
    
    // Parent
    struct Parent: Decodable {
        let id: Int?
        let createdAt, name, slug: String?
        let url: String?

        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case name, slug, url
        }
    }

    // Child
    struct Child: Decodable {
        let name: String?
        let id: Int?
        let slug: String?
        let url: String?
        let createdAt: String?

        enum CodingKeys: String, CodingKey {
            case name, id, slug, url
            case createdAt = "created_at"
        }
    }
    
    // ProjectSession
    struct ProjectSession: Decodable {
        let id: Int?
        let solo: Bool?
        let beginAt, endAt: String?
        let estimateTime: Int?
        let difficulty: Int?
        let objectives: [String]?
        let projectSessionDescription: String?
        let terminatingAfter: Int?
        let projectID: Int?
        let campusID, cursusID: Int?
        let createdAt, updatedAt: String?
        let isSubscriptable: Bool?
        let scales: [Scale]?
        let uploads: [Upload]?
        let teamBehaviour: String?

        enum CodingKeys: String, CodingKey {
            case id, solo
            case beginAt = "begin_at"
            case endAt = "end_at"
            case estimateTime = "estimate_time"
            case difficulty, objectives
            case projectSessionDescription = "description"
            case terminatingAfter = "terminating_after"
            case projectID = "project_id"
            case campusID = "campus_id"
            case cursusID = "cursus_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case isSubscriptable = "is_subscriptable"
            case scales, uploads
            case teamBehaviour = "team_behaviour"
        }
        // Scale
        struct Scale: Decodable {
            let id, correctionNumber: Int?
            let isPrimary: Bool?

            enum CodingKeys: String, CodingKey {
                case id
                case correctionNumber = "correction_number"
                case isPrimary = "is_primary"
            }
        }

        // Upload
        struct Upload: Decodable {
            let id: Int?
            let name: String?
        }
    }
}
