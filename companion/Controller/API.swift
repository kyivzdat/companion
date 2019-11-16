//
//  API.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import AuthenticationServices

class API {

    static let shared = API()
    
    private var webAuthSession: ASWebAuthenticationSession?
    private let callbackURI = "companion://companion"
    private let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    private let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    private let apiURL = "https://api.intra.42.fr/"
    private var bearer = ""
    
    private init() {}
}

// MARK: Authorization
extension API {

    func authorization(completion: @escaping () -> ()) {
        
        webAuthSession = ASWebAuthenticationSession(url:
            URL(string: apiURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
            callbackURLScheme: callbackURI, completionHandler: { (url, error) in
                guard error == nil else { return print(error!)}
                guard let url = url else { return }
                self.getToken(token: url.query!, completion: { () in
                    completion()
                })
        })
        webAuthSession?.start()
    }
    
    private func getToken(token: String, completion: @escaping () -> ()) {
        
        guard let url = NSURL(string: apiURL+"oauth/token") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        print(token)
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&\(token)&redirect_uri=\(callbackURI)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil else { return print(error!) }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if json!["error"] == nil {
                    self.bearer = json!["access_token"]! as! String
                    print(self.bearer)
                    completion()
                } else {
                    print(json!)
                }
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
}

// MARK: Get Info
extension API {
    public func getMyInfo(completion: @escaping (ProfileInfo) -> ()) {

        guard let url = NSURL(string: apiURL+"/v2/me") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let myInfo = try JSONDecoder().decode(ProfileInfo.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(myInfo)
                DispatchQueue.main.async {
                    completion(myInfo)
                }
            } catch {
                print(error)
                return
            }
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
//            print(json)
        }.resume()
    }

    public func getProfile(user: String, completion: @escaping (ProfileInfo) -> ()) {
        
        print("getProfile")
        print("!\(user)!")
        guard let url = NSURL(string: apiURL+"v2/users/"+user) else { return print("url Error")}
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return print("data error") }
            do {
                let profileInfo = try JSONDecoder().decode(ProfileInfo.self, from: data)
                print("completion")
                DispatchQueue.main.async {
                    completion(profileInfo)
                }
            } catch {
                print("do catch\n", error)
                ProfileVC().alert(title: "Error", message: "Человечка не найти")
                return
            }
        }.resume()
    }
    
    public func getRangeProfiles(inputText: String, completion: @escaping (Data) -> ()) {

//        guard let url = NSURL(string: API.shared.apiURL+"v2/users?range[login]=\(inputText),\(inputText)z&sort=login") else {
//            return
//        }
    
    guard let url = NSURL(string: API.shared.apiURL+"v2/users?search[login]=\(inputText)&sort=login") else {
    return
    }
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}

//Mark: Slots
extension API {
    public func getSlots() {
        guard let url = NSURL(string: apiURL+"/v2/slots") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(json)
        }.resume()
    }
    
    public func putSlots() {
        
        guard let url = NSURL(string: apiURL+"/v2/slots") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = "slots[user_id]=41821&slot[begin_at]=2019-11-07T15:30:00.000Z&slot[end_at]=2019-11-07T16:30:00.000Z".data(using: String.Encoding.utf8)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil else { return print(error!) }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(json!)
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
}
