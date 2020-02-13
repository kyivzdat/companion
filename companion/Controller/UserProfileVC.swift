//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileVC: UITableViewController {
    
    // MARK: - Outlets
    // Main info outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var yearOfpool: UILabel!
    
    // Location outlet
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    // Internship exams outlets
    @IBOutlet var internshipImageViews: Array<UIImageView>!
    @IBOutlet var examsImageViews: Array<UIImageView>!
    
    // Level outlet
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    
    // All bg views
    @IBOutlet var bgViews: Array<UIView>!
    
    // Passed Data from Login VC
    var userData: UserData!
    
    // MARK: - view Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Image
        if let urlImage = URL(string: userData.imageURL ?? "") {
            photoImageView.kf.indicatorType = .activity
            //            photoImageView.kf.setImage(with: urlImage)
            photoImageView.kf.setImage(with: urlImage,
                                       placeholder: UIImage(named: "photoHolder"),
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil)
        }
        
        //        #colorLiteral(red: 0.003921568627, green: 0.7294117647, blue: 0.737254902, alpha: 1)
        fullName.text = userData.displayname
        login.text = userData.login
        correctionPoints.text = String(userData.correctionPoint ?? 0)
        wallet.text = String(userData.wallet ?? 0) + " ₳"
        if let poolMonth = userData.poolMonth, let poolYear = userData.poolYear {
            yearOfpool.text = poolMonth + ", " + poolYear
        }
        isAvailableLabel.text = userData.location ?? "Unavailable"
        
        // Level
        if let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == 1 }),
            let level = userData.cursusUsers?[indexOfCursus].level {
            levelLabel.text = String(level)
            let progress = Float(Double(level) - Double(Int(level)))
            levelProgressView.progress = progress
        }
        
        // Exams
        if let indexOfExams = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 11 }),
            let exams = self.userData.projectsUsers?[indexOfExams] {
            
            let passedImage =       UIImage(named: "passedExam")
            
            if exams.validated == true {
                examsImageViews.forEach { (examViewImage) in
                    examViewImage.image = passedImage
                }
            } else {
                var counter = 0
                exams.teams?.forEach({ (team) in
                    if team.validated == true {
                        examsImageViews[counter].image = passedImage
                        counter += 1
                    }
                })
            }
        }
        
        // Internships
        
        for imageID in 0..<internshipImageViews.count {
            let idOfInternshipsProject = [120, 1650, 212] // First Internship, PartTime-I, Final Intership
            checkForPassedInternships(projectID: idOfInternshipsProject[imageID], imageID: imageID)
        }
        
        
        bgViews.forEach { (view) in
            view.layer.cornerRadius = 3
            view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
            view.layer.shadowRadius = 1
            view.layer.shadowOpacity = 0.1
        }
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func checkForPassedInternships(projectID: Int, imageID: Int) {
        
        if let indexOfFinalInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == projectID }),
            self.userData.projectsUsers?[indexOfFinalInternShip].validated == true {
            
            self.internshipImageViews[imageID].image = UIImage(named: "internshipPassed")
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToProjectSkillAchTVC" {
            
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            
            guard let dvc = segue.destination as? Projects_Skills_AchievementsTVC,
                let tuple = sender as? (data: [Any], type: AllowedTypes) else { return print("Error. UserProfileVC. Prepare error casting") }
            
            dvc.array = tuple.data
            dvc.getTypeOfData = tuple.type
        }
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseID = 1
        
        var dataToPass: [Any] = []
        
        if indexPath.section == 1 {
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            var typeOfData: AllowedTypes!
            switch indexPath.row {
            case 0:
                print("Select projects")
                dataToPass = prepareProjects(courseID)
                typeOfData = .projects
            case 1:
                print("Select skills")
                dataToPass = prepareSkills(courseID)
                typeOfData = .skills
            case 2:
                print("Select achievements")
                dataToPass = prepareAchievements(courseID)
                typeOfData = .achievements
            default:
                return
            }
            performSegue(withIdentifier: "segueToProjectSkillAchTVC", sender: (dataToPass, typeOfData))
        }
    }
    
    /**
     - course ID
     - 4 - Piscine C  (pool)
     - 1 - school 42
     */
    func prepareProjects(_ courseID: Int) -> [ProjectsUser] {
        guard let projects = userData.projectsUsers else { return [] }
        var resultArray: [ProjectsUser] = []
        projects.forEach { (project) in
            // if project in school 42 and it's not pool
            if let ids = project.cursusIDS?.first, ids == courseID {
                resultArray.append(project)
            }
        }
        resultArray.sort(by: { ($0.currentTeamID ?? 0) > ($1.currentTeamID ?? 0) })
        return resultArray
    }
    
    func prepareSkills(_ courseID: Int) -> [Skill] {
        
        guard let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == courseID }),
            let skills = userData.cursusUsers?[indexOfCursus].skills else { return [] }
        return skills
    }
    
    func prepareAchievements(_ courseID: Int) -> [Achievement] {
        
        var resultArray: [Achievement] = []
        guard let achievements = userData.achievements else { return [] }
        
        for i in 0..<(achievements.count - 1) {
            if achievements[i].name != achievements[i + 1].name {
                resultArray.append(achievements[i])
            }
        }
        if resultArray.last?.name != achievements.last?.name, let lastElem = achievements.last {
            resultArray.append(lastElem)
        }
        return resultArray
    }
}
