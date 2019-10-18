//
//  ViewController.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/18/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var lvlLabel: UILabel!
    
    var webAuthSession: ASWebAuthenticationSession?
    let callbackURI = "companion://companion"
    let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    var bearer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        webAuthSession = ASWebAuthenticationSession(url:
            URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
                callbackURLScheme: callbackURI,
                completionHandler: { (data, error) in
                    guard error == nil else { print(error!); return }
                    guard let data = data else { return }
                    print("DATA\n\n\n")
                    print(data) // companion://companion?code=a6643aa9272162d4acda12771866ee9f30e3859239c16934433b57311ba2dec0
                    print(data.query!) // code=079c583b40945842f3e71197ef444ecc69e4b385ab7cdf1461f1ade6b45113a2
                    self.getToken(token: data.query!)
                })
        webAuthSession?.start()
    }
    
    private func getToken(token: String) {
        guard let url = NSURL(string: "https://api.intra.42.fr/oauth/token") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&\(token)&redirect_uri=\(callbackURI)".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else { print(error!); return}
            guard let response = response else { return }
            print("\n\nRESPONSE\n\(response)")
            
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("\n\nJSON\n\(json)")
                    if json["error"] == nil {
                        self.bearer = json["access_token"]! as! String
                        print("\n\nBEARER")
                        print(self.bearer)
                        self.getMyInfo()
                    } else {
                        print("Error:", json)
                    }
                }
            } catch {
                print(error)
                return
            }
        }.resume()
    }
    
    private func getMyInfo() {
        guard let url = NSURL(string: "https://api.intra.42.fr/v2/me") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else { print(error!); return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    guard json["error"] == nil else { return }
                    print(json)
                    DispatchQueue.main.async {
                        self.lvlLabel.text = json["login"] as! String
                    }
                    
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    
}


