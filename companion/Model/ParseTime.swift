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

class ParseTime {
    
    private struct TimeForDay {
        let day: Date!
        let dayStr: String!
        var time: Double = 0
    }
    
    var stopTime = Double()
    
    // MARK: - getLogTime
    func getLogTimeOf(_ timeRange: TimeDefinition, login: String, completion: @escaping (CGFloat?) -> ()) {
                
        let numberOfDays = timeRange.rawValue * (24 * 60 * 60) // convert in seconds
        stopTime = Date().timeIntervalSince1970 - Double(numberOfDays)
        
        makeRequestForTimeLog(login) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func makeRequestForTimeLog(_ login: String, completion: @escaping (CGFloat?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var rowTimeLog: [TimeLog] = []
            var timeSumma: Double = 0
            
            API.shared.getTimeLog(login, page: 1) { (timeLogs) in
                if timeLogs == nil || timeLogs?.isEmpty == true {
                    completion(nil)
                }
                rowTimeLog = timeLogs ?? []
        
                semaphore.signal()
            }
            let _ = semaphore.wait(timeout: .distantFuture)
            
            let weekTime = self.getHoursForEachDay(fromTimeLogs: rowTimeLog)
            if weekTime == nil {
                completion(nil)
            }

            timeSumma += self.getHoursSumma(from: weekTime!)
            completion(CGFloat(timeSumma / 60 / 60))

        }
    }
    
    private func getHoursSumma(from weekTime: [ParseTime.TimeForDay]) -> Double {
        var summa: Double = 0
        
        for index in 0..<weekTime.count {
            guard index > 0 else { continue }
            summa += weekTime[index].time
        }
        return summa
    }
    
    private func getHoursForEachDay(fromTimeLogs timeLogs: [TimeLog]) -> [TimeForDay]? {
        
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        var printTimeLog: [TimeForDay] = []
        
        var prevDate: Date? = nil
        for timeLog in timeLogs {

            guard let dayDate = getOnlyDay(fromString: timeLog.beginAt)
                else { return nil }
            
            // Check if we have reached all days
            guard dayDate.timeIntervalSince1970 > stopTime else { break }
            
            guard
                let beginAt = timeLog.beginAt?.split(separator: ".").first,
                let beginTime = getDateFormatter.date(from: String(beginAt)) else { return nil }
            
            let beginTimeWithInterval = Double(beginTime.timeIntervalSince1970)
            let dayStr = getDateFormatter.string(from: dayDate)
            
            // If first iteration
            if prevDate == nil {
                
                let time = Date().timeIntervalSince1970 - beginTimeWithInterval - Double(TimeZone.current.secondsFromGMT())
                
                let newDate = TimeForDay(day: dayDate,
                                         dayStr: dayStr,
                                         time: time)
                printTimeLog.append(newDate)
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
                printTimeLog[printTimeLog.endIndex - 1].time += timeOfRange
            // if it is another day
            } else {
                
                prevDate = dayDate
                let timeOfRange = endTimeWithInterval - beginTimeWithInterval
                let newDate = TimeForDay(day: dayDate,
                                         dayStr: dayStr,
                                         time: timeOfRange)
                printTimeLog.append(newDate)
            }
        }
        return printTimeLog
    }
    
    /*
    String 2020-02-22T19:41:27.000Z
    String 2020-02-22T19:41:27
    DATE   2020-02-22T21:41:27
    String 2020-02-22
    DATE   2020-02-22
    */
    
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
