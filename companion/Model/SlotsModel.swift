//
//  SlotsModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/18/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

struct Slot: Codable {
    let id: Int?
    let beginAt, endAt: String?
    let scaleTeam: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case scaleTeam = "scale_team"
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
             },
             {
                 "id": 7147,
                 "name": "Class ArticleManager",
                 "guidelines": "- Vérifiez que la classe ArticleManager est bien présente\r\n- Elle doit contenir les méthodes suivantes ; newArticle(), getAllArticles(), getArticles(withLang), getArticles(containString), removeArticle(article) et save().\r\n- Ces methodes doivent etre fonctionnelles\r\n- Il y a un bien un NSManagedObjectContext qui utilise NSBundle ?",
                 "rating": "bool",
                 "kind": "standard",
                 "answers": [
                     {
                         "value": 1,
                         "answer": null
                     }
                 ]
             },
             {
                 "id": 7148,
                 "name": "ViewController",
                 "guidelines": "- Vérifiez quel'on a bien dans le ViewDidLoad la création de plusieurs articles\r\n- Lorsque vous lancez plusieurs fois l'application les anciens articles doivent persister et etre affiché.",
                 "rating": "bool",
                 "kind": "standard",
                 "answers": [
                     {
                         "value": 1,
                         "answer": null
                     }
                 ]
             },
             {
                 "id": 7144,
                 "name": "Podspec",
                 "guidelines": "- Vérifiez que le 'podspec' a bien une description, un résumé et contient bien le framework CoreData. Vous pouvez utiliser la commande `pod lib lint NOM_DU_POD`.\r\nLe seul warning autorisé est celui de l'URL. Si d'autres warnings sont présent ne mettez pas les points.",
                 "rating": "bool",
                 "kind": "standard",
                 "answers": [
                     {
                         "value": 1,
                         "answer": null
                     }
                 ]
             },
             {
                 "id": 7145,
                 "name": "xcdatamodeld",
                 "guidelines": "- Vérifiez qu'un fichier xcdatamodeld est bien présent.\r\n- Contient-il au moins : titre, content, langue, image, date de création et de modification.",
                 "rating": "bool",
                 "kind": "standard",
                 "answers": [
                     {
                         "value": 1,
                         "answer": null
                     }
                 ]
             },
             {
                 "id": 7146,
                 "name": "Class Article",
                 "guidelines": "- Vérifiez que la classe Article est bien présente dans le pod.\r\n- Elle doit contenir les attributs suivants : titre, content, langue, image, date de création et de modification.  \r\n- Les types demandés dans le sujet sont bien respecté ?",
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
