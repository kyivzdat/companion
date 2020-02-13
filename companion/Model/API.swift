//
//  API.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 10/25/19.
//  Copyright © 2019 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import CoreData
import AuthenticationServices
import RealmSwift

// MARK: - TODO Requests
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
    
    //MARK: - Refresh Token
    public func refreshToken(completion: @escaping () -> ()) {
        
        print("REFRESH TOKEN")
        guard let tokenDB = realm.objects(Token.self).first else { return print("Guard. API. refreshToken(). no Token") }
        
        makeTokenRequest(tokenDB: tokenDB, preAccessToken: "") {
            completion()
        }
    }
    
    // MARK: - Token Request
    func makeTokenRequest(tokenDB: Token?, preAccessToken: String, completion: @escaping () -> ()) {
        
        print("makeTokenRequest")
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
    
    // MARK: - Save Token In DB
    private func saveTokenInDB(tokenModel: Token, tokenSavedInDB tokenDB: Token?, completion: @escaping() -> ()) {
        
        print("saveTokenInDB")
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
        print("😛fetchAccessTokenFromDB😛")
        
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
        
        print("access_token =", bearer)
        print("getProfileInfo")
        
        let login = (userLogin == "me") ? userLogin : "users/" + userLogin
        
        guard let url = NSURL(string: apiURL+"/v2/"+login) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return print("Error. getProfileInfo. no data") }
            do {
                var userData = try JSONDecoder().decode(UserData.self, from: data)
                
                // Get exams Info
                let examsId = 11
                if let indexOfExamInArray = userData.projectsUsers?.firstIndex(where: { $0.project?.id == examsId }), let indexOfExamProject = userData.projectsUsers?[indexOfExamInArray].id {
                    self.getDataOfProject(projectID: indexOfExamProject) { (passedExams) in
                        userData.projectsUsers?[indexOfExamInArray] = passedExams
                        completion(.success(userData))
                    }
                }
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    // MARK: - Get Data of Project
    public func getDataOfProject(projectID: Int, completion: @escaping(ProjectsUser) -> ()) {
        print("🤪getDataOfProject🤪")
        
        let urlString = API.shared.apiURL+"/v2/projects_users/" + String(projectID)
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
        print("🤪getGeneralInfoOfProject🤪")
        
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
    
    // MARK: - Save User Info To DB
    private func saveNewUserToDB(myInfo: UserData, completion: @escaping() -> ()) {
        //
        //        print("SAVE NEW USER TO DB\n")
        //        let profileInfoDB = ProfileInfoDB(context: context)
        //
        //        guard let corPoints = myInfo.correction_point,
        //            let id = myInfo.id,
        //            let wallet = myInfo.wallet,
        //            let passedExams = myInfo.passedExams
        //            else { return }
        //
        //        // Main info
        //        profileInfoDB.login = myInfo.login
        //        profileInfoDB.first_name = myInfo.first_name
        //        profileInfoDB.last_name = myInfo.last_name
        //        profileInfoDB.id = Int32(id)
        //        profileInfoDB.correction_point = Int16(corPoints)
        //        profileInfoDB.image_url = myInfo.image_url
        //        profileInfoDB.location = myInfo.location
        //        profileInfoDB.passedExams = Int16(passedExams)
        //        profileInfoDB.wallet = Int16(wallet)
        //
        //        // Campus
        //        let campusDB = CampusDB(context: context)
        //        guard let campus = myInfo.campus.first,
        //            let campusId = campus?.id
        //            else { return }
        //        campusDB.address = campus?.address
        //        campusDB.city = campus?.city
        //        campusDB.country = campus?.country
        //        campusDB.facebook = campus?.facebook
        //        campusDB.website = campus?.website
        //        campusDB.id = Int16(campusId)
        //        profileInfoDB.campus = campusDB
        //
        //        // Cursus users <- Skills
        //        let cursusUsers = myInfo.cursus_users
        //        cursusUsers.forEach { (cursus) in
        //            let cursusUsersDB = CursusUsersDB(context: context)
        //
        //            guard let cursus_id = cursus?.cursus_id,
        //                let level = cursus?.level
        //                else { return }
        //            cursusUsersDB.cursus_id = Int16(cursus_id)
        //            cursusUsersDB.level = level
        //
        //
        //            guard let skills = myInfo.cursus_users[0]?.skills else { return }
        //            skills.forEach { (skill) in
        //                let skillsDB = SkillsDB(context: context)
        //
        //                guard let skillId = skill?.id,
        //                    let skillLevel = skill?.level
        //                    else { return }
        //
        //                skillsDB.id = Int16(skillId)
        //                skillsDB.level = skillLevel
        //                skillsDB.name = skill?.name
        //
        //                cursusUsersDB.addToSkills(skillsDB)
        //            }
        //            profileInfoDB.addToCursusUsers(cursusUsersDB)
        //        }
        //
        //        // Project Users
        //        let projectUsers = myInfo.projects_users
        //        projectUsers.forEach { (project) in
        //            let projectDB = ProjectUsersDB(context: context)
        //
        //            projectDB.name = project?.project?.name
        //            projectDB.slug = project?.project?.slug
        //            projectDB.status = project?.status
        //
        //            if let mark = project?.final_mark {
        //                projectDB.final_mark = Int16(mark)
        //            } else {
        //                projectDB.final_mark = -1
        //            }
        //            if let parent_id = project?.project?.parent_id {
        //                projectDB.parent_id = Int16(parent_id)
        //            } else {
        //                projectDB.parent_id = -1
        //            }
        //            if let validated = project?.validated {
        //                projectDB.validated = validated == 0 ? false : true
        //            } else {
        //                projectDB.validated = false
        //            }
        //
        //            profileInfoDB.addToProjectUsers(projectDB)
        //
        //        }
        //
        //        do {
        //            try context.save()
        //            print("Success to save myInfo first time! 👍")
        //            completion()
        //        } catch {
        //            print("Fail to save myInfo first time! 👎", error)
        //        }
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


extension API {
    //MARK: - Get Slots
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
