//
//  FoodLogView.swift
//  Food Watch App
//
//  Created by Jia Chen Yee on 19/7/22.
//

import Foundation
import SwiftUI

struct FoodLogView: View {
    
    var dateEntries: [DateEntry]
    
    var body: some View {
        ScrollViewReader { value in
            LazyHGrid(rows: [.init(.adaptive(minimum: 19), spacing: 3)]) {
                ForEach(dateEntries) { entry in
                    Rectangle()
                        .fill(entry.mealCount == 0 ? .gray : Color.blue.opacity(Double(entry.mealCount) / 3))
                        .cornerRadius(4)
                        .frame(width: 18, height: 18)
                }
            }
            .onAppear {
                guard let lastID = dateEntries.last?.id else { return }
                value.scrollTo(lastID)
            }
        }
        .frame(height: 7 * 22)
    }
}

struct FoodLogView_Previews: PreviewProvider {
    static var previews: some View {
        FoodLogView(dateEntries: [
            .init(date: .now, mealCount: 2),
            .init(date: .now.addingTimeInterval(86400), mealCount: 2),
            .init(date: .now.addingTimeInterval(86400 * 2), mealCount: 0),
            .init(date: .now.addingTimeInterval(86400 * 3), mealCount: 3),
            .init(date: .now, mealCount: 2),
            .init(date: .now.addingTimeInterval(10), mealCount: 2),
            .init(date: .now.addingTimeInterval(20 * 2), mealCount: 0),
            .init(date: .now.addingTimeInterval(30 * 3), mealCount: 3),
            .init(date: .now.addingTimeInterval(30 * 4), mealCount: 4)
        ])
    }
}
