//
//  SearchTVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTVCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillSearchCell(_ login: String) {
        
        if let url = URL(string: "https://cdn.intra.42.fr/users/small_"+login+".jpg") {
            photoImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "photoHolder"), options: [.transition(.fade(0.3))], progressBlock: nil)
        }
        
        loginLabel.text = login
    }
}
