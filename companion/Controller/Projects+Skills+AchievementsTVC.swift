//
//  Projects+Skills+AchievementsTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/10/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

class Projects_Skills_AchievementsTVC: UIViewController {
    
    enum TypeOfData: String {
        case projects
        case skills
        case achievements
    }
    
    var array: [Any]!
    var getTypeOfData: TypeOfData!
    var iconsArray: [UIImage?] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Projects_Skills_AchievementsTVC")
        print("TypeOfData -", getTypeOfData.rawValue)
        
        iconsArray = Array<UIImage?>(repeating: nil, count: array.count)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension Projects_Skills_AchievementsTVC: UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch getTypeOfData {
        case .projects:
            return getProjectCell(indexPath)
        case .skills:
            return getSkillCell(indexPath)
        case .achievements:
            return getAchievmentCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: getProjectCell
    func getProjectCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectCell,
            let project = array[indexPath.row] as? ProjectsUser else { return UITableViewCell() }
        
        cell.projectLabel.text = project.project?.name
        
//        if let mark = array[indexPath.row].finalMark {
//            cell.markLabel.text = String(mark)
//        } else if let status = array[indexPath.row].status {
//            cell.markLabel.text = status
//        }
        cell.formatingMarkLabel(mark: project.finalMark, isValidated: project.validated, status: project.status)
    
        return cell
    }
    
    // MARK: getSkillCell
    func getSkillCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillCell,
            let skill = array[indexPath.row] as? Skill else { return UITableViewCell() }
        
        cell.skillLabel.text = skill.name
        if let level = skill.level {
            cell.valueLabel.text = String(level)
            cell.progressView.progress = level / 21
        }
        return cell
    }
    
    // MARK: getAchievmentCell
    func getAchievmentCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as? AchievementCell,
            let achievement = array[indexPath.row] as? Achievement else { return UITableViewCell() }
        
        cell.loadIconImage(image: iconsArray[indexPath.row], imageURLString: achievement.image) { newImage in
            self.iconsArray[indexPath.row] = newImage
        }
        cell.titleLabel.text = achievement.name
        cell.formatTierLable(achievement.tier)
        cell.descriptionLabel.text = achievement.achievementDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch getTypeOfData {
        case .projects:
            return 50
        case .skills:
            return 55
        case .achievements:
            return 80
        default:
            return 0
        }
    }
}

extension Projects_Skills_AchievementsTVC: UITableViewDelegate {
    
}
