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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = inputProjectUsers.project?.name
        // Make URL Requests
        getProjectsUsers()
        getProjectInfo()
        
    }
    
    func getProjectsUsers() {
        if let userProjectID = inputProjectUsers.id {
            API.shared.getDataOfProject(projectID: userProjectID) { (newProjectsUsers) in
                DispatchQueue.main.async {
                    self.projectsUsers = newProjectsUsers
                }
            }
        }
    }
    
    func getProjectInfo() {
        if let projectID = inputProjectUsers.project?.id {
            API.shared.getGeneralInfoOfProject(projectID: projectID) { (newProjectInfo) in
                DispatchQueue.main.async {
                    self.projectInfo = newProjectInfo
                }
            }
        }
    }
    
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
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch index {
        case 0:
            guard let cell = cell as? ProjectMainInfoCell else { return UITableViewCell() }
            cell.fillViews(inputProjectUsers, projectInfo?.projectSessions)
            
        case 1:
            guard let cell = cell as? ProjectDescriptionCell,
                let projectSession = projectInfo?.projectSessions else { return UITableViewCell() }
            cell.fillDescriptionLabel(projectSession)
            
        case 2:
            guard let cell = cell as? ProjectTeamCell,
                let projectsUsers = projectsUsers,
                let minOfRange = rangesForCell[2]?.first else { return UITableViewCell() }
            
            let indexOfTeam = indexPath.row - minOfRange
            cell.fillTeamUsers(projectsUsers, indexOfTeam)
        case 3:
            guard let cell = cell as? ProjectCell,
            let minOfRange = rangesForCell[3]?.first else { return UITableViewCell() }
            
            let indexOfTeam = indexPath.row - minOfRange
            if indexOfTeam < poolDays.count {
                let day = poolDays[indexOfTeam]
                let finalMark = day.finalMark
                let isValidated = day.validated
                let status = day.status
                cell.formatingMarkLabel(mark: finalMark, isValidated: isValidated, status: status)
                cell.projectLabel.text = day.project?.name
            }
            
        default:
            print("default")
            return UITableViewCell()
        }
        guard let definedCell = cell else { return UITableViewCell() }
        
        
        return definedCell
    }
}
