//
//  ViewSetup.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/25/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import UIKit

class ViewSetup {
    
    func backgroundView(_ view: UIView) {
        view.layer.cornerRadius = 3
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
    }
}
