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
    
    private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    private var matchingLogins: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isAlreadyUserChose = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = .systemBlue
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - showUserProfile
    private func showUserProfile(_ result: Result<UserData, Error>, _ login: String) {
        
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC else { return }
        
        dvc.navigationItem.title = login
        switch result {
        case .success(let userData):
            guard userData.login != nil else {
                showErrorAlert()
                break
            }
            dvc.userData = userData
            dvc.titleText = userData.login
            self.parentTVC.navigationController?.pushViewController(dvc, animated: true)
        case .failure(let error):
            print("Failed to fetch self info: ", error)
            showErrorAlert()
        }
        showActivityIndicator(isActive: false)
    }
    
    private func showErrorAlert() {
        
        let ac = UIAlertController(title: "Can not find such user",
                                   message: "Try to change login",
                                   preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
    
    // MARK: - showActivityIndicator
    private func showActivityIndicator(isActive: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isActive
            self.activityIndicator.isHidden = !isActive
            if isActive {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - getUserInfo
    private func getUserInfo(_ login: String) {
        isAlreadyUserChose = true
        
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

extension SearchTVC: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating
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

extension SearchTVC: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let supposedLogin = searchBar.text?.lowercased() else { return print("searchBar.text is Empty") }
        
        guard isAlreadyUserChose == false else {
            print("Tried to select multiple users")
            return
        }
        
        getUserInfo(supposedLogin)
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

        let login = matchingLogins[indexPath.row]
        getUserInfo(login)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
