//
//  CorrectionFormTVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/17/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

// TODO: - Make copy text by long press

class CorrectionFormTVC: UITableViewController {
    
    var projectID: Int!
    // Delay, cuz requests are overlap
    var delay: Int!
    
    private var questionsWithAnswer: [QuestionsWithAnswer] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Correction Form"
        getQuestionsWithAnswer()
    }
    
    private func getQuestionsWithAnswer() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        var questionsArray:         [String] = []
        var questionsNameArray:     [String] = []
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .seconds(delay)) {
            
            let semaphore = DispatchSemaphore(value: 0)
            API.shared.getCorrectiomForm(self.projectID) { (correctionsForm) in
                if let questions = correctionsForm?.questionsWithAnswers {
                    
                    questions.forEach { (question) in
                        questionsNameArray.append(question.name ?? "")
                        questionsArray.append(question.guidelines ?? "")
                    }
                }
                semaphore.signal()
            }
            let _ = semaphore.wait(timeout: .distantFuture)
            
            let language = "uk"
            GoogleAPI.shared.getTranslation(language: language, text: questionsNameArray) { (names) in
                GoogleAPI.shared.getTranslation(language: language, text: questionsArray) { (questions) in
                    
                    guard names.count == questions.count else { return print("Not equal amount") }

                    for i in 0..<names.count {
                        let name = names[i]
                        let question = questions[i]
                        let newStruct = QuestionsWithAnswer(name: name, guidelines: question)
                        self.questionsWithAnswer.append(newStruct)
                        
                        DispatchQueue.main.async {
                            activityIndicator.isHidden = true
                            activityIndicator.stopAnimating()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                }
            }
        }
    }
}

extension CorrectionFormTVC {
    // MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsWithAnswer.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "correctionCell", for: indexPath) as? CorrectionFormCell else { return UITableViewCell() }
        
        if let title = questionsWithAnswer[indexPath.row].name, let guidelines = questionsWithAnswer[indexPath.row].guidelines {
            
            cell.fillQACell(title: title, question: guidelines)
        }
        
        return cell
    }
}

