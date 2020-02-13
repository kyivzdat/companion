//
//  ProjectDescriptionCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 3
    }
    
    func fillDescriptionLabel(_ projectInfo: [ProjectInfo.ProjectSession]) {
        if projectInfo.isEmpty == false {
            var bestProjectInfo: ProjectInfo.ProjectSession?
            if let indexOf13campus = projectInfo.firstIndex(where: { $0.campusID == 13 }) {
                bestProjectInfo = projectInfo[indexOf13campus]
            } else if let indexOf8campus = projectInfo.firstIndex(where: { $0.campusID == 8 }) {
                bestProjectInfo = projectInfo[indexOf8campus]
            } else {
                bestProjectInfo = projectInfo.first
            }
            
            descriptionLabel.text = bestProjectInfo?.projectSessionDescription
        }
    }
    
}
