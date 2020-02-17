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
    let name, guidelines: String?
}


// MARK: - Translate
struct Translate: Codable {
    let sentences: [Sentence]?
}

// MARK: - Sentence
struct Sentence: Codable {
    let trans, orig: String?
}


// MARK: - Welcome
struct TranslationJSON: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [Translation]?
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String?
}
