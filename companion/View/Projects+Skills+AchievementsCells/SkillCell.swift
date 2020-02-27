//
//  SkillCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 11/19/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class SkillCell: UITableViewCell {

    @IBOutlet private weak var skillLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillSkill(_ skill: Skill) {
        
        skillLabel.text = skill.name
        
        if let level = skill.level {
            valueLabel.text = String(level)
            progressView.progress = level / 21
        }
    }
}
