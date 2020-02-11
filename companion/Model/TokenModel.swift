//
//  DecodableModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Token

class Token: Object, Decodable {
    
    @objc dynamic var refresh_token:  String?
    @objc dynamic var access_token:   String?
    @objc dynamic var created_at      = 0
    @objc dynamic var expires_in      = 0
}
