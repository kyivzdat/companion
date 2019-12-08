//
//  API.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import AuthenticationServices
import CoreData

class API {

    static let shared = API()
    
    private var webAuthSession: ASWebAuthenticationSession?
    private let callbackURI = "companion://companion"
    private let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    private let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    private let apiURL = "https://api.intra.42.fr/"
    private var bearer = ""
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    private init() {}
}

// MARK: Authorization
extension API {

    func authorization(completion: @escaping () -> ()) {
        print("AUTHORIZATION")
        
        webAuthSession = ASWebAuthenticationSession(url:
            URL(string: apiURL+"oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackURI)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!,
            callbackURLScheme: callbackURI, completionHandler: { (url, error) in
                guard error == nil else { return print(error!)}
                guard let url = url else { return }
                print("🍏 url", url)
                self.getToken(token: url.query!, completion: { () in
                    completion()
                })
        })
        webAuthSession?.start()
    }
    
    private func getToken(token: String, completion: @escaping () -> ()) {
        print("GET TOKEN")
        
        guard let url = NSURL(string: apiURL+"oauth/token") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&\(token)&redirect_uri=\(callbackURI)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil else { return print(error!) }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                guard json!["error"] == nil else { return print("", json!)}
                self.bearer = json!["access_token"]! as! String
                self.successSaveNewToken(json: json!) {
                    completion()
                }
            } catch let error {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
    private func successSaveNewToken(json: NSDictionary, completion: @escaping() -> ()) {
        DispatchQueue.main.async {
            let token = Token(context: self.context)
            token.access_token = json["access_token"]! as? String
            token.expires_at = (json["created_at"]! as! Int64) + 7200
            token.refresh_token = json["refresh_token"]! as? String
            do {
                try self.context.save()
                print("Success save token! 👍")
                print(token)
                completion()
            } catch {
                print("Fail to save token! 👎", error)
            }
        }
        
    }
    
    public func refreshToken(complition: @escaping () -> ()) {

        print("REFRESH TOKEN")
        let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
        do {
            let tokenArray = try context.fetch(fetchRequest)
            guard let token = tokenArray.first else { return}
            print(token)
            updateTokenInfo(token: token) {
                complition()
            }
        } catch {
            print(error)
            return
        }
    }
    
    private func updateTokenInfo(token: Token, complition: @escaping () -> ()) {
        
        print("UPDATE TOKEN INFO")
        guard let url = NSURL(string: apiURL+"oauth/token") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        guard let refresh_token = token.refresh_token else { return }
        
        request.httpMethod = "POST"
        request.httpBody = "grant_type=refresh_token&client_id=\(UID)&client_secret=\(secret)&refresh_token=\(refresh_token)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil else { return print(error!) }
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                
                guard let newBearer = json["access_token"] as? String,
                      let created_at = json["created_at"] as? Int64,
                      let refresh_token = json["refresh_token"] as? String
                      else { return }
            
                self.bearer = newBearer
                let tokenUpdate = token as NSManagedObject
                tokenUpdate.setValue(self.bearer,       forKey: "access_token")
                tokenUpdate.setValue(created_at + 7200, forKey: "expires_at")
                tokenUpdate.setValue(refresh_token,     forKey: "refresh_token")
                
                try self.context.save()
                
                print("Success to refresh token! 👍")
                complition()
            } catch {
                print("Fail to refresh token! 👎", error)
            }
        }.resume()
    }
    
    private func getBearer() {
        print("GET BEARER")
        let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
        do {
            let tokenArray = try context.fetch(fetchRequest)
            print("token: \n", tokenArray.first ?? "")
            guard let access_token = tokenArray.first?.access_token else { return }
            self.bearer = access_token
        } catch {
            print(error)
        }
    }
    
}

// MARK: Get Info
extension API {
    public func getMyInfo(completion: @escaping (Result<ProfileInfo, Error>) -> ()) {

        if bearer == "" {
            getBearer()
        }
        guard let url = NSURL(string: apiURL+"/v2/me") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                var myInfo = try JSONDecoder().decode(ProfileInfo.self, from: data)
                
                let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                if let arr = json!["projects_users"] as? [NSDictionary] {
                    for i in 0..<arr.count {
                        myInfo.projects_users[i]?.validated = arr[i]["validated?"] as? Int
                    }
                }
                self.getDataOfProject(id: "11", userId: myInfo.id!, completion: { (passedExams) in
                    myInfo.passedExams = passedExams
                    DispatchQueue.main.async {
                        completion(.success(myInfo))
                    }
                })

                
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    public func getDataOfProject(id: String, userId: Int, completion: @escaping(Int) -> ()) {
        let urlString = API.shared.apiURL+"/v2/projects_users?filter[project_id]=\(id)&user_id=\(userId)" //project_id = 212, 118
        guard let url = NSURL(string: urlString) else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        print("🤪getDataOfProject🤪")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [NSDictionary]
                let teams = json![0]["teams"] as! [NSDictionary]
                var passedExams = 0
                teams.forEach({ (i) in
                    if i["validated?"] as? Int == 1 {
                        passedExams += 1
                    }
                })
                completion(passedExams)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    public func getProfile(user: String, completion: @escaping (ProfileInfo) -> ()) {
        guard let url = NSURL(string: apiURL+"v2/users/"+user) else { return print("url Error")}
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return print("data error") }
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                print("🏋️‍♀️\n", json ?? "nil")
                let profileInfo = try JSONDecoder().decode(ProfileInfo.self, from: data)
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
        
        let urlString = API.shared.apiURL+"v2/users?search[login]=\(inputText)&sort=login"
        guard let url = NSURL(string: urlString) else { return }
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
