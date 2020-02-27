//
//  ProjectTeamCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher

class ProjectTeamCell: UITableViewCell {
    
    @IBOutlet private weak var bgView:          UIView!
    
    @IBOutlet private weak var teamLabel:       UILabel!
    @IBOutlet private weak var closedTimeLabel: UILabel!
    @IBOutlet private weak var finalMarkLabel:  UILabel!
    
    @IBOutlet private weak var collectionView:  UICollectionView!
    
    private var projectsUsers:  ProjectsUser!
    private var team:           ProjectsUser.Team?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 3
        finalMarkLabel.layer.cornerRadius = 3
        finalMarkLabel.clipsToBounds = true
    }
    
    // MARK: - fillTeamUsers
    func fillTeamUsers(_ projectsUser: ProjectsUser, _ indexOfTeam: Int) {
        
        self.team = projectsUser.teams?[indexOfTeam]
        self.projectsUsers = projectsUser
        
        if let team = self.team {
            teamLabel.text = team.name
            
            formatingMarkLabel(team)
            formatingDate(team)
        }

        collectionView.dataSource = self
    }
    
    private func formatingDate(_ team: ProjectsUser.Team) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy HH:mm"
        
        let time = team.closedAt?.split(separator: ".").first
        if let date = dateFormatterGet.date(from: String(time ?? "")) {
            closedTimeLabel.text = dateFormatterPrint.string(from: date)
        } else {
            closedTimeLabel.text = "-"
        }
    }
    
    // MARK: - formatingMarkLabel
    private func formatingMarkLabel(_ team: ProjectsUser.Team) {
        if team.status == "finished" {
            guard let isValidated = team.validated else { print("bad json"); return }
            
            finalMarkLabel.backgroundColor = (isValidated) ? #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1) : #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
            finalMarkLabel.text = " "+String(team.finalMark ?? 0)+" "
        } else {
            // MARK: - TODO need to handle statuses
            switch team.status {
            case "in_progress":
                fallthrough
            case "searching_a_group":
                fallthrough
            case "creating_group":
                finalMarkLabel.backgroundColor = UIColor.clear
                finalMarkLabel.text = "-"
            default:
                break
            }
        }
    }
}

extension ProjectTeamCell: UICollectionViewDataSource {
    
    // MARK: - ColectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return team?.users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectTeamCVCell", for: indexPath) as? ProjectTeamCVCell,
            let user = team?.users?[indexPath.row] else { return UICollectionViewCell() }

        cell.fillUserCVCell(user)
        return cell
    }
}
