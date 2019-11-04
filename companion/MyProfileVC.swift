//
//  MyProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/28/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController, UISearchBarDelegate {


    var resultSearchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }

    private func setupSearchController() {
        let tableView = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! TableVC
        resultSearchController = UISearchController(searchResultsController: tableView)
        resultSearchController?.searchResultsUpdater = tableView
        
        resultSearchController?.searchBar.delegate = self
        resultSearchController?.searchBar.sizeToFit()
        resultSearchController?.searchBar.placeholder = "Search a user"
        
        resultSearchController?.hidesNavigationBarDuringPresentation = true
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        navigationItem.searchController = resultSearchController
    }

    @IBAction func tapSearchButton(_ sender: UIBarButtonItem) {
        resultSearchController?.searchBar.becomeFirstResponder()
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard searchBar.text?.isEmpty == false else { print("SearchBar is empty"); return }
        API.shared.getProfile(user: searchBar.text!.lowercased())
    }

    
    func alert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            alert.view.layoutIfNeeded()
//            !!!
//            UIApplication.topViewController()?.view.addSubview(UIView())
//            turn off "animated:" for fix constraints
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }

}

extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

