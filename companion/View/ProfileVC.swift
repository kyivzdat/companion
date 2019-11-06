//
//  MyProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/28/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UISearchBarDelegate {

    var resultSearchController: UISearchController?
    var profile: Profile!

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet var backBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideLeftBarButton(isHide: profile.isMyProfile)
        
        print("Is my profile? - ", (profile.isMyProfile ? "true" : "false"))
        profile.personInfo?.description()
        loginLabel.text = profile.personInfo?.login
        
    }

    @IBAction func tapSearchButton(_ sender: UIBarButtonItem) {
        resultSearchController?.searchBar.becomeFirstResponder()
    }
    
    
    @IBAction func tapBackBarButton(_ sender: UIBarButtonItem) {
        profile.personInfo = myInfo
        profile.eventInfo.append("Event")
        performSegue(withIdentifier: "backToMyProfileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? UINavigationController {
            if let vc = navi.viewControllers.first as? ProfileVC {
                vc.profile = self.profile
            }
        }
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        guard searchBar.text?.isEmpty == false else { print("SearchBar is empty"); return }
//        API.shared.getProfile(user: searchBar.text!.lowercased())
//    }
    
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

extension ProfileVC {
    private func setupSearchController() {
        let tableView = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! TableVC
        tableView.profile = self.profile
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
    
    private func hideLeftBarButton(isHide: Bool) {
        navigationItem.leftBarButtonItem = (isHide) ? nil : self.backBarButton
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

