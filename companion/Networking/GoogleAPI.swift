//
//  GoogleAPI.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/14/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

class GoogleAPI {
    
    static let shared = GoogleAPI()
    
    // MARK: - URL
    private let url = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAFDJwbRXA5_dlwJ267JVPmc0sFhNhIMGw&format=text"
    //    https://translation.googleapis.com/language/translate/v2?key=AIzaSyAFDJwbRXA5_dlwJ267JVPmc0sFhNhIMGw&target=uk&format=text
    private init() {}
}

extension GoogleAPI {
    
    
    // MARK: - getTranslation
    func getTranslation(language: String, text: [String], completion: @escaping ([String]) -> ()) {

        let lang = "&target=" + language
        let urlString = url + lang
        
        let urlStrings = splitLargeRequests(text: text, urlString: urlString)
        
        var resultArray = [String]()
        DispatchQueue.global(qos: .userInitiated).async {
            let semaphore = DispatchSemaphore(value: 0)
            
            for link in urlStrings {
                
                let urlString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                guard let url = URL(string: urlString ?? "") else { return print("bad url") }
                
                self.makeRequest(url) { result in
                    resultArray = (resultArray.isEmpty) ? result : resultArray + result
                    semaphore.signal()
                }
                let _ = semaphore.wait(timeout: .distantFuture)
            }
            completion(resultArray)
        }
    }
    
    // MARK: - splitLargeRequests
    private func splitLargeRequests(text: [String], urlString url: String) -> [String] {
        var urlStrings = [String]()
        
        text.forEach { (sentence) in
            let newSentence = deleteBadCharacters(fromString: sentence)
            if urlStrings.isEmpty {
                urlStrings.append(url)
            } else {
                let lastURLString = urlStrings[urlStrings.endIndex - 1]
                
                if lastURLString.count + newSentence.count < 5000 {
                    urlStrings[urlStrings.endIndex - 1] += "&q=" + newSentence
                } else {
                    urlStrings.append(url + "&q=" + newSentence)
                }
            }
        }
        
        return urlStrings
    }
    
    // MARK: - makeRequest
    private func makeRequest(_ url: URL, completion: @escaping ([String]) -> ()) {
        
        var result = [String]()
        
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            do {
                let text = try JSONDecoder().decode(TranslationJSON.self, from: data)
                
                if let translations = text.data?.translations {
                    
                    translations.forEach { (translate) in
                        result.append(translate.translatedText ?? "")
                    }
                }
                completion(result)
            } catch {
                print("Error. getTranslation\n\t", error.localizedDescription)
                completion([])
                return
            }
        }.resume()
    }
    
    // MARK: - deleteBadCharacters
    private func deleteBadCharacters(fromString string: String) -> String {
        var result = string
        
        let targetForDelete = ["$", "&", "&gt", "GT;", "\r", "<pre>", "</pre>", "<code>", "</code>"]
        
        targetForDelete.forEach{ (target) in
            if result.contains(target) {
                result = result.replacingOccurrences(of: target, with: "")
            }
        }
        
        result = result.replacingOccurrences(of: "#", with: "№")
        return result
    }
}


