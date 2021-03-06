//
//  ProjectCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 11/19/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet private weak var projectLabel: UILabel!
    @IBOutlet private weak var markLabel: UILabel!
    
    func fillProjectInfo(_ project: ProjectsUser) {
        
        projectLabel.text = project.project?.name
        
        let mark = project.finalMark
        let isValidated = project.validated
        let status = project.status
        
        if mark == nil && isValidated == nil && status == nil {
            
            print("Error. ProjectCell. formatingMarkLabel()")
            return
        }
        
        markLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        markLabel.layer.cornerRadius = 3
        markLabel.clipsToBounds = true
        
        if let isValidated = isValidated, isValidated {
            markLabel.text = " " + String(mark ?? 0) + " "
            markLabel.layer.backgroundColor = #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1)
            projectLabel.textColor = #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1)
        } else {
            switch status {
            case "finished":
                markLabel.layer.backgroundColor = #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
                projectLabel.textColor = #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
                markLabel.text = " " + String(mark ?? 0) + " "
            case "in_progress":
                fallthrough
            case "waiting_for_correction":
                fallthrough
            case "searching_a_group":
                fallthrough
            case "creating_group":
                markLabel.layer.backgroundColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)
                projectLabel.textColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)
                
                markLabel.text = " " + (status ?? "").replacingOccurrences(of: "_", with: " ").capitalized + " "
            default:
                break
            }
        }
    }
    
    func addSeparator() {
        let separatorView = UIView.init(frame: CGRect(x: 15, y: frame.size.height - 1, width: frame.size.width - 15, height: 1))
        separatorView.backgroundColor = .darkGray
        contentView.addSubview(separatorView)
    }
}
