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

class API {
    
    static let shared = API()
    
    var webAuthSession: ASWebAuthenticationSession?
    private let apiURL = "https://api.intra.42.fr/"
    private let callbackURI = "companion://companion"
    private let UID = "c18f981eb10b97d638b8ecffa09a536e55d96a145895d3217234205f1a1682b6"
    private let secret = "2dc221791978c281af5bf914f3b690d66feea3469c79d1a8d3c217b23531f402"
    private var bearer = ""
    
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
        let fetchRequest: NSFetchRequest<TokenDB> = TokenDB.fetchRequest()
        do {
            let tokenArray = try context.fetch(fetchRequest)
            guard let token = tokenArray.first else { return }

            self.makeTokenRequest(tokenDB: token, preAccessToken: "") {
                completion()
            }
        } catch {
            print(error)
            return
        }
    }
    
    // MARK: - Token Request
    func makeTokenRequest(tokenDB: TokenDB?, preAccessToken: String, completion: @escaping () -> ()) {
        
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
            httpBody += "&refresh_token=\(tokenDB?.refreshToken ?? "")"
        }
        
        request.httpBody = httpBody.data(using: .utf8)
        
        guard let tokenDB = (tokenDB == nil) ? TokenDB(context: context) : tokenDB else { return print("Error. makeTokenRequest") }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard error == nil else { return print(error!) }
            
            guard let data = data else { return }
            do {
                
                let tokenModel = try JSONDecoder().decode(Token.self, from: data)
                
                DispatchQueue.main.async {
                    self.saveTokenInDB(tokenModel: tokenModel, tokenSaveInDB: tokenDB) {
                        print(preAccessToken == "" ?
                            "Success to refresh token! 👍" : "Success to save new token! 👍")
                        completion()
                    }
                }
            } catch {
                let message = preAccessToken == "" ?
                    "Fail to refresh token! 👎\n" : "Fail to save new token! 👎\n"
                print(message, error)
            }
        }.resume()
    }
    
    // MARK: - Save Token In DB
    private func saveTokenInDB(tokenModel: Token, tokenSaveInDB tokenDB: TokenDB, completion: @escaping() -> ()) {
        
        guard let access = tokenModel.access_token,
            let refresh = tokenModel.refresh_token,
            let created = tokenModel.created_at else { return }
        
        print("access_token =", access)
        
        self.bearer = access
        tokenDB.accessToken = access
        tokenDB.refreshToken = refresh
        tokenDB.createdAt = created
        tokenDB.expiresIn = created + 7200
        
        do {
            try self.context.save()
            print("Success save token! 👍")
            completion()
        } catch {
            print("Fail to save token! 👎", error)
        }
    }
    
    // MARK: - Get Info
    public func getProfileInfo(userLogin: String, completion: @escaping (Result<UserData, Error>) -> ()) {

        let login = (userLogin == "me") ? userLogin : "users/" + userLogin
        
        guard let url = NSURL(string: apiURL+"/v2/"+login) else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                var userData = try JSONDecoder().decode(UserData.self, from: data)
                
                let examsId = "11"
                self.getDataOfProject(id: examsId, userID: userData.id!, completion: { (passedExams) in
//                    DispatchQueue.main.async {
                        guard let passedExams = passedExams.first else { return print("Error. API. getProfileInfo(). No data of exams") }
                        if let index = userData.projectsUsers?.firstIndex(where: { $0.project?.id == 11 }) {
                            userData.projectsUsers?[index] = passedExams
                        }
                        completion(.success(userData))
//                    }
                })
            } catch {
                completion(.failure(error))
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
    
    
    // MARK: - Get Data of Project
    public func getDataOfProject(id: String, userID: Int, completion: @escaping([ProjectsUser]) -> ()) {
        let urlString = API.shared.apiURL+"/v2/projects_users?filter[project_id]=\(id)&user_id=\(userID)"
        guard let url = NSURL(string: urlString) else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + API.shared.bearer, forHTTPHeaderField: "Authorization")
        print("🤪getDataOfProject🤪")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let projectDecode = try JSONDecoder().decode([ProjectsUser].self, from: data)

                completion(projectDecode)
            } catch {
                print(error.localizedDescription)
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
