//
//  DateFormatterHelper.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation

class DateFormatterHelper {
    
    // Static method to convert date string to Date
    static func formattedDate(from dateString: String, withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust timezone if necessary
        return dateFormatter.date(from: dateString)
    }

    // Static method to convert Date to String
    static func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .none
        return dateFormatter.string(from: date)
    }
}
