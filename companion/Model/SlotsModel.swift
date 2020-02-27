//
//  SlotsModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

// MARK: - Slot
struct Slot: Codable {
    let id: Int?
    var beginAt, endAt: String?
    var scaleTeam: ScaleTeam?
    
    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case scaleTeam
    }
}

// MARK: - ScaleTeam
struct ScaleTeam: Codable {
    let beginAt: String?
    let correcteds: [Correct]?
    let corrector: Correct?

    enum CodingKeys: String, CodingKey {
        case beginAt = "begin_at"
        case correcteds, corrector
    }
    
    struct Correct: Codable {
        let login: String?
    }
}



/*
[
    {
        "id": 34412041,
        "begin_at": "2020-02-18T18:15:00.000Z",
        "end_at": "2020-02-18T18:30:00.000Z",
        "scale_team": null,
        "user": {
            "id": 41821,
            "login": "vpalamar",
            "url": "https://api.intra.42.fr/v2/users/vpalamar"
        }
    }
]
 
 
 
 [
 {
     "id": 34412025,
     "begin_at": "2020-02-18T14:00:00.000Z",
     "end_at": "2020-02-18T14:15:00.000Z",
     "scale_team": {
         "id": 2471752,
         "scale_id": 654,
         "comment": null,
         "created_at": "2020-02-17T13:12:21.392Z",
         "updated_at": "2020-02-17T13:12:21.392Z",
         "feedback": null,
         "final_mark": null,
         "flag": {
             "id": 1,
             "name": "Ok",
             "positive": true,
             "icon": "check-4",
             "created_at": "2015-09-14T23:06:52.000Z",
             "updated_at": "2015-09-14T23:06:52.000Z"
         },
         "begin_at": "2020-02-18T13:45:00.000Z",
         "correcteds": [
             {
                 "id": 44557,
                 "login": "tbahlai",
                 "url": "https://api.intra.42.fr/v2/users/tbahlai"
             }
         ],
         "corrector": {
             "id": 41821,
             "login": "vpalamar",
             "url": "https://api.intra.42.fr/v2/users/vpalamar"
         },
         "truant": {},
         "filled_at": null,
         "questions_with_answers": []
     },
     "user": {
         "id": 41821,
         "login": "vpalamar",
         "url": "https://api.intra.42.fr/v2/users/vpalamar"
     }
 }
 ]
 
 
 
 
 [
 {
     "id": 34412025,
     "begin_at": "2020-02-18T14:00:00.000Z",
     "end_at": "2020-02-18T14:15:00.000Z",
     "scale_team": {
         "id": 2471752,
         "scale_id": 654,
         "comment": "🚀",
         "created_at": "2020-02-17T13:12:21.392Z",
         "updated_at": "2020-02-18T13:53:04.027Z",
         "feedback": null,
         "final_mark": 100,
         "flag": {
             "id": 1,
             "name": "Ok",
             "positive": true,
             "icon": "check-4",
             "created_at": "2015-09-14T23:06:52.000Z",
             "updated_at": "2015-09-14T23:06:52.000Z"
         },
         "begin_at": "2020-02-18T13:45:00.000Z",
         "correcteds": [
             {
                 "id": 44557,
                 "login": "tbahlai",
                 "url": "https://api.intra.42.fr/v2/users/tbahlai"
             }
         ],
         "corrector": {
             "id": 41821,
             "login": "vpalamar",
             "url": "https://api.intra.42.fr/v2/users/vpalamar"
         },
         "truant": {},
         "filled_at": "2020-02-18T13:53:04.000Z",
         "questions_with_answers": [
             {
                 "id": 7143,
                 "name": "Création du pod",
                 "guidelines": "- Vérifiez que le 'pod' est bien crée et avec le bon nom (\"loginYYYY\") avec un projet en example.",
                 "rating": "bool",
                 "kind": "standard",
                 "answers": [
                     {
                         "value": 1,
                         "answer": null
                     }
                 ]
             }
         ]
     },
     "user": {
         "id": 41821,
         "login": "vpalamar",
         "url": "https://api.intra.42.fr/v2/users/vpalamar"
     }
 }
 ]
*/
