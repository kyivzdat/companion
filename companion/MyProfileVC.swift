//
//  MyProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/28/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchButtonOutlet: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    
    let iconSearch = UIImage(named: "iconSearch")
    let profileLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    
        profileLabel.text = "Profile"
        profileLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }


    @IBAction func tapSearchButton(_ sender: UIBarButtonItem) {

        self.navigationItem.rightBarButtonItem?.image = nil
        self.navigationItem.titleView = searchBar
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.endEditing(true)
    
        self.navigationItem.titleView = profileLabel
        self.navigationItem.rightBarButtonItem?.image = iconSearch
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty == true {
            print("SearchBar is empty")
        }
        
        if apiInfo.getProfile(user: searchBar.text!) == true {
            profileInfo?.description()
        } else {
            let alert = UIAlertController(title: "Error", message: "Человечка не найти", preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Error input")
        }
    }

}

