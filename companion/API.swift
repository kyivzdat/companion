//
//  API.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import AuthenticationServices

class API: ViewController {

    var webAuthSession: ASWebAuthenticationSession?
    let callbackURI = "companion://companion"
    let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    let apiURL = "https://api.intra.42.fr/"
    var bearer = ""
    

    
    func authorization() {

        webAuthSession = ASWebAuthenticationSession(url:
            URL(string: apiURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
        callbackURLScheme: callbackURI, completionHandler: { (url, error) in
            
            guard error == nil else { print(error!); return }
            guard let url = url else { return }
            self.getToken(token: url.query!)
        })
        webAuthSession?.start()

    }
    
    private func getToken(token: String) {
    
        guard let url = NSURL(string: apiURL+"oauth/token") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&\(token)&redirect_uri=\(callbackURI)".data(using: String.Encoding.utf8)

        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in

            guard error == nil else { print(error!); return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if json!["error"] == nil {
                    self.bearer = json!["access_token"]! as! String
                    
                    self.getMyInfo()

                } else {
                    print(json!)
                }
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
    
    
    private func getMyInfo() {
        
        guard let url = NSURL(string: apiURL+"/v2/me") else { return }
    
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil else { print(error!); return}
            guard let data = data else { return }
            
            if !self.getInfo(destination: &myInfo, data: data) {
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(json)
            
            myInfo!.description()

            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "NaviController") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            }
            
        }.resume()
        
    }
    
    private func getInfo(destination: inout ProfileInfo?, data: Data) -> Bool {
        do {
            
            destination = try JSONDecoder().decode(ProfileInfo.self, from: data)
            
            guard destination != nil else { print("Error. Create my info"); return false }
            

        } catch let error {
            print("getMyInfo error:\n", error)
            return false
        }
        return true
    }
}
