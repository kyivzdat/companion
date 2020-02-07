//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

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
    
    // MARK: - Passed Data from Login VC
    var userData: UserData!
    
    // MARK: - view Did load
    override func viewDidLoad() {
        super.viewDidLoad()

        //Image
//        #colorLiteral(red: 0.003921568627, green: 0.7294117647, blue: 0.737254902, alpha: 1)
        fullName.text = userData.displayname
        login.text = userData.login
        correctionPoints.text = "Correction points: " + String(userData.correctionPoint ?? 0)
        wallet.text = "Wallet " + String(userData.wallet ?? 0) + "₳"
        if let poolMonth = userData.poolMonth, let poolYear = userData.poolYear {
            yearOfpool.text = poolMonth + ", " + poolYear
        }
        isAvailableLabel.text = userData.location
        
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
//            let notPassedImage =    UIImage(named: "notPassedExam")
            
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
        
        if let indexOfFirstInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 120 }),
            self.userData.projectsUsers?[indexOfFirstInternShip].validated == true {
            
            self.internshipImageViews.first?.image = UIImage(named: "internshipPassed")
        }
        
        if let indexOfFinalInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 1650 }),
            self.userData.projectsUsers?[indexOfFinalInternShip].validated == true {
            
            self.internshipImageViews[1].image = UIImage(named: "internshipPassed")
        }
        
        if let indexOfFinalInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 212 }),
            self.userData.projectsUsers?[indexOfFinalInternShip].validated == true {
            
            self.internshipImageViews.last?.image = UIImage(named: "internshipPassed")
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
}
