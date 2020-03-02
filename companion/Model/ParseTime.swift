//
//  ParseTime.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/25/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import UIKit

enum TimeDefinition: Int {
    case lastWeek    = 8 // current day not included
    case last3Months = 90
}

struct SecondsForDay {
    let date:    Date!
    let dayStr:  String!
    var seconds: Double = 0
}

class ParseTime {
    
    private var stopTime = Double()
    
    // MARK: - getLogTime
    func getLogTime(of timeRange: TimeDefinition, login: String, returnWeekTime: ((CGFloat?) -> ())? = nil, returnMonthsTime: ((([Int : [SecondsForDay]])?) -> ())? = nil) {
        
        defineStopTime(timeRange)
        
        makeRequestForTimeLog(login) { (timeLog) in
            DispatchQueue.main.async {
                guard let timeLog = timeLog else {
                    returnWeekTime?(nil)
                    returnMonthsTime?(nil)
                    return
                }
                switch timeRange {
                case .lastWeek:
                    // Dropped first, because current day doesnt may be included
                    let timeArray = Array(timeLog.map( { $0.seconds }).dropFirst())
                    let timeSum = timeArray.reduce(0, +)
                    returnWeekTime?(CGFloat(timeSum / 60 / 60))
                case .last3Months:
                    let splittedTimeLog = self.splitTimeByMonths(timeLog)
                    returnMonthsTime?(splittedTimeLog)
                }
            }
        }
    }
    
    private func splitTimeByMonths(_ timeLog: [SecondsForDay]) -> [Int : [SecondsForDay]] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.timeZone = TimeZone.current
        
        var result: [Int : [SecondsForDay]] = [:]
        var monthCounter = 0
        var prevMonth = ""
        for day in timeLog {
            
            let date = dateFormatter.string(from: day.date)
            
            if result.isEmpty {
                prevMonth = date
                result[monthCounter] = [day]
                continue
            }
            
            if prevMonth == date {
                result[monthCounter]?.append(day)
            } else {
                monthCounter += 1
                prevMonth = date
                result[monthCounter] = [day]
            }
        }
        return result
    }
    
    // MARK: - defineStopTime
    private func defineStopTime(_ timeDefinition: TimeDefinition) {
        
        switch timeDefinition {
        case .lastWeek:
            let numberOfDays = timeDefinition.rawValue * (24 * 60 * 60) // convert in seconds
            stopTime = Date().timeIntervalSince1970 - Double(numberOfDays)
        case .last3Months:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            var curDate = dateFormatter.string(from: Date())
            guard let rangeForDay = "00".range(of: "00"),
                let rangeForMonth = "00-11".range(of: "11") else { return }
            
            dateFormatter.dateFormat = "MM"
            var stopMonth = ""
            guard let month = Int(dateFormatter.string(from: Date())) else { return }
            
            stopMonth = String((month - 3) % 12 + 1)
            stopMonth = stopMonth.count == 1 ? "0" + stopMonth : stopMonth
            
            curDate.replaceSubrange(rangeForDay, with: "01")
            curDate.replaceSubrange(rangeForMonth, with: stopMonth)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let stopTimeDate = dateFormatter.date(from: curDate) {
                stopTime = stopTimeDate.timeIntervalSince1970
            }
        }
    }
    
    // MARK: - makeRequestForTimeLog
    private func makeRequestForTimeLog(_ login: String, completion: @escaping ([SecondsForDay]?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var managedTimeLog: [SecondsForDay] = []
            
            for pageNumber in 1...10 {
                print("page number =", pageNumber)
                
                var rowTimeLog: [TimeLog] = []
                API.shared.getTimeLog(login, page: pageNumber) { (timeLogs) in
                    if timeLogs == nil || timeLogs?.isEmpty == true {
                        completion(nil)
                    }
                    rowTimeLog = timeLogs ?? []
                    
                    semaphore.signal()
                }
                let _ = semaphore.wait(timeout: .distantFuture)
                
                if let timeLog = self.getHoursForEachDay(fromTimeLogs: rowTimeLog) {
                    
                    managedTimeLog += timeLog.time
                    guard timeLog.isFinished == false else {
                        completion(managedTimeLog)
                        break
                    }
                } else {
                    completion(nil)
                    break
                }
            }
        }
    }
    
    // MARK: - getHoursSumma
    private func getHoursSumma(from weekTime: [SecondsForDay]) -> Double {
        var summa: Double = 0
        
        for index in 0..<weekTime.count {
            guard index > 0 else { continue }
            summa += weekTime[index].seconds
        }
        return summa
    }
    
    // MARK: - getHoursForEachDay
    private func getHoursForEachDay(fromTimeLogs timeLogs: [TimeLog]) -> (time: [SecondsForDay], isFinished: Bool)? {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        var resultTimeLog: [SecondsForDay] = []
        
        var prevDate: Date? = nil
        for timeLog in timeLogs {

            guard let dayDate = getOnlyDay(fromString: timeLog.beginAt)
                else { return nil }
            
            // Check if we have reached all days
            guard dayDate.timeIntervalSince1970 > stopTime else {
                return (resultTimeLog, true)
            }
            
            guard
                let beginAt = timeLog.beginAt?.split(separator: ".").first,
                let beginTime = getDateFormatter.date(from: String(beginAt)) else { return nil }
            
            let beginTimeWithInterval = Double(beginTime.timeIntervalSince1970)
            let dayStr = getDateFormatter.string(from: dayDate)
            
            // If first iteration
            if prevDate == nil {
                
                let time = Date().timeIntervalSince1970 - beginTimeWithInterval - Double(TimeZone.current.secondsFromGMT())
                
                let newDate = SecondsForDay(
                    date: dayDate,
                    dayStr: dayStr,
                    seconds: time)
                resultTimeLog.append(newDate)
                prevDate = dayDate
                continue
            }
            
            guard
                let endAt = timeLog.endAt?.split(separator: ".").first,
                let endTime = getDateFormatter.date(from: String(endAt)) else { return nil }
            
            let endTimeWithInterval = endTime.timeIntervalSince1970
            // if it is the same day (several logs)
            if prevDate == dayDate {
                
                let timeOfRange = endTimeWithInterval - beginTimeWithInterval
                resultTimeLog[resultTimeLog.endIndex - 1].seconds += timeOfRange
            // if it is another day
            } else {
                
                prevDate = dayDate
                let timeOfRange = endTimeWithInterval - beginTimeWithInterval
                let newDate = SecondsForDay(
                    date: dayDate,
                    dayStr: dayStr,
                    seconds: timeOfRange)
                resultTimeLog.append(newDate)
            }
        }
        return (resultTimeLog, false)
    }
    
    /*
    String 2020-02-22T19:41:27.000Z
    String 2020-02-22T19:41:27
    DATE   2020-02-22T21:41:27
    String 2020-02-22
    DATE   2020-02-22
    */
    
    // MARK: - getOnlyDay
    private func getOnlyDay(fromString string: String?) -> Date? {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        getDateFormatter.timeZone = TimeZone.current
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let beginAtTimeLog = String(string?.split(separator: ".").first ?? "")
        guard let beginDateTimeLog = getDateFormatter.date(from: beginAtTimeLog)
            else { return nil }
        
        let dayTimeLog = dayDateFormatter.string(from: beginDateTimeLog)
        if let dayDateTimeLog = dayDateFormatter.date(from: dayTimeLog) {
            return dayDateTimeLog
        }
        return nil
    }
}
