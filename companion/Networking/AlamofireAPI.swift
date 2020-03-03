//
//  AlamofireAPI.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 3/3/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import Alamofire

private enum ListOfURL: String {
    case getToken = "https://api.intra.42.fr/oauth/token/"
    case timeLog = "https://api.intra.42.fr/v2/locations/?page[size]=100&user_id="
}

class AlamofireAPI {
    
    static let shared = AlamofireAPI()
    
    private let apiURL = "https://api.intra.42.fr/"
    private let callbackURI = "companion://companion"
    private let UID = "c6bf10526718c927bf3cd119bbb2a97a57903eeb20f628d4f866bb97da883459"
    private let secret = "b95586661d5459b68736e33d0e2397f1c8e03b234d5ae0f9bc9313ad2ff6e6d4"
    private var bearer: String? = nil
    
    private init() {}
    
    func getToken() {
        
        let url = ListOfURL.getToken.rawValue
        let parameters = ["grant_type"      : "client_credentials",
                          "client_id"       : UID,
                          "client_secret"   : secret]
        
        AF.request(url, method: .post, parameters: parameters).responseData { (result) in
            guard let data = result.data else { return print(result.error ?? "") }
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                self.bearer = token.access_token
            } catch {
                print("Error. AlamofireAPI. getToken\n", error)
            }
        }
    }
    
    func getTimeLog(ofUser login: String, pageOfRequest page: Int, completion: @escaping ([TimeLog]?) -> ()) {
        
        let url = ListOfURL.timeLog.rawValue + login + "&page[number]=\(page)"
        
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(bearer ?? "")"]
        
        AF.request(url, headers: headers).responseData { (result) in
            guard let data = result.data else {
                print(result.error ?? "")
                completion(nil)
                return
            }
            
            do {
                let timeLog = try JSONDecoder().decode([TimeLog].self, from: data)
                completion(timeLog)
            } catch {
                print("Error. AlamofireAPI. getTimeLog\n", error)
                completion(nil)
            }
        }
    }
}
