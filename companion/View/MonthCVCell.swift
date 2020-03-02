//
//  MonthCVCell.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CenteredCollectionView

class MonthCVCell: UICollectionViewCell {
    
    @IBOutlet weak var calendarCV:      UICollectionView!
    @IBOutlet weak var monthLabel:      UILabel!
    @IBOutlet weak var daysLabel:       UILabel!
    @IBOutlet weak var allHoursLabel:   UILabel!
    
    
    private var numberOfDays:   Int = 0
    private var offset:         Int = 0
    private var originOffset:   Int = 0
    private var secondsForDays: [SecondsForDay] = []
    private var timeLog:        [Int : SecondsForDay] = [:]
    private var hoursLabel:     UILabel!

    func fillCalendar(secondsForDays: [SecondsForDay], offset: Int, hoursLabel: UILabel) {

        self.secondsForDays = secondsForDays
        self.offset = offset
        self.originOffset = offset
        self.hoursLabel = hoursLabel
        guard let numberOfDays = getNumberOfDaysInMonth() else { return }
        defineDays()
        self.numberOfDays = numberOfDays
        
        monthLabel.text = getPrintMonth() ?? ""
        daysLabel.text = "Days: \(secondsForDays.count)"
        
        var seconds: Double = 0
        secondsForDays.forEach { (day) in
            seconds += day.seconds
        }
        allHoursLabel.text = convertHoursToPrint(seconds / 3600)
        
        calendarCV.delegate = self
        calendarCV.dataSource = self
    }
    
    private func getPrintMonth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMMM"
        
        guard let day = secondsForDays.first else { return nil}
        let month = dateFormatter.string(from: day.date)
        return month
    }
    
    private func defineDays() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        for day in secondsForDays {
            
            let dayStr = dateFormatter.string(from: day.date)
            if let dayNbr = Int(dayStr) {
                timeLog[dayNbr] = day
            }
        }
    }
    
    private func getNumberOfDaysInMonth() -> Int? {
        guard let day = secondsForDays.first else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = "MM"
        guard let month = Int(dateFormatter.string(from: day.date)) else { return nil }
        dateFormatter.dateFormat = "yyyy"
        guard let year = Int(dateFormatter.string(from: day.date)) else { return nil }
        
        let dateComponents = DateComponents(timeZone: .current, year: year, month: month)
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }
        
        let range = calendar.range(of: .day, in: .month, for: date)
        if let numDays = range?.count {
            return numDays
        }
        return nil
    }
    
    func convertHoursToPrint(_ hours: Double) -> String {
        let roundedHours = Int(hours)
        let minutes = Int((hours * 100 - Double(roundedHours * 100)) * 0.6)
        return "\(roundedHours)h\(minutes)"
    }
}


extension MonthCVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = collectionView.cellForItem(at: indexPath) as? CalendarCVCell else { return }
        
        if item.hours == -1 {
            return
        }
       
        hoursLabel.text = " " + convertHoursToPrint(item.hours) + " "
        
        hoursLabel.backgroundColor = .systemGray
        hoursLabel.layer.cornerRadius = 3
        
        hoursLabel.clipsToBounds = true
        
        self.hoursLabel.isHidden = false
        self.hoursLabel.alpha = 0
        UIView.animate(withDuration: 0.7, animations: {
            self.hoursLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.7) {
                self.hoursLabel.alpha = 0
            }
        }
    }
}

extension MonthCVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.width / 7 - 7
        return CGSize(width: size, height: size)
    }
}

extension MonthCVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfDays + offset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = calendarCV.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCVCell else { return UICollectionViewCell() }

        guard offset == 0 else {
            offset -= 1
            cell.backgroundColor = .clear
            cell.dateLabel.text = ""
            return cell
        }
        cell.backgroundColor = .systemGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let day = indexPath.row - originOffset + 1
        
        
        if let seconds = timeLog[day]?.seconds {
            
            
            
            let hours = seconds / 3600
            let alpha = CGFloat(1 - hours / 24)
            cell.backgroundColor = UIColor(
                displayP3Red: 0,
                green: 186,
                blue: 188,
                alpha: CGFloat(1 - hours / 24))
            cell.hours = hours
        }
        
        cell.dateLabel.text = String(day)
        
        
        return cell
    }
}
