//
//  ProjectTeamCVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectTeamCVCell: UICollectionViewCell {
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var leaderImageView: UIImageView!
    
    override func awakeFromNib() {
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        loginLabel.text = ""
    }
    
    func fillUserCVCell(_ user: ProjectsUser.Team.UserElement) {
        
        //https://cdn.intra.42.fr/users/vpelivan.jpg get image
        // image
        if let login = user.login, let url = URL(string: "https://cdn.intra.42.fr/users/"+login+".jpg") {
            
            userImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil)
            
            loginLabel.text = login
        }
        leaderImageView.image = (user.leader ?? false) ? #imageLiteral(resourceName: "star") : nil
    }
}
