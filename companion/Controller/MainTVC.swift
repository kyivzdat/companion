//
//  MainTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 12/13/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var evaluationPointsLabel: UILabel!
    @IBOutlet weak var clusterLocationLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // Contacts
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var countryCityLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var poolDateLabel: UILabel!
    
    // Calendar
    @IBOutlet weak var calendarsCollectionView: UICollectionView!
    
    var profileInfo: ProfileInfoDB?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calendarsCollectionView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        guard fetchData() == true else { return }
        fillLabel()
        
    }
    
    func fetchData() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let login = userDefaults.object(forKey: "login") as? String else { return false }
        
        let profileFetchRequest: NSFetchRequest<ProfileInfoDB> = ProfileInfoDB.fetchRequest()
        profileFetchRequest.predicate = NSPredicate(format: "login = %@", login)
        
        let tokenFetchRequest: NSFetchRequest<TokenDB> = TokenDB.fetchRequest()
        tokenFetchRequest.returnsObjectsAsFaults = false
        
        do {
            let token = try context?.fetch(tokenFetchRequest)
            print(token?.first)
            
            let profiles = try context?.fetch(profileFetchRequest)
            self.profileInfo = profiles?.first
            print("Successfully fetch profileInfo! 👍")
            return true
        } catch {
            print("Fail fetch profileInfo! 👎", error)
            return false
        }
    }
    
    func fillLabel() {
        
        do {
            guard let url = URL(string: profileInfo?.image_url ?? "") else { return }
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            self.profileImageView.image = image
        } catch {
            print("Fail load profile image! ", error)
        }
        
        let firstName = profileInfo?.first_name ?? ""
        let secondName = profileInfo?.last_name ?? ""
        nameSurnameLabel.text = firstName + " " + secondName
        
        loginLabel.text = profileInfo?.login
        evaluationPointsLabel.text = "Evaluation points: " + String(profileInfo?.correction_point ?? -1)
        clusterLocationLabel.text = profileInfo?.location ?? "Unavailable"
        
        let cursusUsers = profileInfo?.cursusUsers?.allObjects as? [CursusUsersDB]
        var level: Double = 0
        if cursusUsers?.first?.cursus_id == 1 {
            level = cursusUsers?.first?.level ?? -1
        } else {
            level = cursusUsers?[1].level ?? -1
        }
        
        levelLabel.text = String(level)
        let progress = Float(Double(level) - Double(Int(level)))
        progressView.progress = progress
        
        let country = profileInfo?.campus?.country ?? ""
        let city = profileInfo?.campus?.city ?? ""
        countryCityLabel.text = country + ", " + city
        
        walletLabel.text = "Wallet: " + String(profileInfo?.wallet ?? -1) + "₳"
    }
}

extension MainTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarsCollectionView {
            return 3
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calendarsCollectionView {
            guard let cell = calendarsCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarsCell", for: indexPath) as? CalendarsCollectionViewCell else { return UICollectionViewCell() }
//            cell.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
//            cell.translatesAutoresizingMaskIntoConstraints = false
//            cell.heightAnchor.constraint(equalTo: collectionView.heightAnchor, constant: 0).isActive = true
//            cell.widthAnchor.constraint(equalTo: collectionView.widthAnchor, constant: 0).isActive = true
//            cell.monthCollectionView = monthCV
            return cell
        }
        
        return UICollectionViewCell()
    }
}
