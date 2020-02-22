//
//  TimeLog.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/22/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

struct TimeLog: Decodable {
    let endAt: String?
    let id: Int?
    let beginAt: String?
    let host: String?

    enum CodingKeys: String, CodingKey {
        case endAt = "end_at"
        case id
        case beginAt = "begin_at"
        case host
    }
}
