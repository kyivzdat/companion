//
//  TableVC.swift
//  companion
//
//  Created by kyivzdat on 10/31/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

struct ParseProfile: Decodable {

    var login: String?
}

class TableVC: UITableViewController {

    var matchingLogins: [ParseProfile?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TableVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        print(searchBarText)
        API.shared.getRangeProfiles(inputText: searchBarText) { (json) in
            do {
                let tmpArray = try JSONDecoder().decode([ParseProfile].self, from: json)
                if tmpArray.isEmpty == false {
                    self.matchingLogins = tmpArray
                    self.tableView.reloadData()
                }
            } catch {
                return print("error getRangeProfile\n\t", error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                userLogin = (matchingLogins[indexPath.row]?.login!)!
                print(userLogin)
            }
        }
    }
    
}

extension TableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingLogins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingLogins[indexPath.row]
        cell.textLabel?.text = selectedItem?.login
        return cell
    }
}
