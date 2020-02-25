//
//  42API.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import CoreData
import AuthenticationServices
import RealmSwift

/*
 https://api.intra.42.fr/v2/projects/29/ <- descriptions
 https://api.intra.42.fr/v2/scale_teams?project_id=fdf&filter[team_id]=2734068 <- correction form + feedbacks
 https://api.intra.42.fr/v2/projects_users/1504871/ <- teams
 https://api.intra.42.fr/v2/users/vyunak/locations?page[size]=100 <- logtime
 */

class API {
    
    static let shared = API()
    
    var webAuthSession: ASWebAuthenticationSession?
    private let apiURL = "https://api.intra.42.fr/"
    private let callbackURI = "companion://companion"
    private let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    private let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    private var bearer = ""
    
    lazy var realm = try! Realm()
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    private init() {}
}

extension API {
    
    // MARK: - Authorization
    func authorization(urlContext: Any?, completion: @escaping () -> ()) {
        print("AUTHORIZATION")
        
        let clientID    = "client_id=" + UID
        let redirectURI = "&redirect_uri=" + callbackURI
        let scope       = "scope=public+forum+projects+profile+elearning+tig"
        
        guard let url   = URL(string: apiURL + "oauth/authorize?" + clientID + redirectURI + "&response_type=code&" + scope) else { return print("bad url")}

        webAuthSession = ASWebAuthenticationSession(url: url,
                                                    callbackURLScheme: callbackURI,
                                                    completionHandler:
            { (url, error) in
                guard error == nil else { return print(error!)}
                
                guard let url = url, let urlQuery = url.query else { return print("Error. API. makeAuthReqeust()")}
                
                print("🍏 url", url)
                
                // Get Token
                self.makeTokenRequest(tokenDB: nil, preAccessToken: urlQuery) {
                    completion()
                }
        })
        
        if #available(iOS 13.0, *), let urlContext = urlContext as? ASWebAuthenticationPresentationContextProviding {
            self.webAuthSession?.presentationContextProvider = urlContext
        }
        
        webAuthSession?.start()
    }
    
    // MARK: - Token Request
    private func makeTokenRequest(tokenDB: Token?, preAccessToken: String, completion: @escaping () -> ()) {
        
//        print("makeTokenRequest")
        guard let url = NSURL(string: apiURL+"oauth/token") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        // httpBody
        let grantType = "grant_type=" + ((tokenDB == nil) ? "authorization_code" : "refresh_token")
        var httpBody = grantType + "&client_id=\(UID)" + "&client_secret=\(secret)"
        
        if tokenDB == nil {
            httpBody += "&redirect_uri=\(callbackURI)&" + preAccessToken
        } else {
            httpBody += "&refresh_token=\(tokenDB?.refresh_token ?? "")"
        }
        
        request.httpBody = httpBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil else { return print(error!) }
            
            guard let data = data else { return }
            let message = (preAccessToken == "") ? " to refresh token! " : " to save new token! "
            do {
                
                let tokenModel = try JSONDecoder().decode(Token.self, from: data)

                self.saveTokenInDB(tokenModel: tokenModel, tokenSavedInDB: tokenDB) {
                    print("Success\(message)👍")
                    completion()
                }
            } catch {
                print("Fail\(message)👎\n", error)
            }
        }.resume()
    }
    
    //MARK: - Refresh Token
        public func refreshToken(completion: @escaping () -> ()) {
            
    //        print("REFRESH TOKEN")
            guard let tokenDB = realm.objects(Token.self).first else { return print("Guard. API. refreshToken(). no Token") }
            
            makeTokenRequest(tokenDB: tokenDB, preAccessToken: "") {
                completion()
            }
        }
    
    // MARK: - Save Token In DB
    private func saveTokenInDB(tokenModel: Token, tokenSavedInDB tokenDB: Token?, completion: @escaping() -> ()) {
        
//        print("saveTokenInDB")
        guard let accessToken = tokenModel.access_token,
            tokenModel.created_at != 0,
            tokenModel.expires_in != 0 else { return print("Guard. API. saveTokenInDB() bad values in JSON") }
        
        self.bearer = accessToken
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    if let tokenAlreadySavedInDB = tokenDB {
                        
                        tokenAlreadySavedInDB.refresh_token = tokenModel.refresh_token
                        tokenAlreadySavedInDB.access_token = tokenModel.access_token
                        tokenAlreadySavedInDB.created_at = tokenModel.created_at
                        tokenAlreadySavedInDB.expires_in = tokenModel.created_at + 7200
                    } else {
                        self.realm.add(tokenModel)
                    }
                    completion()
                }
            } catch {
                print("Fail to save token! 👎", error)
            }
        }
    }
    
    // MARK: - Fetch AccessToken From DB
    private func fetchAccessTokenFromDB() -> Bool {
//        print("😛fetchAccessTokenFromDB😛")
        
        guard let token = realm.objects(Token.self).first, let accessToken = token.access_token else {
            print("Error. API. fetchAccessTokenFromDB(). no token")
            return false
        }
        self.bearer = accessToken

        return true
    }
    
    // MARK: - Get Profile Info
    public func getProfileInfo(userLogin: String, completion: @escaping (Result<UserData, Error>) -> ()) {
        
        
        if self.bearer == "" {
            guard fetchAccessTokenFromDB() else { return }
        }
        
        print("access_token =", self.bearer)
//        print("getProfileInfo")
        
        let login = (userLogin == "me") ? userLogin : "users/" + userLogin
        
        guard let url = NSURL(string: apiURL+"/v2/"+login) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard let data = data else { return print("Error. getProfileInfo. no data\n", error.debugDescription) }
            do {
                var userData = try JSONDecoder().decode(UserData.self, from: data)
                
                // Get exams Info
                let examsId = 11
                if let indexOfExamInArray = userData.projectsUsers?.firstIndex(where: { $0.project?.id == examsId }),
                    let indexOfExamProject = userData.projectsUsers?[indexOfExamInArray].id {
                    
                    self.getDataOfProject(projectID: indexOfExamProject) { (passedExams) in
                        userData.projectsUsers?[indexOfExamInArray] = passedExams
                        completion(.success(userData))
                    }
                } else {
                    completion(.success(userData))
                }
            } catch {
                print("Error. API. getProfileInfo()\n", error)
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    // MARK: - Get Data of Project
    public func getDataOfProject(projectID: Int, completion: @escaping(ProjectsUser) -> ()) {
//        print("🤪getDataOfProject🤪")
        
        let urlString = apiURL+"/v2/projects_users/" + String(projectID)
        guard let url = NSURL(string: urlString) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let projectDecode = try JSONDecoder().decode(ProjectsUser.self, from: data)
                
                completion(projectDecode)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    // MARK: - getGeneralInfoOfProject
    public func getGeneralInfoOfProject(projectID: Int, completion: @escaping(ProjectInfo) -> ()) {
//        print("🤪getGeneralInfoOfProject🤪")
        
        let urlString = API.shared.apiURL+"/v2/projects/" + String(projectID)
        guard let url = NSURL(string: urlString) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let projectDecode = try JSONDecoder().decode(ProjectInfo.self, from: data)
                
                completion(projectDecode)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    // MARK: - GetCorrectionForm
    func getCorrectiomForm(_ projectID: Int, completion: @escaping(CorrectionForm?) -> ()) {

        let urlString = API.shared.apiURL+"/v2/scale_teams?project_id=" + String(projectID)
        guard let url = NSURL(string: urlString) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let projectsDecode = try JSONDecoder().decode([CorrectionForm].self, from: data)
                
                var result: CorrectionForm? = nil
                for oneForm in projectsDecode {
                    guard oneForm.questionsWithAnswers?.isEmpty == false else { continue }
                    result = oneForm
                    break
                }
                completion(result)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
   
    // MARK: - getRangeProfiles
    public func getRangeProfiles(inputText: String, completion: @escaping ([String]?) -> ()) {
        
        struct ParseProfile: Decodable {
            var login: String?
        }
        
        let urlString = API.shared.apiURL+"v2/users?search[login]=\(inputText)&sort=login"
        guard let url = NSURL(string: urlString) else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let profiles = try JSONDecoder().decode([ParseProfile].self, from: data)
                let result = profiles.map { $0.login ?? "" }
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print("error getRangeProfile\n\t", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
        }.resume()
    }

    //MARK: - Get Slots
    public func getSlots(fromPage page: Int, completion: @escaping ([Slot]?) -> ()) {
        guard let url = NSURL(string: apiURL+"/v2/me/slots?page[size]=100&page[number]=" + String(page)) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                var slotsForDecode = try JSONDecoder().decode([Slot].self, from: data)
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                    
                    for index in 0..<slotsForDecode.count {
                        
                        if json[index]["scale_team"] is NSNull {
                            slotsForDecode[index].scaleTeam = nil
                        } else {
                            slotsForDecode[index].scaleTeam = ScaleTeam(beginAt: nil, correcteds: nil, corrector: nil)
                        }
                    }
                }

                completion(slotsForDecode)
            } catch {
                print("Error. getSlots\n", error)
                completion(nil)
            }
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
            } catch {
                print("getToken error:\n", error)
            }
        }.resume()
    }
    
    // MARK: - getTimeLog
    public func getTimeLog(_ login: String, page: Int, completion: @escaping ([TimeLog]?) -> ()) {

        guard let url = URL(string: apiURL+"v2/users/\(login)/locations?page[size]=100&page[number]=\(page)") else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("Bearer "+bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard let data = data else {
                print(error!)
                completion(nil)
                return
            }
            
            do {
                let timeLog = try JSONDecoder().decode([TimeLog].self, from: data)
                
                DispatchQueue.main.async {
                    completion(timeLog)
                }
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}
