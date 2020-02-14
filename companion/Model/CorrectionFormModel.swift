//
//  CorrectionFormModel.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/14/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

// MARK: - CorrectionForm
struct CorrectionForm: Codable {
    let questionsWithAnswers: [QuestionsWithAnswer]?

    enum CodingKeys: String, CodingKey {
        case questionsWithAnswers = "questions_with_answers"
    }
}

// MARK: - QuestionsWithAnswer
struct QuestionsWithAnswer: Codable {
    let id: Int?
    let name, guidelines: String?
    let rating: Rating?
    let kind: Kind?

    enum Kind: String, Codable {
        case bonus = "bonus"
        case standard = "standard"
    }

    enum Rating: String, Codable {
        case bool = "bool"
        case multi = "multi"
    }
}


// MARK: - Welcome
struct Translate: Codable {
    let code: Int?
    let lang: String?
    let text: [String]?
}
