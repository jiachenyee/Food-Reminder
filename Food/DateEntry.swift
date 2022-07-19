//
//  DateEntry.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import Foundation

struct DateEntry: Identifiable {
    var date: Date
    var id: Double {
        date.timeIntervalSince1970
    }
    var mealCount: Int
}
