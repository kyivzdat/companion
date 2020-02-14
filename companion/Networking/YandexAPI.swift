//
//  YandexAPI.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/14/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

class YandexAPI {
    
    static let shared = YandexAPI()
    
    private let url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20200214T193935Z.2b69aedc254ee642.bd88f2dca96839e299b456b6d17354d6c284bb1e"
    
    private init() {}
}

extension YandexAPI {
    
    func getTranslation(language: String, text: [String], completion: @escaping ([String]?) -> ()) {
        print("getTranslation")
        let lang = "&lang=" + language
        var urlString = url + lang
        
        text.forEach { (sentence) in
            urlString += "&text=" + sentence
        }
        var urlString2 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = NSURL(string: urlString2 ?? "") else { return print("bad url") }
        
        let request = NSMutableURLRequest(url: url as URL)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else { return }
            do {
                let text = try JSONDecoder().decode(Translate.self, from: data).text
                
                print("123")
                completion(text)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
}
