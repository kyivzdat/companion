//
//  MyProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/28/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UISearchBarDelegate, UIScrollViewDelegate {

    var resultSearchController: UISearchController?
    var profile: Profile!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var correctionPointsLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var countryCityLabel: UILabel!
    @IBOutlet weak var statusPesonLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForTable: UIView!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var skillsTableView: UITableView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewForTable.layer.cornerRadius = 30
        projectsTableView.layer.cornerRadius = 15
        skillsTableView.layer.cornerRadius = 15
        scrollView.isPagingEnabled = true
        
        pageController.numberOfPages = 2
        
        scrollView.delegate = self
//        skillsTableConstraint.constant = self.view.bounds.width - 10
//        projectsTableWidthConstraint.constant = skillsTableConstraint.constant
        
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        putInfoOnView()
        print("height = \(self.view.bounds.height), width = \(self.view.bounds.width)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("\(scrollView.contentOffset.x) / \(scrollView.frame.size.width) = \(pageNumber)")
        pageController.currentPage = Int(pageNumber)
    }
    
    private func putInfoOnView() {
//        hideLeftBarButton(isHide: profile.isMyProfile)
        print("Is my profile? - ", (profile.isMyProfile ? "true" : "false"))
        profile.myInfo?.description()
        
        guard let personInfo = profile.myInfo else { return }
        print(personInfo)
        DispatchQueue.main.async {
            guard personInfo.image_url != nil else { return }
            do {
                guard let urlPhoto = URL(string: personInfo.image_url!) else { return }
                self.profileImage.image = try UIImage(data: Data(contentsOf: urlPhoto))
            } catch {
                self.profileImage.image = UIImage(contentsOfFile: "noPhoto")
            }
        }
        nameSurnameLabel.text = (personInfo.first_name ?? "nil") + " " + (personInfo.last_name  ?? "nil")
        correctionPointsLabel.text = "Correction Points: " + String(personInfo.correction_point ?? -1)
        walletLabel.text = "Wallet: " + String(personInfo.wallet ?? -1) + "₳"
        countryCityLabel.text = (personInfo.campus[0]?.country ?? "nil") + ", " + (personInfo.campus[0]?.city ?? "nil")
        statusPesonLabel.text = personInfo.location ?? "Unavailable"
        levelLabel.text = "Level " + String(personInfo.cursus_users[0]?.level ?? -1)
        progressView.progress = Float(Float((personInfo.cursus_users[0]?.level)!) - Float(Int((personInfo.cursus_users[0]?.level)!)))
    }
    

    @IBAction func tapSearchButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.topStackTopConstraint.constant += 20
            self.navigationItem.searchController = self.resultSearchController
            self.resultSearchController?.searchBar.becomeFirstResponder()
            self.searchButton.isEnabled = false
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.topStackTopConstraint.constant -= 20
            self.navigationItem.searchController = nil
            self.searchButton.isEnabled = true
            
        }
    }
    
//    @IBAction func tapBackBarButton(_ sender: UIBarButtonItem) {
////        profile.personInfo = myInfo
//        profile.eventInfo.append("Event")
//        performSegue(withIdentifier: "backToMyProfileSegue", sender: nil)
//    }
    
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
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
//        navigationItem.searchController = resultSearchController
    }
    
//    private func hideLeftBarButton(isHide: Bool) {
//        navigationItem.leftBarButtonItem = (isHide) ? nil : self.backBarButton
//    }
    
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

