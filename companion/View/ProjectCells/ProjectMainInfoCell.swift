//
//  ProjectMainInfoCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectMainInfoCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var markBGView: UIView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var finalMarkLabel: UILabel!
    @IBOutlet weak var ofMarkLabel: UILabel!
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var correctionsLabel: UILabel!
    @IBOutlet weak var checkersLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    
    @IBOutlet weak var bigStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 3
        markBGView.layer.cornerRadius = 3
    }
    
    func fillViews(_ projectsUsers: ProjectsUser, _ projectInfo: [ProjectInfo.ProjectSession]) {
        fillMarkView(projectsUsers)
    }
    
    private func fillMarkView(_ projectsUsers: ProjectsUser) {
        
        if projectsUsers.status == "finished" {
            guard let isValidated = projectsUsers.validated else { return print("bad json") }
            
            statusImageView.image = (isValidated) ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "fail")
            statusLabel.text = (isValidated) ? "success" : "fail"
            finalMarkLabel.text = String(projectsUsers.finalMark ?? 0)
            
            bigStatusImageView.isHidden = true
        } else {
            // MARK: - TODO need to handle statuses
            switch projectsUsers.status {
            case "in_progress":
                fallthrough
            case "searching_a_group":
                fallthrough
            case "creating_group":
                statusImageView.image = nil
                statusLabel.text = "subscribed"
                bigStatusImageView.image = #imageLiteral(resourceName: "flash")
                
                finalMarkLabel.isHidden = true
                ofMarkLabel.isHidden = true
            default:
                break
            }
        }
    }
    
    private func fillGeneralView(_ projectInfo: [ProjectInfo.ProjectSession]) {
        
        
        if projectInfo.isEmpty == false {
            var bestProjectInfo: ProjectInfo.ProjectSession?
            if let indexOf13campus = projectInfo.firstIndex(where: { $0.campusID == 13 }) {
                bestProjectInfo = projectInfo[indexOf13campus]
            } else if let indexOf8campus = projectInfo.firstIndex(where: { $0.campusID == 8 }) {
                bestProjectInfo = projectInfo[indexOf8campus]
            } else {
                bestProjectInfo = projectInfo.first
            }
            
            teamLabel.text = (bestProjectInfo?.solo ?? true) ? "Solo" : "Group"
            
            let points = (bestProjectInfo?.scales?.first)?.correctionNumber
            correctionsLabel.text = (points != nil) ? String(points!) : "-"
            
            let xp = bestProjectInfo?.difficulty
            xpLabel.text = (xp != nil) ? String(xp!) : "-"

        }
    }
}

