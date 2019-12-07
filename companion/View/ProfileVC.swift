//
//  MyProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/28/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CoreData

class ProfileVC: UIViewController, UISearchBarDelegate {

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
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var projectsTableHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var projectsTableWidthContstraint: NSLayoutConstraint!

    @IBOutlet weak var topStackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenTableAndBottomConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext else { return }
        let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
        do {
            let get = try context.fetch(fetchRequest)
            
            print("🤩get\n", get[0])
        } catch {
            print(error)
        }
        
        viewSetup()
        setupAdaptiveLayout()
        setupSearchController()
        putInfoOnView()
//        print("📏height = \(self.view.bounds.height), width = \(self.view.bounds.width)📏")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print("Is my profile? - ", (profile.isMyProfile ? "true" : "false"))
//        if profile.isMyProfile {
//            profile.myInfo?.description(withSkills: false, withProjects: false)
//        } else {
//            profile.personInfo?.description(withSkills: false, withProjects: false)
//        }
    }
    
    @IBAction func unwindToHomeVC(_ unwindSegue: UIStoryboardSegue) {

        guard let sourceVC = unwindSegue.source as? TableVC else { return }
        tabBarController?.selectedIndex = 3
    }
    
    
    private func putInfoOnView() {
        
        guard let personInfo = profile.myInfo else { return }
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
//        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.frame.origin.y += 20

            }, completion: { (finished) in
            })
            
            self.navigationItem.searchController = self.resultSearchController
            self.resultSearchController?.searchBar.becomeFirstResponder()
            self.searchButton.isEnabled = false
            
//        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.frame.origin.y -= 50
            }, completion: { (finished) in
            })
//            self.topStackTopConstraint.constant -= 20
            self.navigationItem.searchController = nil
            self.searchButton.isEnabled = true
//        }
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

//MARK: - Initial Setup
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
    
    private func setupAdaptiveLayout() {
        self.imageHeightConstraint.constant = 0.42 * self.view.bounds.width
        self.imageWidthConstraint.constant = 0.34 * self.view.bounds.width
        
        if self.view.bounds.height == 568 {
            self.projectsTableWidthContstraint.constant = 0.91 * self.view.bounds.width
            self.projectsTableHeightContstraint.constant = 0.3 * self.view.bounds.height
            self.betweenTableAndBottomConstraint.constant = 0.08 * self.view.bounds.height
        }
        if self.view.bounds.height == 667 {
            self.projectsTableWidthContstraint.constant = 0.91 * self.view.bounds.width
            self.projectsTableHeightContstraint.constant = 0.34 * self.view.bounds.height
            self.betweenTableAndBottomConstraint.constant = 0.08 * self.view.bounds.height
        }
        if self.view.bounds.height == 736 {
            self.projectsTableWidthContstraint.constant = 0.91 * self.view.bounds.width
            self.projectsTableHeightContstraint.constant = 0.38 * self.view.bounds.height
            self.betweenTableAndBottomConstraint.constant = 0.08 * self.view.bounds.height
        }
    }
    
    private func viewSetup() {
        skillsTableView.delegate = self
        skillsTableView.dataSource = self
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        scrollView.delegate = self
        
        viewForTable.layer.cornerRadius = 30
        projectsTableView.layer.cornerRadius = 6
        skillsTableView.layer.cornerRadius = 6
        
        scrollView.isPagingEnabled = true
        pageController.numberOfPages = 2
        
//        projectsTableView.layer.shadowRadius = 9
//        projectsTableView.layer.shadowOpacity = 0.3
//        projectsTableView.layer.shadowOffset = CGSize(width: 5, height: 8)
//        projectsTableView.clipsToBounds = false
//
//        skillsTableView.layer.shadowRadius = 9
//        skillsTableView.layer.shadowOpacity = 0.3
//        skillsTableView.layer.shadowOffset = CGSize(width: 5, height: 8)
//        skillsTableView.clipsToBounds = false
    }
}

//MARK: - Table Output
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    private func filterForProjectTable(slug: String) -> Bool {
        return !slug.contains("day") && !slug.contains("0") && !slug.contains("piscine-c")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableView {
        case skillsTableView:
            return profile.myInfo?.cursus_users[0]?.skills.count ?? 0
        case projectsTableView:
            guard let projects = profile.myInfo?.projects_users else { return 0 }
            var counter = 0
            for i in projects {
                if filterForProjectTable(slug: i?.project?.slug ?? "") {
                    counter += 1
                }
            }
            return counter
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmp = skillsTableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillCell

        switch tableView {
        case skillsTableView:
            let cell = skillsTableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillCell
            
            if let arrayOfSkills = profile.myInfo?.cursus_users[0]?.skills {
                cell.skillLabel.text = arrayOfSkills[indexPath.row]?.name
                cell.progressView.progress = Float(arrayOfSkills[indexPath.row]?.level ?? 0) * 5 / 100
            }
            return cell
        case projectsTableView:
            let cell = projectsTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProjectCell
            
            if let project = profile.myInfo?.projects_users {
                var index = project.count - 1
                var counter = 0
                
                while index >= 0 {
                    if filterForProjectTable(slug: project[index]?.project?.slug ?? "") {
                        if counter == indexPath.row {
                            break
                        }
                        counter += 1
                    }
                    index -= 1
                }
                cell.projectLabel.text = project[index]?.project?.name ?? "nil"
                let mark = String(project[index]?.final_mark ?? -1)
                if mark != "-1" {
                    cell.markLabel.text = mark
                    cell.markLabel.textColor = (project[index]?.validated == 1) ? UIColor.green : UIColor.red
                } else if project[index]?.status == "in_progress" {
                    cell.markLabel.text = "In progress"
                     cell.markLabel.textColor = .blue
                }
            }
            return cell
        default:
            return tmp
        }
    }
}

//MARK: - Scroll View
extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageController.currentPage = Int(pageNumber)
    }
}
