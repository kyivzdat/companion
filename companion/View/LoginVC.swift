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

class LoginVC: UIViewController {

    var profile: Profile!
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let api = API.shared

        let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
        do {
            let tokenArray = try context.fetch(fetchRequest)
            
            if tokenArray.count == 0 {
                api.authorization {
                    self.getInfo(api: api)
                }
            } else {
                guard let token = tokenArray.first else { return }
                print("📅 Expired_at: ", NSDate(timeIntervalSince1970: TimeInterval(token.expires_at + 7200)))
                print("📅 Current date: ", NSDate(timeIntervalSince1970: Date().timeIntervalSince1970 + 7200))
                
                if token.expires_at < Int64(Date().timeIntervalSince1970) {
                    api.refreshToken {
                        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    }
                }
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        } catch {
            print(error)
        }
    }
    
    private func getInfo(api: API) {
        api.getMyInfo(completion: { (result) in
            switch result {
                case .success(let login):
                let userDefaults = UserDefaults.standard
                userDefaults.set(login, forKey: "login")
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            case .failure(let error):
                print("Failed to fetch self info: ", error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let tabBar = segue.destination as? UITabBarController {
            if let navi = tabBar.viewControllers?[0] as? UINavigationController {
                if let vc = navi.viewControllers[0] as? ProfileVC {
                    profile.eventInfo.append("Event")
                    vc.profile = profile

                }
            }
        }
    }
}
