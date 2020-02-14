//
//  ViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AuthenticationServices
import CoreData
import RealmSwift

/*
 PartTime-I      id=1650 (dude who passed - mpillet)
 PartTime-II     id=1656 (all users in status="in_progress")
 */

class LoginVC: UIViewController {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        login()
    }
    
    func login() {
        print("Realm path -", Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        let api = API.shared
        
        let token = realm.objects(Token.self).first
        
        if let token = token {
            print("📅 Current date: ", NSDate(timeIntervalSince1970: Date().timeIntervalSince1970 + 7200))
            print("📅 Expired_at: ", NSDate(timeIntervalSince1970: TimeInterval(token.expires_in + 7200)))
            
            if token.expires_in < Int64(Date().timeIntervalSince1970) + 7600 {
                api.refreshToken() {
                    self.getInfo()
                }
            } else {
                self.getInfo()
            }
        } else {
            api.authorization(urlContext: self) {
                self.getInfo()
            }
        }
    }
    
    // MARK: - Login button
    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    
    private func getInfo() {
        API.shared.getProfileInfo(userLogin: "me") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(userData.login, forKey: "login")
                    self.performSegue(withIdentifier: "LoginSegue", sender: userData)
                case .failure(let error):
                    print("Failed to fetch self info: ", error)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBar = segue.destination as? UITabBarController,
            let naviContr = tabBar.viewControllers?.first as? UINavigationController,
            let dvc = naviContr.topViewController as? UserProfileVC ,
            let userData = sender as? UserData else { return print("Error. LoginVC. prepare()") }
        
        dvc.userData = userData
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
