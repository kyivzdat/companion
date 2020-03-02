//
//  MonthsVC.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CenteredCollectionView

class MonthsVC: UIViewController {
    
    private let weekday = [
        "Mon": 0,
        "Tue": 1,
        "Wed": 2,
        "Thu": 3,
        "Fri": 4,
        "Sat": 5,
        "Sun": 6,
    ]
    
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var monthsCV: UICollectionView!
    @IBOutlet private weak var constraintToEdge: NSLayoutConstraint!

    // Passed from prev VC
    var login: String!
    
    private let cellPercentWidth: CGFloat = 0.8
    private var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    private var timeLog: [Int : [SecondsForDay]] = [:]
    private var monthlyOffset:  [Int : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintToEdge.constant += 20
        setupCV()
        getMonthsTime() { logTime in
            self.timeLog = logTime
            self.getMonthlyOffset(logTime)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        constraintToEdge.constant = 0
        monthsCV.semanticContentAttribute = .forceLeftToRight
    }
    
    private func setupCV() {
        monthsCV.contentInsetAdjustmentBehavior = .never
        guard let centeredCVFlowLayout = monthsCV.collectionViewLayout as? CenteredCollectionViewFlowLayout else { return }

        centeredCollectionViewFlowLayout = centeredCVFlowLayout
        monthsCV.decelerationRate = UIScrollView.DecelerationRate.fast
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: monthsCV.frame.width * cellPercentWidth,
            height: monthsCV.frame.height * cellPercentWidth
        )

        // Configure the optional inter item spacing (OPTIONAL STEP)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        
        monthsCV.showsVerticalScrollIndicator = false
        monthsCV.showsHorizontalScrollIndicator = false

        monthsCV.dataSource = self
    }
    
    private func getMonthsTime(completion: @escaping ([Int : [SecondsForDay]]) -> ()) {
        
        ParseTime().getLogTime(of: .last3Months, login: login, returnWeekTime: nil) { (logTime) in
            guard var logTime = logTime else { return }
            // Swapped because collection view placed [1, 2, 0]
            let swap = logTime[0]
            logTime[0] = logTime[2]
            logTime[2] = swap
           
            completion(logTime)
        }
    }
    
    private func getMonthlyOffset(_ logTime: [Int : [SecondsForDay]]) {
        
        for i in 0...2 {
            guard let date = logTime[i]?.first?.date,
            let offset = getFirstWeekdayOfTheMonth(date) else { return }
            
            monthlyOffset[i] = offset
        }
    }
    
    private func getFirstWeekdayOfTheMonth(_ date: Date) -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        var curDate = dateFormatter.string(from: date)
        if let indexOfTwoCharacters = "00".range(of: "00") {
            curDate.replaceSubrange(indexOfTwoCharacters, with: "01")
        }
        
        if let firstDayDate = dateFormatter.date(from: curDate) {
            dateFormatter.dateFormat = "E"
            let firstDay = dateFormatter.string(from: firstDayDate)
            if let offset = weekday[firstDay] {
                return (offset + 1) % 7
            }
        }
        return nil
    }
}

extension MonthsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = monthsCV.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCVCell else { return UICollectionViewCell() }
        
        if let timeLog = timeLog[indexPath.row], let offset = monthlyOffset[indexPath.row] {
            cell.fillCalendar(secondsForDays: timeLog, offset: offset, hoursLabel: hoursLabel)
        }

        return cell
    }
}
