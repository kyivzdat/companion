//
//  SearchTVC.swift
//  companion
//
//  Created by kyivzdat on 10/31/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit


class SearchTVC: UITableViewController {

    var parentTVC: UITableViewController!
    
    var matchingLogins: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension SearchTVC: UISearchResultsUpdating {

    // MARK: - updateSearchResults
    func updateSearchResults(for searchController: UISearchController) {
        
        guard var searchBarText = searchController.searchBar.text else { return }
        searchBarText = searchBarText.lowercased()
        
        print(searchBarText)
        API.shared.getRangeProfiles(inputText: searchBarText) { (profiles) in
            self.matchingLogins = profiles
        }
    }
}

extension SearchTVC {
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingLogins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTVCell
        
        let login = matchingLogins[indexPath.row]
        cell.fillSearchCell(login)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let login = matchingLogins[indexPath.row]
        
        API.shared.getProfileInfo(userLogin: login) { (result) in
            DispatchQueue.main.async {
                self.showUserProfile(result, login)
            }
        }
    }
    
    // MARK: - TableView Delegate
    func showUserProfile(_ result: Result<UserData, Error>, _ login: String) {
        
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC else { return }
        
        dvc.navigationItem.title = login
        switch result {
        case .success(let userData):
            dvc.userData = userData
            self.parentTVC.navigationController?.pushViewController(dvc, animated: true)
        case .failure(let error):
            print("Failed to fetch self info: ", error)
        }
    }
}
