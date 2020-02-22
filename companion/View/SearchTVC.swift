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
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
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
}

extension SearchTVC {
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let login = matchingLogins[indexPath.row]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        API.shared.getProfileInfo(userLogin: login) { (result) in
            DispatchQueue.main.async {
                self.showUserProfile(result, login)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showUserProfile(_ result: Result<UserData, Error>, _ login: String) {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let userData: UserData?
        switch result {
        case .success(let response):
            userData = response
        case .failure(let error):
            print("Failed to fetch self info: ", error)
            userData = nil
        }
        if let userData = userData {
            guard let newUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC else { return }
            
            newUserProfileVC.userData = userData
            newUserProfileVC.navigationItem.title = login
            self.parentTVC.navigationController?.pushViewController(newUserProfileVC, animated: true)
        }
    }
}

extension SearchTVC: UISearchResultsUpdating {
    // MARK: - SearchController ResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        guard var searchBarText = searchController.searchBar.text else { return }
        searchBarText = searchBarText.lowercased()
        print("-", searchBarText)
        DispatchQueue.global(qos: .userInteractive).async {
            API.shared.getRangeProfiles(inputText: searchBarText) { (profiles) in
                self.matchingLogins = profiles
            }
        }
    }
}
