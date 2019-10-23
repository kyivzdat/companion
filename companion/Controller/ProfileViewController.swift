//
//  ProfileViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/22/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!

    var resultSearchController: UISearchController? = nil

    var profileInfo : SelfModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initInfo()
        initSearchBar()
    }

    private func initInfo() {
    
        guard let profileInfo = profileInfo else { return }

        loginLabel.text         = profileInfo.login
        nameLabel.text          = profileInfo.name + " " + profileInfo.surname
        correctionLabel.text    = String(describing: profileInfo.correctionPoints)
        levelLabel.text         = String(describing: profileInfo.level)
        locationLabel.text      = profileInfo.location
        imageView.image         = profileInfo.photo
    }
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.image = nil
        self.navigationItem.titleView = searchBar
        
    }
    
    private func initSearchBar() {

        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search user"
        searchBar.delegate = self
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.sizeToFit()
//        navigationItem.title = "Profile"
        navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "iconsSearch")
        initSearchBar()
    }

}




//let searchBar = UISearchBar()
//searchBar.showsCancelButton = true
//searchBar.placeholder = "Search user"
//searchBar.delegate = self
//self.navigationItem.titleView = searchBar


//        let profileSearchTable = storyboard!.instantiateViewController(withIdentifier: "ProfileSearchTable") as! ProfileSearchTable
//        resultSearchController = UISearchController(searchResultsController: profileSearchTable)
//        resultSearchController?.searchResultsUpdater = profileSearchTable
//
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search a user"
//        navigationItem.titleView = searchBar
//
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
