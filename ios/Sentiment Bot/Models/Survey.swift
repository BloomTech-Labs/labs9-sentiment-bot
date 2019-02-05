//
//  Survey.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation

struct Survey: Codable {
    let id: Int
    var schedule: String
    let question: String?
    var feelings: [Feeling]?
    let teamId: Int?
    var time: String
    var startDate: String?
    
    
    
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDateTime = dateFormatter.date(from: self.time)
        dateFormatter.dateFormat = "h:mm:a"
        let formattedStringTime = dateFormatter.string(from: formattedDateTime!)
        return formattedStringTime
    }
    
    func getNextDate(_ stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringDate)
        var nextDate: Date?
        switch self.schedule {
        case Trigger.Daily.rawValue:
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date!)
        case Trigger.Weekly.rawValue:
            nextDate = Calendar.current.date(byAdding: .day, value: 7, to: date!)
        case Trigger.Monthly.rawValue:
            nextDate = Calendar.current.date(byAdding: .month, value: 1, to: date!)
        default:
            nextDate = Date()
        }
        return nextDate!
    }
    
    
    var targetDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let todaysDate = Date()
        let timeArr = self.time.components(separatedBy: ":")
        let hour = Int(timeArr.first!)!
        let minutes = Int(timeArr.last!)!
        var nextDate = todaysDate
        nextDate = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: nextDate)!
        nextDate = Calendar.current.date(byAdding: .hour, value: hour, to: nextDate)!
        nextDate = Calendar.current.date(byAdding: .minute, value: minutes, to: nextDate)!
        while nextDate <= todaysDate {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            nextDate = self.getNextDate(dateFormatter.string(from: nextDate))
        }
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let stringDate = dateFormatter.string(from: nextDate)
        return stringDate
    }
}
