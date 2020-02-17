//
//  Date+Ext.swift
//  GHFollower
//
//  Created by Philipp on 12.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
