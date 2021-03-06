//
//  Internship+exams+levelView.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/25/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class Internship_Exams_LevelView: UIView {

    @IBOutlet var bgView: UIView!
    
    @IBOutlet private var internshipImageViews:     Array<UIImageView>!
    @IBOutlet private var examsImageViews:          Array<UIImageView>!
    @IBOutlet private weak var levelLabel:          UILabel!
    @IBOutlet private weak var levelProgressView:   UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Internship+Exams+Level", owner: self, options: nil)
        bgView.frame = self.bounds
        addSubview(bgView)
        bgView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        bgView.layer.cornerRadius = 3
        bgView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 1
        bgView.layer.shadowOpacity = 0.1
    }
    
    // MARK: fillLevelProgressView
    func fillLevelProgressView(_ userData: UserData) {
        levelProgressView.layer.cornerRadius = 1
        levelProgressView.transform = .identity
        levelProgressView.transform = levelProgressView.transform.scaledBy(x: 1, y: 14)
        levelProgressView.clipsToBounds = true
        levelProgressView.tintColor = #colorLiteral(red: 0.002772599459, green: 0.7285055518, blue: 0.7355008125, alpha: 1)

        var progressResult: Float = 0
        if let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == 1 }),
            let level = userData.cursusUsers?[indexOfCursus].level {

            let progress = Float(Double(level) - Double(Int(level)))
            levelLabel.text = "level "+String(Int(level))+" - "+String(Int((progress * 100).rounded()))+"%"

            progressResult = progress
        } else {
            levelLabel.text = "level 0 - 0%"
            progressResult = 0
        }

        self.levelProgressView.setProgress(progressResult, animated: false)
    }
    
    // MARK: managedExamsImages
    func fillExamsImages(_ userData: UserData) {
        guard let indexOfExams = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 11 }),
            let exams = userData.projectsUsers?[indexOfExams] else { return }
        
        let passedExamImage = #imageLiteral(resourceName: "passedExam")
        
        if exams.validated == true {
            examsImageViews.forEach { (examViewImage) in
                examViewImage.image = passedExamImage
            }
        } else {
            var counter = 0
            exams.teams?.forEach({ (team) in
                if team.validated == true {
                    examsImageViews[counter].image = passedExamImage
                    counter += 1
                }
            })
        }
    }
    
    // MARK: checkForPassedInternships
    func fillPassedInternships(_ userData: UserData) {

        for imageID in 0..<internshipImageViews.count {
            let idOfInternshipsProject = [120, 1650, 212] // First Internship, PartTime-I, Final Intership
            
            if let indexOfFinalInternShip = userData.projectsUsers?.firstIndex(where: { $0.project?.id == idOfInternshipsProject[imageID] }),
                userData.projectsUsers?[indexOfFinalInternShip].validated == true {

                self.internshipImageViews[imageID].image = #imageLiteral(resourceName: "internshipPassed")
            }
        }
    }
}
