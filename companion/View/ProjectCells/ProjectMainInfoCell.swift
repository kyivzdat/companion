//
//  ProjectMainInfoCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectMainInfoCell: UITableViewCell {
    
    @IBOutlet private weak var bgView:              UIView!
    
    @IBOutlet private weak var markBGView:          UIView!
    
    @IBOutlet private weak var bigStatusImageView:  UIImageView!
    @IBOutlet private weak var statusImageView:     UIImageView!
    @IBOutlet private weak var statusLabel:         UILabel!
    
    @IBOutlet private weak var finalMarkLabel:      UILabel!
    @IBOutlet private weak var ofMarkLabel:         UILabel!
    
    @IBOutlet private weak var teamLabel:           UILabel!
    @IBOutlet private weak var correctionsLabel:    UILabel!

    @IBOutlet private weak var xpLabel:             UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 3
        markBGView.layer.cornerRadius = 3
    }
    
    func fillViews(_ projectsUsers: ProjectsUser?, _ projectInfo: [ProjectInfo.ProjectSession]?) {
        if let projectsUsers = projectsUsers {
            fillMarkView(projectsUsers)
        }
        if let projectInfo = projectInfo {
            fillGeneralView(projectInfo)
        }
    }
    
    private func fillMarkView(_ projectsUsers: ProjectsUser) {
        
        if projectsUsers.status == "finished" {
            guard let isValidated = projectsUsers.validated else { return print("bad json") }
            
            statusImageView.image = (isValidated) ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "fail")
            statusLabel.text = (isValidated) ? "success" : "fail"
            markBGView.backgroundColor = (isValidated) ? #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1) : #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
            finalMarkLabel.text = String(projectsUsers.finalMark ?? 0)
            
            bigStatusImageView.isHidden = true
        } else {
            switch projectsUsers.status {
            case "in_progress":
                fallthrough
            case "waiting_for_correction":
                fallthrough
            case "searching_a_group":
                fallthrough
            case "creating_group":
                statusImageView.isHidden = true
                statusLabel.text = "subscribed"
                bigStatusImageView.image = #imageLiteral(resourceName: "flash")
                
                markBGView.backgroundColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)
                finalMarkLabel.isHidden = true
                ofMarkLabel.isHidden = true
            default:
                break
            }
        }
    }
    
    private func fillGeneralView(_ projectInfo: [ProjectInfo.ProjectSession]) {
        
        
        guard projectInfo.isEmpty == false else { return }
        
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

