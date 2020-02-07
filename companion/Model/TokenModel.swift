//
//  DecodableModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

// MARK: - Token

struct Token: Decodable {
    
    var refresh_token:  String?
    var created_at:     Int64?
    var access_token:   String?
    var expires_in:     Int64?
}
