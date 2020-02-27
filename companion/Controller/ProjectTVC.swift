//
//  ProjectTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/12/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProjectTVC: UITableViewController {
    
    private let cellIdentifiers = [
        "projectMainInfoCell",
        "projectDescriptionCell",
        "projectTeamCell",
        "projectPoolDayCell"
    ]
    
    @IBOutlet private weak var correctionFormButton: UIBarButtonItem!
    
    // Get from previous VC
    var inputProjectUsers:  ProjectsUser!
    var poolDays:           [ProjectsUser]!
    
    // Get from url requests
    //MARK: - projectUsers - Teams
    private var projectsUsers:      ProjectsUser? {
        didSet {
            
            if let numberOfTeams = projectsUsers?.teams?.count, numberOfTeams > 0 {
                
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
    
    //MARK: - projectUsers - MainInfoCell+Description
    private var projectInfo:        ProjectInfo? {
        didSet {
            if let projectSession = projectInfo?.projectSessions {
                
                let bestDescription = defineBestDescription(projectSession)
                
                if let description = bestDescription, description.isEmpty == false {
                    rangesForCell[1] = [1]
                    self.descriptionText = description
                }
            }
            
            let ductTape = projectsUsers
            projectsUsers = ductTape
            
            tableView.reloadData()
        }
    }
    
    private var rangesForCell: [Int : [Int]] = [
        0: [0],
        1: [],
        2: [],
        3: []
    ]
    
    private var descriptionText: String?
    
    private var dateWhenStartedRequests: TimeInterval!
    
    private var isBothRequestsEnded = 0
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = inputProjectUsers.project?.name
        tableView.tableFooterView = UIView(frame: .zero)
        
        dateWhenStartedRequests = Date().timeIntervalSince1970
        
        // Make URL Requests
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let userProjectID = inputProjectUsers.id {
            getProjectsUsers(userProjectID)
        }
        if let projectID = inputProjectUsers.project?.id {
            getProjectInfo(projectID)
        }
        
        if poolDays.isEmpty == false {
            navigationItem.rightBarButtonItems?.removeAll()
        }
        
        poolDays.sort(by: { ($0.id ?? 0) < ($1.id ?? 0) })
    }
    
    // MARK: - Requests
    private func getProjectsUsers(_ userProjectID: Int) {
        API.shared.getDataOfProject(projectID: userProjectID) { (newProjectsUsers) in
            DispatchQueue.main.async {
                
                let sortedTeams = newProjectsUsers?.teams?.sorted(by: { ($0.id ?? 0) < ($1.id ?? 0) })
                var projectsWithSortedTeams = newProjectsUsers
                projectsWithSortedTeams?.teams = sortedTeams
                self.projectsUsers = projectsWithSortedTeams
                self.isBothRequestsEnded += 1
                if self.isBothRequestsEnded == 2{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
    }
    
    // MARK: - getProjectInfo
    private func getProjectInfo(_ projectID: Int) {
        API.shared.getGeneralInfoOfProject(projectID: projectID) { (newProjectInfo) in
            DispatchQueue.main.async {
                self.projectInfo = newProjectInfo
                
                if newProjectInfo.exam ?? true {
                    // Remove right navigation button
                    self.navigationItem.rightBarButtonItems?.removeAll()
                }
                self.isBothRequestsEnded += 1
                if self.isBothRequestsEnded == 2{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    // MARK: - defineBestDescription
    private func defineBestDescription(_ projectSession: [ProjectInfo.ProjectSession]) -> String? {
        
        var bestDescription: String?
        if let indexOf13campus = projectSession.firstIndex(where: { $0.campusID == 13 }),
            let description = projectSession[indexOf13campus].projectSessionDescription {
            
            bestDescription = description
        } else if let indexOf8campus = projectSession.firstIndex(where: { $0.campusID == 8 }),
            let description = projectSession[indexOf8campus].projectSessionDescription {
            
            bestDescription = description
        } else {
            for session in projectSession {
                if let description = session.projectSessionDescription, description.isEmpty == false {
                    bestDescription = description
                    break
                }
            }
        }
        return bestDescription
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
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMaxRange()
    }
    
    private func getMaxRange() -> Int {
        
        var result = 0
        rangesForCell.values.forEach { (ranges) in
            if let last = ranges.last, last > result {
                result = last
            }
        }
        return result + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 170
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var index = 0
        while index < rangesForCell.count {
            guard rangesForCell[index]?.contains(indexPath.row) == false else { break }
            index += 1
        }
        
        guard index < rangesForCell.count else {
            print("index > rangesForCell.count")
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
        
        removeSeparator(forCell: cell)
        
        cell.fillViews(inputProjectUsers, projectInfo?.projectSessions)
        return cell
    }
    
    // MARK: - getDescriptionCell
    private func getDescriptionCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectDescriptionCell,
            let description = self.descriptionText else { return UITableViewCell() }
        
        removeSeparator(forCell: cell)
        
        cell.fillDescription(description)
        return cell
    }
    
    // MARK: - getTeamCell
    private func getTeamCell(cellIdentifier identifier: String, _ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProjectTeamCell,
            let projectsUsers = projectsUsers,
            let minOfRange = rangesForCell[2]?.first else { return UITableViewCell() }
        
        removeSeparator(forCell: cell)
        
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
    
    // MARK: removeSeparator
    private func removeSeparator(forCell cell: UITableViewCell) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell.directionalLayoutMargins = .zero
    }
}

extension ProjectTVC {
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get cell ranges for pool Days
        guard let min = rangesForCell[3]?.first, let max = rangesForCell[3]?.last,
            min...max ~= indexPath.row,
            let newVC = storyboard?.instantiateViewController(withIdentifier: "ProjectTVC") as? ProjectTVC else { return }
        
        let poolDay = poolDays[indexPath.row - min]
        
        newVC.inputProjectUsers = poolDay
        newVC.poolDays = []
        
        navigationController?.pushViewController(newVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
