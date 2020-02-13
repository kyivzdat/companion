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
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var closedTimeLabel: UILabel!
    @IBOutlet weak var finalMarkLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var projectsUsers: ProjectsUser!
    var indexOfTeam: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillTeamUsers(_ projectsUser: ProjectsUser, _ indexOfTeam: Int) {
        
        self.projectsUsers = projectsUser
        self.indexOfTeam = indexOfTeam
        collectionView.dataSource = self
    }
}

extension ProjectTeamCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectsUsers.teams?[indexOfTeam].users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //https://cdn.intra.42.fr/users/vpelivan.jpg get image
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectTeamCVCell", for: indexPath) as? ProjectTeamCVCell, let team = projectsUsers.teams?[indexOfTeam] else { return UICollectionViewCell() }

        // image
        if let login = team.users?[indexPath.row].login, let url = URL(string: "https://cdn.intra.42.fr/users/"+login+".jpg") {
            cell.userImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil)
        }
        
        teamLabel.text = " "+(team.name ?? "")+" "

        formatingMarkLabel(team)
        closedTimeLabel.text = team.closedAt
        
        return cell
    }

    private func formatingMarkLabel(_ team: ProjectsUser.Team) {
        if projectsUsers.status == "finished" {
            guard let isValidated = projectsUsers.validated else { print("bad json"); return }
            
            finalMarkLabel.backgroundColor = (isValidated) ? #colorLiteral(red: 0.3595471382, green: 0.7224514484, blue: 0.358512938, alpha: 1) : #colorLiteral(red: 0.8473085761, green: 0.3895412087, blue: 0.4345907271, alpha: 1)
            finalMarkLabel.text = String(team.finalMark ?? 0)
        } else {
            // MARK: - TODO need to handle statuses
            switch projectsUsers.status {
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
