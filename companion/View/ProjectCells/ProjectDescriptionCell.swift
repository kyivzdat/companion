//
//  ProjectDescriptionCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectDescriptionCell: UITableViewCell {
    
    @IBOutlet private weak var bgView: UIView!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 3
    }
    
    func fillDescription(_ description: String) {
        descriptionLabel.text = description
    }
}
