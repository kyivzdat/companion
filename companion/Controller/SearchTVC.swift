//
//  SearchTVC.swift
//  companion
//
//  Created by kyivzdat on 10/31/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit


class SearchTVC: UITableViewController {

    // Passed from prev VC
    var parentTVC: UITableViewController!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    var matchingLogins: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isAlreadyUserChose = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - showUserProfile
    func showUserProfile(_ result: Result<UserData, Error>, _ login: String) {
        
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC else { return }
        
        dvc.navigationItem.title = login
        switch result {
        case .success(let userData):
            dvc.userData = userData
            dvc.titleText = userData.login
            self.parentTVC.navigationController?.pushViewController(dvc, animated: true)
        case .failure(let error):
            print("Failed to fetch self info: ", error)
        }
        showActivityIndicator(isActive: false)
    }
    
    // MARK: - showActivityIndicator
    func showActivityIndicator(isActive: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isActive ? true : false
            if isActive {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.activityIndicator.isHidden = isActive ? false : true
        }
    }
}

extension SearchTVC: UISearchResultsUpdating {

    // MARK: - updateSearchResults
    func updateSearchResults(for searchController: UISearchController) {
        
        guard var searchBarText = searchController.searchBar.text else { return }
        searchBarText = searchBarText.lowercased()
        
        print(searchBarText)
        API.shared.getRangeProfiles(inputText: searchBarText) { (profiles) in
            if let profiles = profiles {
                self.matchingLogins = profiles
            }
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
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard isAlreadyUserChose == false else {
            
            tableView.deselectRow(at: indexPath, animated: true)
            print("Tried to select multiple users")
            return
        }
        
        isAlreadyUserChose = true
        
        let login = matchingLogins[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("login -", login)
        showActivityIndicator(isActive: true)
        API.shared.getProfileInfo(userLogin: login) { (result) in
            DispatchQueue.main.async {
                self.showUserProfile(result, login)
                self.isAlreadyUserChose = false
            }
        }
    }
}
