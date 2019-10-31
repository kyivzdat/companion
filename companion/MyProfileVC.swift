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

    var resultSearchController: UISearchController?
    
//    let resultSearchController = UISearchController(searchResultsController: TableVC)
    
    let iconSearch = UIImage(named: "iconSearch")
    var profileLabel : UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        initProfileLabel()
        
        
        let table = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! TableVC
        resultSearchController = UISearchController(searchResultsController: table)
        resultSearchController?.searchResultsUpdater = table
        searchBar = resultSearchController?.searchBar
    
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
    }

    func initProfileLabel() {
        profileLabel = UILabel()
        guard let profileLabel = profileLabel else { return }
        profileLabel.text = "Profile"
        profileLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }

    @IBAction func tapSearchButton(_ sender: UIBarButtonItem) {
        showSearchBar()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard searchBar.text?.isEmpty == false else { print("SearchBar is empty"); return }
        
        apiInfo.getProfile(user: searchBar.text!.lowercased())
    }
    
    func showSearchBar() {
        
        self.navigationItem.rightBarButtonItem?.image = nil
        searchBar.sizeToFit()
        searchBar.alpha = 0
        navigationItem.titleView = resultSearchController?.searchBar
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
    
        self.navigationItem.rightBarButtonItem?.image = iconSearch
        guard let profileLabel = profileLabel else { return }
        profileLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.titleView = self.profileLabel
            profileLabel.alpha = 1
        })
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
