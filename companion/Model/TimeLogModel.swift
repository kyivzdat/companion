//
//  TimeLog.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/22/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

struct TimeLog: Codable {
    var endAt: String?
    let id: Int?
    var beginAt: String?
    let host: String?

    enum CodingKeys: String, CodingKey {
        case endAt = "end_at"
        case id
        case beginAt = "begin_at"
        case host
    }
    
    var description: String {
        return  """
                id: \(id ?? -1)
                host: \(host ?? "")
                beginAt: \(beginAt ?? "")
                endAt: \(endAt ?? "")"
                """
    }
}
