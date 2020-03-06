//
//  AlamofireAPI.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 3/3/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import Alamofire

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

private enum ListOfURL: String {
    case getToken = "https://api.intra.42.fr/oauth/token/"
    case timeLog = "https://api.intra.42.fr/v2/locations/?page[size]=100&user_id="
}

class API2 {
    
    public enum ListOfURL: String {
        case getToken = "v2/user/"
        case timeLog = "v2/locations/?page[size]=100&user_id="
    }
    
    public func getInfo(url: ListOfURL, param: String, returnData: @escaping (Any?) -> ()) {
        
        let requestResponser = RequestResponser(additionalLink: url.rawValue)
        
        switch url {
        case .getToken:
            requestResponser.makeRequest(param, returnType: Token.self) { (result) in
                returnData(result)
            }
        case .timeLog:
            requestResponser.makeRequest(param, returnType: TimeLog.self) { (result) in
                returnData(result)
            }
        }
    }
}

class RequestResponser {
    private let apiURL = "https://api.itra"
    private let additionalLink: String
    
    init(additionalLink: String) {
        self.additionalLink = additionalLink
    }
    
    private func createLink(params: String) -> NSMutableURLRequest? {
        let urlString = apiURL + additionalLink + params
        guard let url = NSURL(string: urlString) else { return nil }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("Bearer " + "key", forHTTPHeaderField: "Authorization")
        return request
    }
    
    public func makeRequest<T: Decodable>(_ params: String, returnType: T.Type, completion: @escaping (T?) -> ()) {
        guard let request = createLink(params: params) else { return }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let projectDecode = try JSONDecoder().decode(returnType.self, from: data)
                
                completion(projectDecode)
            } catch {
                print("Error. API. getDataOfProject\n", error.localizedDescription)
                print("data -", String(data: data, encoding: .ascii) ?? "nil")
                completion(nil)
                return
            }
        }.resume()
    }
}
