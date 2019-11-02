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

    var matchingLogins: [ParseProfile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        print(searchBarText)
        self.getRangeProfile(inputText: searchBarText)
    }
    
    func getRangeProfile(inputText: String) {
        guard let url = NSURL(string: apiInfo.apiURL+"v2/users?range[login]=\(inputText),\(inputText)z&sort=login") else {
            MyProfileVC().alert(title: "Error", message: "Wrong url")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + apiInfo.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil, let data = data else { MyProfileVC().alert(title: "Error", message: "Wrong url"); return }
            
//            let json = try? JSONSerialization.jsonObject(with: data, options: [])
//            print(json ?? "nil")
            do {
                self.matchingLogins = try JSONDecoder().decode([ParseProfile].self, from: data)
            } catch {
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                userLogin = matchingLogins[indexPath.row].login!
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
        cell.textLabel?.text = selectedItem.login
        return cell
    }

}
