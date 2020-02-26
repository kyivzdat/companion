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
    
    @IBOutlet weak var loginButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.loginButton.transform = .identity
        })
        login()
    }
    
    func setupButton() {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        loginButton.layer.borderWidth = 0.5
        loginButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loginButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        loginButton.clipsToBounds = true
        loginButton.transform = CGAffineTransform(translationX: 0, y: 300)
    }

    func login() {
        print("Realm path -", Realm.Configuration.defaultConfiguration.fileURL ?? "")
        let api = API.shared
        
        let token = realm.objects(Token.self).first
        
        if let token = token {
//            print("📅 Current date: ", NSDate(timeIntervalSince1970: Date().timeIntervalSince1970 + 7200))
//            print("📅 Expired_at: ", NSDate(timeIntervalSince1970: TimeInterval(token.expires_in + 7200)))

            if token.expires_in < Int64(Date().timeIntervalSince1970) + 600 {
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
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        animateTap(loginButton) {
            self.login()
        }
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
                    self.showAlert()
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Something went wrong", message: "Try again later", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default)
            ac.addAction(okButton)
            self.present(ac, animated: true)
        }
    }
    
    func animateTap<T>(_ view: T, completion: @escaping () -> ()) {
        
        guard let castView = view as? UIView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            castView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }) { (_) in
            completion()
            UIView.animate(withDuration: 0.3, animations: {
                castView.transform = .identity
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBar = segue.destination as? UITabBarController,
            let naviContr = tabBar.viewControllers?.first as? UINavigationController,
            let dvc = naviContr.topViewController as? UserProfileVC ,
            let userData = sender as? UserData else { return print("Error. LoginVC. prepare()") }
        
        dvc.userData = userData
        dvc.titleText = "Intra 42"
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
