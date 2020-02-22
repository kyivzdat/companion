//
//  AchievmentCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/10/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import WebKit
import SVGKit

class AchievementCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func formatTierLable(_ tier: String?) {
        
        if let tier = tier, tier != "none" {
            
            tierLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            switch tier {
            case "easy":
                tierLabel.layer.backgroundColor = #colorLiteral(red: 0.8039215686, green: 0.4980392157, blue: 0.1960784314, alpha: 1)
            case "medium":
                tierLabel.layer.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
            case "hard":
                tierLabel.layer.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.8028198865, blue: 0.1362235177, alpha: 1)
            default:
                break
            }
            
            tierLabel.layer.cornerRadius = 3
            tierLabel.clipsToBounds = true
            let tierWithSpaces = " " + tier.capitalized + " "
            tierLabel.text = tierWithSpaces
        } else {
            tierLabel.text = nil
        }
    }
    
    func loadIconImage(image: UIImage?, imageURLString: String?, completion: @escaping (UIImage?) -> ()) {
        if let image = image {
            iconImageView.image = image
        } else if let imageURL = URL(string: "https://api.intra.42.fr" + (imageURLString ?? "")) {
            URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                guard let data = data else { return completion(nil) }
                let anSVGImage: SVGKImage = SVGKImage(data: data)
                DispatchQueue.main.async {
                    self.iconImageView.image = anSVGImage.uiImage
                    completion(anSVGImage.uiImage)
                }
            }.resume()
        }
    }
}

