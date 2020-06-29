//
//  Date+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

extension Date {
    /// returns optional relative date interval string like "2d"
    /// depending on the unitsstyle, see docs at http://apple.co/1ox2sOX
    /// inject an existing NSDateComponentsFormatter() for performance
    func difference(to targetDate: Date = Date(), unitsStyle: DateComponentsFormatter.UnitsStyle = .short) -> String? {
        // inspired by top answer at http://bit.ly/1TzMQqV
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = unitsStyle //.Abbreviated, .Full, ...
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1

        return formatter.string(from: self, to: targetDate)
    }

    var displayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: self)
    }
}
