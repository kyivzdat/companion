//
//  ProjectTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

fileprivate let cellIdentifiers = ["projectMainInfoCell",
                                   "projectDescriptionCell",
                                   "projectTeamCell",
                                   "projectPoolDayCell"
]

class ProjectTVC: UITableViewController {
    
    @IBOutlet weak var correctionFormButton: UIBarButtonItem!
    
    // Get from previous VC
    var inputProjectUsers:  ProjectsUser!
    var poolDays:           [ProjectsUser]!
    
    // Get from url requests
    var projectsUsers:      ProjectsUser? { // Teams
        didSet {
            
            if let numberOfTeams = projectsUsers?.teams?.count {
                
                // if description is missing we start from 1 row else from 2
                let isDescription = rangesForCell[1]!.isEmpty ? 1 : 2
                rangesForCell[2] = Array(isDescription...((numberOfTeams - 1) + isDescription))
                
                // Update poolDays
                if poolDays.count > 0 {
                    let teamsMaxRange = numberOfTeams + isDescription // bigger for 1
                    rangesForCell[3] = Array(teamsMaxRange...(teamsMaxRange + (poolDays.count - 1)))
                }
                tableView.reloadData()
            }
        }
    }
    var projectInfo:        ProjectInfo? { // MainInfoCell + Description
        didSet {
            if let projectSession = projectInfo?.projectSessions {
                for session in projectSession {
                    if let description = session.projectSessionDescription, description.isEmpty == false {
                        rangesForCell[1] = [1]
                        break
                    }
                }
            }
            let bicycle = projectsUsers
            projectsUsers = bicycle
            
            tableView.reloadData()
        }
    }
    
    var rangesForCell: [Int : [Int]] = [0: [0],
                                        1: [],
                                        2: [],
                                        3: []
    ]
    
    var dateWhenStartedRequests: TimeInterval!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = inputProjectUsers.project?.name
        
        dateWhenStartedRequests = Date().timeIntervalSince1970
        // Make URL Requests
        getProjectsUsers()
        getProjectInfo()
        
//        print("parentID -", inputProjectUsers.project?.parentID)
        if poolDays.isEmpty == false {
            navigationItem.rightBarButtonItems?.removeAll()
        }
        
        poolDays.sort(by: { ($0.id ?? 0) < ($1.id ?? 0) })
    }
    
    // MARK: - requests
    func getProjectsUsers() {
        if let userProjectID = inputProjectUsers.id {
            API.shared.getDataOfProject(projectID: userProjectID) { (newProjectsUsers) in
                DispatchQueue.main.async {
                    
                    let sortedTeams = newProjectsUsers.teams?.sorted(by: { ($0.id ?? 0) < ($1.id ?? 0) })
                    var projectsWithSortedTeams = newProjectsUsers
                    projectsWithSortedTeams.teams = sortedTeams
                    self.projectsUsers = projectsWithSortedTeams
                }
            }
        }
    }
    
    func getProjectInfo() {
        if let projectID = inputProjectUsers.project?.id {
            API.shared.getGeneralInfoOfProject(projectID: projectID) { (newProjectInfo) in
                DispatchQueue.main.async {
                    self.projectInfo = newProjectInfo
                    
                    if newProjectInfo.exam ?? true {
                        self.navigationItem.rightBarButtonItems?.removeAll()
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCorrectionForm" {
            guard let dvc = segue.destination as? CorrectionFormTVC else { return }
            
            dvc.projectID = inputProjectUsers.project?.id
            
            let currentDate = Date().timeIntervalSince1970
            if currentDate - dateWhenStartedRequests < 1 {
                
                print("Attempt to exceed the speed limit for the Segway transition")
                dvc.delay = 1
            } else {
                dvc.delay = 0
            }
        }
    }
}

extension ProjectTVC {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMaxRange()
    }
    
    func getMaxRange() -> Int {
        
        var result = 0
        rangesForCell.values.forEach { (ranges) in
            if let last = ranges.last, last > result {
                result = last
            }
        }
        return result + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var index = 0
        while index < rangesForCell.count {
            guard rangesForCell[index]?.contains(indexPath.row) == false else { break }
            index += 1
        }
        
        guard index < rangesForCell.count else {
            print("index < rangesForCell.count")
            return UITableViewCell()
        }
        
        let identifier = cellIdentifiers[index]
        
        switch index {
        case 0:
            return getMainInfoCell(cellIdentifier: identifier, indexPath)
        case 1:
            return getDescriptionCell(cellIdentifier: identifier, indexPath)
        case 2:
            return getTeamCell(cellIdentifier: identifier, indexPath)
        case 3:
            return getPoolDayCell(cellIdentifier: identifier, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - getMainInfoCell
    private func getMainInfoCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectMainInfoCell else { return UITableViewCell() }
        
        cell.fillViews(inputProjectUsers, projectInfo?.projectSessions)
        return cell
    }
    
    // MARK: - getDescriptionCell
    private func getDescriptionCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectDescriptionCell,
            let projectSession = projectInfo?.projectSessions else { return UITableViewCell() }

        cell.fillDescriptionLabel(projectSession)
        return cell
    }
    
    // MARK: - getTeamCell
    private func getTeamCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectTeamCell,
            let projectsUsers = projectsUsers,
            let minOfRange = rangesForCell[2]?.first else { return UITableViewCell() }
        
        let indexOfTeam = indexPath.row - minOfRange
        cell.fillTeamUsers(projectsUsers, indexOfTeam)
        return cell
    }
    
    // MARK: - getPoolDayCell
    private func getPoolDayCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectCell,
            let minOfRange = rangesForCell[3]?.first else { return UITableViewCell() }
        
        let indexOfTeam = indexPath.row - minOfRange
        guard indexOfTeam < poolDays.count else { return UITableViewCell() }
        
        let day = poolDays[indexOfTeam]

        cell.fillProjectInfo(day)
        
        return cell
    }
}

extension ProjectTVC {
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get cell ranges for pool Days
        guard let min = rangesForCell[3]?.first, let max = rangesForCell[3]?.last,
            min...max ~= indexPath.row else { return }
        
        print("index -", indexPath.row - min)
        let poolDay = poolDays[indexPath.row - min]
        
        guard let newVC = storyboard?.instantiateViewController(withIdentifier: "ProjectTVC") as? ProjectTVC else { return }
        newVC.inputProjectUsers = poolDay
        newVC.poolDays = []
        
        navigationController?.pushViewController(newVC, animated: true)
    }
}
