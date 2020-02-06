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
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let api = API.shared
        
        let fetchRequest: NSFetchRequest<TokenDB> = TokenDB.fetchRequest()
        var tokenArray: [TokenDB] = []
        do {
            tokenArray = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        // If first launch
        if tokenArray.isEmpty {
            
            api.authorization(urlContext: self) {
                self.getInfo()
            }
        } else {
            guard let token = tokenArray.first else { return }
            // +7200 (2h) to Ukraine time
            print("📅 Current date: ", NSDate(timeIntervalSince1970: Date().timeIntervalSince1970 + 7200))
            print("📅 Expired_at: ", NSDate(timeIntervalSince1970: TimeInterval(token.expiresIn + 7200)))
            
            // + 10 min (600 sec)
            if token.expiresIn < Int64(Date().timeIntervalSince1970) + 600 {
                api.refreshToken() {
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                }
            } else {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
    
    private func getInfo() {
        API.shared.getMyInfo(completion: { (result) in
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
    
}

@available(iOS 13.0, *)
extension LoginVC: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
