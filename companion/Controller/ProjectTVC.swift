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
    
    let projectsUsers: ProjectsUser? = nil
    let projectsInfo: ProjectInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = cellIdentifiers[indexPath.row]
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            guard let cell = cell as? ProjectMainInfoCell,
                let projectsUsers = projectsUsers, let projectsSession = projectsInfo?.projectSessions else { return UITableViewCell() }
            cell.fillViews(projectsUsers, projectsSession)
        case 1:
            cell = cell as? ProjectDescriptionCell
        case 2:
            cell = cell as? ProjectTeamCell
        case 3:
            cell = cell as? ProjectPoolDayCell
        default:
            return UITableViewCell()
        }
        
        guard let definedCell = cell else { return UITableViewCell() }
        
        
        
        return definedCell
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
