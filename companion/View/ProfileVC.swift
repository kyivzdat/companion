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
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var correctionPointsLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var countryCityLabel: UILabel!
    @IBOutlet weak var statusPesonLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet var backBarButton: UIBarButtonItem!
    
    
//    @IBOutlet weak var skillsTableConstraint: NSLayoutConstraint!
//    @IBOutlet weak var projectsTableWidthConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        skillsTableConstraint.constant = self.view.bounds.width - 10
//        projectsTableWidthConstraint.constant = skillsTableConstraint.constant
        
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        putInfoOnView()
        print("height = \(self.view.bounds.height), width = \(self.view.bounds.width)")
    }
    
    private func putInfoOnView() {
        hideLeftBarButton(isHide: profile.isMyProfile)
        print("Is my profile? - ", (profile.isMyProfile ? "true" : "false"))
        profile.personInfo?.description()
        
        guard let personInfo = profile.personInfo else { return }
        DispatchQueue.main.async {
            guard personInfo.image_url != nil else { return }
            do {
                guard let urlPhoto = URL(string: personInfo.image_url!) else { return }
                self.profileImage.image = try UIImage(data: Data(contentsOf: urlPhoto))
            } catch {
                self.profileImage.image = UIImage(contentsOfFile: "noPhoto")
            }
        }
        nameSurnameLabel.text = personInfo.first_name! + " " + personInfo.last_name!
        correctionPointsLabel.text = "Correction Points: " + String(personInfo.correction_point!)
        walletLabel.text = "Wallet: " + String(personInfo.wallet!) + "₳"
        countryCityLabel.text = (personInfo.campus[0]?.country)! + ", " + (personInfo.campus[0]?.city)!
        statusPesonLabel.text = personInfo.location ?? "Unavailable"
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

