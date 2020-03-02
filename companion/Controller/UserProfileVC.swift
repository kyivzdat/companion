//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Kingfisher
import MBCircularProgressBar

class UserProfileVC: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var mainInfoView: MainInfoView!
    
    @IBOutlet private weak var isAvailableLabel: UILabel!
    
    @IBOutlet private weak var internExamsLevelView: Internship_Exams_LevelView!
    
    @IBOutlet private weak var timeSpeedometerView: TimeSpeedometerView!
    
    // All bg views
    @IBOutlet private var bgViews: Array<UIView>!
    
    // Passed Data from Login VC
    var userData: UserData!
    var titleText: String!
    
    private var pullToRefresh: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }
    
    var timerSinceLastRefresh = Date().timeIntervalSince1970
    
    // MARK: - view Did load
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.visibleViewController?.title = titleText

        setupSearchController()
        viewSetup()
        
        fillViewWithInfo()
        
        // TimeLog has fetching one time, cause server has spam rate limit
        timeSpeedometerView.fillSpeedometer(userData)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let prevStyle = previousTraitCollection else { return }
        let isDarkMode = prevStyle.userInterfaceStyle == .dark ? true : false

        timeSpeedometerView.setSpeedometerFontColor(isDarkMode: !isDarkMode)
    }
    
    private func fillViewWithInfo() {
        
        mainInfoView.fillMainInfo(userData)
        isAvailableLabel.text = userData.location ?? "Unavailable"
        
        internExamsLevelView.fillPassedInternships(userData)
        internExamsLevelView.fillExamsImages(userData)
        internExamsLevelView.fillLevelProgressView(userData)
    }
    
    // MARK: setupSearchController
    private func setupSearchController() {
        guard let searchTVC = storyboard?.instantiateViewController(withIdentifier: "SearchTVC") as? SearchTVC else { return }
        
        searchTVC.parentTVC = self
        
        let searchController = UISearchController(searchResultsController: searchTVC)
        
        searchController.searchBar.placeholder = "Search a user"
        searchController.searchResultsUpdater = searchTVC
        searchController.searchBar.delegate = searchTVC
        
        navigationItem.searchController = searchController
    }
    
    // MARK: viewSetup
    private func viewSetup() {
        bgViews.forEach { (view) in
            view.layer.cornerRadius = 3
            view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 1
            view.layer.shadowOpacity = 0.1
        }
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.refreshControl = pullToRefresh
    }
    
    // MARK: - refresh
    @objc func refresh(_ sender: UIRefreshControl) {
        
        guard let login = userData.login else {
            sender.endRefreshing()
            showErrorAlert()
            return
        }
        
        var delay = 0
        let currentTime = Date().timeIntervalSince1970
        if  currentTime - timerSinceLastRefresh < 2 {
            delay = 500
        }
        print(currentTime - timerSinceLastRefresh)
        timerSinceLastRefresh = currentTime
        print("delay =", delay)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .milliseconds(delay)) {
            API.shared.getProfileInfo(userLogin: login) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        self.userData = userData
                        self.fillViewWithInfo()
                    case .failure(let error):
                        self.showErrorAlert()
                        print("Failed to fetch self info: ", error)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    sender.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - showErrorAlert
    private func showErrorAlert() {
        
        let ac = UIAlertController(title: "Something went wrong",
                                   message: "Please try again",
                                   preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToProjectSkillAchTVC" {
            
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            
            guard let dvc = segue.destination as? Projects_Skills_AchievementsTVC,
                let tuple = sender as? (data: [Any], type: AllowedTypes) else { return print("Error. UserProfileVC. Prepare error casting") }
            
            dvc.array = tuple.data
            dvc.getTypeOfData = tuple.type
        } else if segue.identifier == "segueToMonthsVC" {
            guard let dvc = segue.destination as? MonthsVC else { return }
            dvc.login = userData.login
        }
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseID = 1
        
        var dataToPass: [Any] = []
        
        if indexPath.section == 0 && indexPath.row == 3 {
            performSegue(withIdentifier: "segueToMonthsVC", sender: nil)
        } else if indexPath.section == 1 {
            typealias AllowedTypes = Projects_Skills_AchievementsTVC.TypeOfData
            var typeOfData: AllowedTypes!
            switch indexPath.row {
            case 0:
                dataToPass = prepareProjects(courseID)
                typeOfData = .projects
            case 1:
                dataToPass = prepareSkills(courseID)
                typeOfData = .skills
            case 2:
                dataToPass = prepareAchievements(courseID)
                typeOfData = .achievements
            default:
                return
            }
            performSegue(withIdentifier: "segueToProjectSkillAchTVC", sender: (dataToPass, typeOfData))
        }
    }
    
    // MARK: - prepareProjects
    /**
     - course ID:
         - 4 - Piscine C  (pool)
         - 1 - school 42
     */
    private func prepareProjects(_ courseID: Int) -> [ProjectsUser] {
        guard let projects = userData.projectsUsers else { return [] }
        var resultArray: [ProjectsUser] = []
        projects.forEach { (project) in
            // if project in school 42 and it's not pool
            if let ids = project.cursusIDS?.first, ids == courseID && project.project?.name != "Rushes" {
                resultArray.append(project)
            }
        }
        resultArray.sort(by: { ($0.currentTeamID ?? 0) > ($1.currentTeamID ?? 0) })
        return resultArray
    }
    
    // MARK: - prepareSkills
    private func prepareSkills(_ courseID: Int) -> [Skill] {
        
        guard let indexOfCursus = userData.cursusUsers?.firstIndex(where: { $0.cursusID == courseID }),
            let skills = userData.cursusUsers?[indexOfCursus].skills else { return [] }
        return skills
    }
    
    // MARK: - prepareAchievements
    private func prepareAchievements(_ courseID: Int) -> [Achievement] {
        
        var resultArray: [Achievement] = []
        guard let achievements = userData.achievements else { return [] }
        
        if achievements.isEmpty {
            return []
        }
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
