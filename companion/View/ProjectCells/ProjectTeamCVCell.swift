//
//  ProjectTeamCVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectTeamCVCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var leaderImageView: UIImageView!
    
    override func awakeFromNib() {
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
//        loginLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    private func outlineLabel(string: String, font: String?, size: Int, mainColor: UIColor?, foregroundColor: UIColor?) -> NSAttributedString {
        
        let strokeColor = (foregroundColor != nil) ? foregroundColor! : UIColor.black
        let foregroundColor = (mainColor != nil) ? mainColor! : UIColor.white
        
        let font = (font == nil) ? "Arial Rounded MT Bold" : font
        
        if let font = UIFont(name: font!, size: CGFloat(size)) {
            let attrString = NSAttributedString(string: string, attributes:
                [NSAttributedString.Key.strokeColor:     strokeColor,
                 NSAttributedString.Key.foregroundColor: foregroundColor,
                 NSAttributedString.Key.strokeWidth:     -4.0,
                 NSAttributedString.Key.font:            font])
            return attrString
        }
        print("Font doesnt found -", font ?? "")
        return NSAttributedString(string: string)
    }
}
