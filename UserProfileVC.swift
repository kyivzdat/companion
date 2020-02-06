//
//  UserProfileVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/5/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class UserProfileVC: UITableViewController {

    // MARK: - Outlets
    // Main info outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var yearOfpool: UILabel!
    
    // Location outlet
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    // Internship exams outlets
    @IBOutlet var internshipImageViews: Array<UIImageView>!
    @IBOutlet var examsImageViews: Array<UIImageView>!
    
    // Level outlet
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    
    // All bg views
    @IBOutlet var bgViews: Array<UIView>!
    
    
    
    
    
    // MARK: - view Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bgViews.forEach { (view) in
            view.layer.cornerRadius = 3
            view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
            view.layer.shadowRadius = 1
            view.layer.shadowOpacity = 0.1
        }
        tableView.tableFooterView = UIView(frame: .zero)
    }


}
